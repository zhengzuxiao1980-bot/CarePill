import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/speech_service.dart';
import '../../i18n/strings.g.dart';
import '../providers.dart';
import 'assistant_controller.dart';

enum VoicePhase { idle, preparing, recording, finalizing, sending, speaking }

class VoiceState {
  const VoiceState({
    this.phase = VoicePhase.idle,
    this.text = '',
    this.notice = '',
    this.cancelled = false,
    this.issue,
  });
  final VoicePhase phase;
  final String text, notice;
  final bool cancelled;
  final SpeechIssue? issue;
  String get statusLabel => notice.isNotEmpty
      ? notice
      : cancelled
      ? tr.agentV2.cancelRecording
      : switch (phase) {
          VoicePhase.idle => tr.agentV2.hold,
          VoicePhase.preparing => tr.agentV2.preparing,
          VoicePhase.recording => tr.agentV2.recording,
          VoicePhase.finalizing => tr.agentV2.finalizing,
          VoicePhase.sending => tr.agentV2.thinking,
          VoicePhase.speaking => tr.agentV2.speaking,
        };
  bool get recording =>
      phase == VoicePhase.recording || phase == VoicePhase.preparing;
}

class VoiceController extends Notifier<VoiceState> {
  bool _visible = false, _held = false;
  int _gesture = 0;
  Stopwatch? _watch;
  @override
  VoiceState build() {
    final speech = ref.read(speechServiceProvider);
    ref.onDispose(() {
      unawaited(speech.cancelListening());
      unawaited(speech.stopSpeak(owner: SpeechOwner.assistant));
    });
    return const VoiceState();
  }

  Future<void> setVisible(bool visible) async {
    _visible = visible;
    if (!visible) {
      _held = false;
      final gesture = ++_gesture;
      await ref.read(speechServiceProvider).cancelListening();
      await ref
          .read(speechServiceProvider)
          .stopSpeak(owner: SpeechOwner.assistant);
      if (ref.mounted && gesture == _gesture) state = const VoiceState();
    }
  }

  Future<void> press() async {
    if (!_visible ||
        _held ||
        ref.read(assistantControllerProvider).value?.busy == true ||
        state.phase == VoicePhase.finalizing) {
      return;
    }
    final gesture = ++_gesture;
    _held = true;
    _watch = Stopwatch()..start();
    state = const VoiceState(phase: VoicePhase.preparing);
    final available = await ref
        .read(speechServiceProvider)
        .startListening(
          onPartial: (text) {
            if (ref.mounted && gesture == _gesture) {
              state = VoiceState(
                phase: state.phase,
                text: text,
                notice: state.notice,
                cancelled: state.cancelled,
                issue: state.issue,
              );
            }
          },
          onLimit: () {
            if (ref.mounted && gesture == _gesture) {
              state = VoiceState(
                phase: state.phase,
                text: state.text,
                notice: tr.agentV2.maxRecording,
                cancelled: state.cancelled,
                issue: state.issue,
              );
            }
          },
          onIssue: (issue) {
            if (ref.mounted && gesture == _gesture) {
              if (issue == SpeechIssue.cancelled) {
                _held = false;
                _gesture++;
                state = const VoiceState();
              } else {
                state = VoiceState(
                  phase: state.phase,
                  text: state.text,
                  notice: speechIssueText(issue),
                  cancelled: state.cancelled,
                  issue: issue,
                );
              }
            }
          },
        );
    if (!ref.mounted || gesture != _gesture || !_held) return;
    state = VoiceState(
      phase: available.available ? VoicePhase.recording : VoicePhase.idle,
      text: state.text,
      notice: available.issue == null ? '' : speechIssueText(available.issue!),
      issue: available.issue,
    );
    if (!available.available) _held = false;
  }

  void drag(double upward) {
    if (!_held) return;
    state = VoiceState(
      phase: state.phase,
      text: state.text,
      notice: state.notice,
      cancelled: upward >= 64,
      issue: state.issue,
    );
  }

  Future<void> cancel() async {
    final gesture = ++_gesture;
    _held = false;
    await ref.read(speechServiceProvider).cancelListening();
    if (ref.mounted && gesture == _gesture) state = const VoiceState();
  }

  Future<void> release() async {
    if (!_held) return;
    _held = false;
    final gesture = _gesture;
    final speech = ref.read(speechServiceProvider);
    if (state.cancelled ||
        (_watch?.elapsedMilliseconds ?? 0) < 300 ||
        state.phase == VoicePhase.preparing) {
      final notice = state.cancelled ? '' : tr.agentV2.tooShort;
      await cancel();
      if (ref.mounted) state = VoiceState(notice: notice);
      return;
    }
    state = VoiceState(phase: VoicePhase.finalizing, text: state.text);
    final result = await speech.finishListening();
    if (!ref.mounted || gesture != _gesture || !_visible) return;
    if (!result.canSend) {
      state = VoiceState(
        text: result.text,
        notice: speechIssueText(result.issue ?? SpeechIssue.noSpeech),
        issue: result.issue,
      );
      return;
    }
    state = VoiceState(phase: VoicePhase.sending, text: result.text);
    final ok = await ref
        .read(assistantControllerProvider.notifier)
        .send(result.text);
    if (!ref.mounted || gesture != _gesture || !_visible) return;
    if (!ok) {
      state = VoiceState(text: result.text);
      return;
    }
    final reply = ref.read(assistantControllerProvider).value?.reply ?? '';
    state = VoiceState(phase: VoicePhase.speaking, text: result.text);
    final playback = await speech.speak(reply);
    if (!ref.mounted || gesture != _gesture || !_visible) return;
    state = VoiceState(
      issue: playback.issue,
      notice: playback.status == PlaybackStatus.failed
          ? tr.agentV2.ttsFailed
          : '',
    );
  }
}

final voiceControllerProvider = NotifierProvider<VoiceController, VoiceState>(
  VoiceController.new,
);
