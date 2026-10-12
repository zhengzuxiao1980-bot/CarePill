import 'dart:async';

import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/services/speech_service.dart';
import 'package:care_pill/platform/system_speech.dart';
import 'package:flutter_test/flutter_test.dart';

class RecognitionFake implements RecognitionEngine {
  Completer<bool>? initialization;
  void Function(String)? status, error;
  final listeners = <void Function(String, bool)>[];
  Future<void> Function()? onStop;
  int cancellations = 0;
  @override
  Future<bool> initialize(
    void Function(String) s,
    void Function(String) e,
  ) async {
    status = s;
    error = e;
    return initialization?.future ?? true;
  }

  @override
  Future<List<String>> locales() async => ['zh_CN', 'en_US'];
  @override
  Future<void> listen(String locale, void Function(String, bool) result) async {
    listeners.add(result);
  }

  @override
  Future<void> stop() async {
    await onStop?.call();
  }

  @override
  Future<void> cancel() async {
    cancellations++;
  }
}

class PlaybackFake implements PlaybackEngine {
  final completions = <Completer<bool>>[];
  final spoken = <String>[];
  bool available = true;
  @override
  Future<bool> configure(String locale, double rate) async => available;
  @override
  Future<bool> speak(String text) {
    spoken.add(text);
    final c = Completer<bool>();
    completions.add(c);
    return c.future;
  }

  @override
  Future<void> stop() async {}
}

void main() {
  late RecognitionFake recognition;
  late PlaybackFake playback;
  late SystemSpeechService service;
  setUp(() {
    recognition = RecognitionFake();
    playback = PlaybackFake();
    service = SystemSpeechService(
      settings: SettingsService(InMemoryKeyValueStore()),
      recognition: recognition,
      playback: playback,
      finalWait: const Duration(milliseconds: 20),
    );
  });
  tearDown(() async {
    await service.cancelListening();
    await service.stopSpeak();
  });
  test('final result arriving after stop is returned, not lost', () async {
    await service.startListening();
    recognition.listeners.last('部分', false);
    final stopped = service.finishListening();
    await Future<void>.delayed(const Duration(milliseconds: 2));
    recognition.listeners.last('完整结果', true);
    final result = await stopped;
    expect(result.text, '完整结果');
    expect(result.canSend, isTrue);
  });
  test(
    'missing final callback uses last partial once and stop is idempotent',
    () async {
      await service.startListening();
      recognition.listeners.last('已经识别的文字', false);
      final a = service.finishListening(), b = service.finishListening();
      expect(identical(a, b), isTrue);
      expect((await a).text, '已经识别的文字');
      expect((await b).usedPartial, isTrue);
    },
  );
  test(
    'release during permission dialog never starts recognizer later',
    () async {
      recognition.initialization = Completer<bool>();
      final starting = service.startListening();
      await Future<void>.delayed(Duration.zero);
      await service.cancelListening();
      recognition.initialization!.complete(true);
      expect((await starting).issue, SpeechIssue.cancelled);
      expect(recognition.listeners, isEmpty);
    },
  );
  test('cancel ignores late callback from previous recording', () async {
    await service.startListening();
    final old = recognition.listeners.last;
    await service.cancelListening();
    await service.startListening();
    old('不应发送', true);
    recognition.listeners.last('新一轮', true);
    expect((await service.finishListening()).text, '新一轮');
  });
  test('engine failure preserves text but forbids auto send', () async {
    await service.startListening();
    recognition.listeners.last('请帮我', false);
    recognition.error!('error_network');
    final result = await service.finishListening();
    expect(result.text, '请帮我');
    expect(result.issue, SpeechIssue.network);
    expect(result.canSend, isFalse);
  });
  test(
    'native segments concatenate once while held, silence does not auto send',
    () async {
      await service.startListening();
      final first = recognition.listeners.last;
      first('第一句', true);
      first('第一句', true);
      recognition.status!('done');
      await Future<void>.delayed(const Duration(milliseconds: 140));
      expect(recognition.listeners, hasLength(2));
      recognition.listeners.last('第二句', true);
      expect((await service.finishListening()).text, '第一句 第二句');
    },
  );
  test('final text waits for native done before restarting; done before final retains final text', () async {
    service = SystemSpeechService(
      settings: SettingsService(InMemoryKeyValueStore()),
      recognition: recognition,
      playback: playback,
    );
    await service.startListening();
    final first = recognition.listeners.last;
    first('第一段', true);
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(recognition.listeners, hasLength(1));
    recognition.status!('done');
    await Future<void>.delayed(const Duration(milliseconds: 140));
    expect(recognition.listeners, hasLength(2));
    first('迟到旧段', true);
    recognition.listeners.last('中间', false);
    recognition.status!('done');
    final finishing = service.finishListening();
    recognition.listeners.last('第二段完整', true);
    expect((await finishing).text, '第一段 第二段完整');
  });
  test(
    'maximum hold stops acquisition but retains result until release',
    () async {
      service = SystemSpeechService(
        settings: SettingsService(InMemoryKeyValueStore()),
        recognition: recognition,
        playback: playback,
        maxHold: const Duration(milliseconds: 10),
        finalWait: const Duration(milliseconds: 5),
      );
      var limit = false;
      await service.startListening(onLimit: () => limit = true);
      recognition.listeners.last('保留到松手', false);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(limit, isTrue);
      expect((await service.finishListening()).text, '保留到松手');
    },
  );
  test(
    'TTS future waits for completion, stop cancels without waiting for engine',
    () async {
      var completed = false;
      final speaking = service.speak('一段很长的话').then((r) {
        completed = true;
        return r;
      });
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);
      playback.completions.single.complete(true);
      expect((await speaking).status, PlaybackStatus.completed);
      final second = service.speak('第二段');
      await Future<void>.delayed(Duration.zero);
      await service.stopSpeak(owner: SpeechOwner.assistant);
      expect((await second).status, PlaybackStatus.cancelled);
    },
  );
  test(
    'reminder preempts recording and assistant cannot stop reminder',
    () async {
      await service.startListening();
      final result = service.speak('该吃药了', owner: SpeechOwner.reminder);
      await Future<void>.delayed(Duration.zero);
      expect((await service.startListening()).available, isFalse);
      expect((await service.speak('助手')).status, PlaybackStatus.cancelled);
      await service.stopSpeak(owner: SpeechOwner.assistant);
      playback.completions.single.complete(true);
      expect((await result).status, PlaybackStatus.completed);
    },
  );
  test('missing TTS language is an explicit failure', () async {
    playback.available = false;
    expect((await service.speak('hello')).issue, SpeechIssue.languageMissing);
    expect(playback.spoken, isEmpty);
  });
}
