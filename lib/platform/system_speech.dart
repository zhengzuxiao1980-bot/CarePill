import 'dart:async';
import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/settings/app_settings.dart';
import '../domain/services/speech_service.dart';
import '../i18n/strings.g.dart';

/// Injectable plugin boundaries; tests drive real lifecycle logic without audio hardware.
abstract interface class RecognitionEngine {
  Future<bool> initialize(
    void Function(String) status,
    void Function(String) error,
  );
  Future<List<String>> locales();
  Future<void> listen(String locale, void Function(String, bool) result);
  Future<void> stop();
  Future<void> cancel();
}

class SystemRecognitionEngine implements RecognitionEngine {
  final SpeechToText _engine = SpeechToText();
  @override
  Future<bool> initialize(
    void Function(String) status,
    void Function(String) error,
  ) async {
    try {
      final ready = await _engine.initialize(
        onStatus: status,
        onError: (e) => error(e.errorMsg),
      );
      if (!ready) {
        error(
          await _engine.hasPermission
              ? 'recognizer_not_available'
              : 'permission_denied',
        );
      }
      return ready;
    } catch (e) {
      error(e.toString());
      return false;
    }
  }

  @override
  Future<List<String>> locales() async =>
      (await _engine.locales()).map((l) => l.localeId).toList();
  @override
  Future<void> listen(String locale, void Function(String, bool) result) =>
      _engine.listen(
        onResult: (r) => result(r.recognizedWords, r.finalResult),
        listenOptions: SpeechListenOptions(
          localeId: locale,
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.dictation,
        ),
      );
  @override
  Future<void> stop() => _engine.stop();
  @override
  Future<void> cancel() => _engine.cancel();
}

abstract interface class PlaybackEngine {
  Future<bool> configure(String locale, double rate);
  Future<bool> speak(String text);
  Future<void> stop();
}

class SystemPlaybackEngine implements PlaybackEngine {
  final FlutterTts _engine = FlutterTts();
  @override
  Future<bool> configure(String locale, double rate) async {
    final available = await _engine.isLanguageAvailable(locale);
    if (available != true && available != 1) return false;
    final language = await _engine.setLanguage(locale);
    if (language != 1 && language != true) return false;
    for (final result in [
      await _engine.setSpeechRate(rate),
      await _engine.setPitch(1),
      await _engine.setVolume(1),
    ]) {
      if (result != 1 && result != true) return false;
    }
    if (Platform.isIOS) {
      await _engine.setSharedInstance(true);
      await _engine.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.duckOthers,
      ], IosTextToSpeechAudioMode.defaultMode);
    }
    await _engine.awaitSpeakCompletion(true);
    return true;
  }

  @override
  Future<bool> speak(String text) async {
    final done = Completer<bool>();
    _engine.setCompletionHandler(() {
      if (!done.isCompleted) done.complete(true);
    });
    _engine.setCancelHandler(() {
      if (!done.isCompleted) done.complete(false);
    });
    _engine.setErrorHandler((_) {
      if (!done.isCompleted) done.complete(false);
    });
    unawaited(
      _engine
          .speak(text)
          .then((result) {
            if (result != 1 && result != true && !done.isCompleted) {
              done.complete(false);
            }
          })
          .catchError((Object _) {
            if (!done.isCompleted) done.complete(false);
          }),
    );
    return done.future;
  }

  @override
  Future<void> stop() async {
    await _engine.stop();
  }
}

class SystemSpeechService implements SpeechService {
  SystemSpeechService({
    required SettingsService settings,
    RecognitionEngine? recognition,
    PlaybackEngine? playback,
    this.finalWait = const Duration(seconds: 2),
    this.maxHold = const Duration(seconds: 60),
  }) : _settings = settings,
       _recognizer = recognition ?? SystemRecognitionEngine(),
       _playback = playback ?? SystemPlaybackEngine();
  final SettingsService _settings;
  final RecognitionEngine _recognizer;
  final PlaybackEngine _playback;
  final Duration finalWait, maxHold;
  Future<bool>? _initializing;
  bool _ready = false, _holding = false, _started = false;
  int _session = 0, _segment = 0, _playVersion = 0;
  SpeechIssue? _issue;
  SpeechOwner? _owner;
  Completer<void>? _playCancelled;
  Completer<void>? _final;
  final _segments = <String>[];
  String _partial = '';
  Timer? _limitTimer;
  Timer? _restartTimer;
  Timer? _settleTimer;
  bool _receivedFinal = false, _nativeDone = false, _usedPartial = false;
  Future<SpeechResult>? _ending;
  void Function(String)? _onPartial;
  void Function(SpeechIssue)? _onIssue;
  String get _text =>
      [..._segments, if (_partial.trim().isNotEmpty) _partial.trim()].join(' ');
  String get _locale =>
      LocaleSettings.currentLocale == AppLocale.en ? 'en-US' : 'zh-CN';

  Future<bool> _initialize() {
    if (_ready) return Future.value(true);
    return _initializing ??= _recognizer
        .initialize(_status, _error)
        .then((value) {
          _ready = value;
          return value;
        })
        .catchError((Object _) {
          return false;
        })
        .whenComplete(() => _initializing = null);
  }

  @override
  Future<bool> isListeningAvailable() async {
    // Capability discovery must not request permission just because a page builds.
    return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
  }

  SpeechIssue _classify(String error) {
    final value = error.toLowerCase();
    if (value.contains('permission') || value.contains('not_allowed')) {
      return SpeechIssue.permissionDenied;
    }
    if (value.contains('language') || value.contains('locale')) {
      return SpeechIssue.languageMissing;
    }
    if (value.contains('network')) return SpeechIssue.network;
    if (value.contains('no_match') || value.contains('speech_timeout')) {
      return SpeechIssue.noSpeech;
    }
    if (value.contains('not_available') || value.contains('unavailable')) {
      return SpeechIssue.unavailable;
    }
    return SpeechIssue.engine;
  }

  void _error(String error) {
    if (!_holding && !_started) return;
    final issue = _classify(error);
    // A native silence timeout ends a segment, not the whole held gesture.
    if (issue == SpeechIssue.noSpeech && _holding) {
      _doneSegment();
      return;
    }
    _issue = issue;
    _holding = false;
    _onIssue?.call(issue);
    if (_final?.isCompleted == false) _final!.complete();
  }

  void _status(String status) {
    if (status != 'done' || !_started) return;
    _nativeDone = true;
    if (_receivedFinal) {
      _doneSegment();
    } else {
      // Some engines deliver done before their final transcript.
      _settleTimer?.cancel();
      final session = _session, segment = _segment;
      _settleTimer = Timer(finalWait, () {
        if (session == _session && segment == _segment) _doneSegment();
      });
    }
  }

  void _doneSegment() {
    if (!_started) return;
    _started = false;
    _settleTimer?.cancel();
    if (!_receivedFinal && _partial.trim().isNotEmpty) _usedPartial = true;
    if (_partial.trim().isNotEmpty) _segments.add(_partial.trim());
    _partial = '';
    if (_final?.isCompleted == false) _final!.complete();
    if (_holding) {
      final session = _session;
      _restartTimer?.cancel();
      _restartTimer = Timer(const Duration(milliseconds: 120), () {
        if (session == _session && _holding) unawaited(_startSegment(session));
      });
    }
  }

  Future<void> _startSegment(int session) async {
    if (!_holding || session != _session) return;
    _started = true;
    _receivedFinal = false;
    _nativeDone = false;
    final segment = ++_segment;
    _partial = '';
    _final = Completer<void>();
    try {
      await _recognizer.listen(_locale.replaceAll('-', '_'), (
        text,
        finalResult,
      ) {
        if (session != _session || segment != _segment || !_started) return;
        if (_receivedFinal) return;
        _partial = text;
        _onPartial?.call(_text);
        if (finalResult) {
          _receivedFinal = true;
          if (!_holding || _nativeDone) {
            _doneSegment();
          } else {
            // Do not start the next segment until native done has arrived.
            // A bounded fallback handles engines that omit the status callback.
            _settleTimer?.cancel();
            _settleTimer = Timer(finalWait, () {
              if (session == _session && segment == _segment) _doneSegment();
            });
          }
        }
      });
    } catch (_) {
      if (session == _session) _error('engine');
    }
  }

  @override
  Future<SpeechAvailability> startListening({
    void Function(String)? onPartial,
    void Function()? onLimit,
    void Function(SpeechIssue)? onIssue,
  }) async {
    if (_owner == SpeechOwner.reminder) {
      return const SpeechAvailability(issue: SpeechIssue.unavailable);
    }
    final session = ++_session;
    _limitTimer?.cancel();
    _restartTimer?.cancel();
    _started = false;
    ++_segment;
    _holding = true;
    _issue = null;
    _segments.clear();
    _usedPartial = false;
    _settleTimer?.cancel();
    _partial = '';
    _ending = null;
    _onPartial = onPartial;
    _onIssue = onIssue;
    if (_ready) await _recognizer.cancel();
    await stopSpeak(owner: SpeechOwner.assistant);
    if (!_holding || session != _session) {
      return const SpeechAvailability(issue: SpeechIssue.cancelled);
    }
    final ready = await _initialize();
    if (!_holding || session != _session) {
      return SpeechAvailability(issue: _issue ?? SpeechIssue.cancelled);
    }
    if (!ready) {
      _holding = false;
      return SpeechAvailability(issue: _issue ?? SpeechIssue.permissionDenied);
    }
    try {
      final locales = await _recognizer.locales();
      if (locales.isNotEmpty &&
          !locales.any(
            (l) =>
                l.replaceAll('_', '-').toLowerCase() == _locale.toLowerCase(),
          )) {
        _holding = false;
        return const SpeechAvailability(issue: SpeechIssue.languageMissing);
      }
    } catch (_) {
      /* Some system engines cannot enumerate locales; listen reports support. */
    }
    if (!_holding || session != _session) {
      return const SpeechAvailability(issue: SpeechIssue.cancelled);
    }
    _limitTimer = Timer(maxHold, () {
      onLimit?.call();
      unawaited(finishListening());
    });
    await _startSegment(session);
    return SpeechAvailability(issue: _issue);
  }

  @override
  Future<SpeechResult> finishListening() => _ending ??= _finish();
  Future<SpeechResult> _finish() async {
    final session = _session;
    _holding = false;
    _limitTimer?.cancel();
    _restartTimer?.cancel();
    if (!_started && _segments.isEmpty && _partial.isEmpty) {
      ++_session;
      return SpeechResult(issue: _issue ?? SpeechIssue.noSpeech);
    }
    var partial = false;
    try {
      if (_started) {
        if (_receivedFinal) _doneSegment();
        await _recognizer.stop().timeout(finalWait);
        if (_final?.isCompleted == false) {
          await _final!.future.timeout(
            finalWait,
            onTimeout: () {
              partial = true;
            },
          );
        }
      }
    } catch (_) {
      _issue ??= SpeechIssue.engine;
    }
    if (session != _session) {
      return const SpeechResult(issue: SpeechIssue.cancelled);
    }
    final text = _text.trim();
    _started = false;
    ++_segment;
    return SpeechResult(
      text: text,
      issue: _issue ?? (text.isEmpty ? SpeechIssue.noSpeech : null),
      usedPartial: partial || _usedPartial,
    );
  }

  @override
  Future<void> cancelListening() async {
    ++_session;
    _holding = false;
    _started = false;
    ++_segment;
    _limitTimer?.cancel();
    _restartTimer?.cancel();
    _settleTimer?.cancel();
    if (_final?.isCompleted == false) _final!.complete();
    _ending = null;
    try {
      if (_ready) await _recognizer.cancel();
    } catch (_) {}
  }

  @override
  Future<String?> listen({
    void Function(String)? onPartial,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final availability = await startListening(onPartial: onPartial);
    if (!availability.available) return null;
    await Future<void>.delayed(timeout);
    final result = await finishListening();
    return result.canSend ? result.text : null;
  }

  @override
  Future<void> stopListening() async {
    await finishListening();
  }

  @override
  Future<SpeechPlaybackResult> speak(
    String text, {
    SpeechOwner owner = SpeechOwner.assistant,
  }) async {
    if (!_settings.ttsEnabled || text.trim().isEmpty) {
      return const SpeechPlaybackResult(PlaybackStatus.disabled);
    }
    if (owner == SpeechOwner.assistant &&
        (_owner == SpeechOwner.reminder || _holding || _started)) {
      return const SpeechPlaybackResult(PlaybackStatus.cancelled);
    }
    final version = ++_playVersion;
    if (_playCancelled?.isCompleted == false) _playCancelled!.complete();
    _owner = owner;
    _playCancelled = Completer<void>();
    final cancelled = _playCancelled!.future;
    if (owner == SpeechOwner.reminder) {
      if (_holding || _started) _onIssue?.call(SpeechIssue.cancelled);
      await cancelListening();
    }
    try {
      await _playback.stop();
      if (version != _playVersion) {
        return const SpeechPlaybackResult(PlaybackStatus.cancelled);
      }
      final rate = Platform.isIOS
          ? (_settings.ttsRate * .5).clamp(.1, 1.0)
          : _settings.ttsRate;
      if (!await _playback.configure(_locale, rate)) {
        return const SpeechPlaybackResult(
          PlaybackStatus.failed,
          issue: SpeechIssue.languageMissing,
        );
      }
      if (version != _playVersion) {
        return const SpeechPlaybackResult(PlaybackStatus.cancelled);
      }
      final result = await Future.any([
        _playback.speak(text),
        cancelled.then((_) => false),
      ]);
      return SpeechPlaybackResult(
        version != _playVersion
            ? PlaybackStatus.cancelled
            : result
            ? PlaybackStatus.completed
            : PlaybackStatus.failed,
      );
    } catch (_) {
      return const SpeechPlaybackResult(
        PlaybackStatus.failed,
        issue: SpeechIssue.engine,
      );
    } finally {
      if (version == _playVersion) {
        _owner = null;
        _playCancelled = null;
      }
    }
  }

  @override
  Future<void> stopSpeak({SpeechOwner? owner}) async {
    if (owner != null && _owner != owner) return;
    ++_playVersion;
    if (_playCancelled?.isCompleted == false) _playCancelled!.complete();
    _owner = null;
    try {
      await _playback.stop();
    } catch (_) {}
  }
}
