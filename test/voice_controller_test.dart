import 'dart:async';

import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/application/controllers/assistant_controller.dart';
import 'package:care_pill/application/controllers/voice_controller.dart';
import 'package:care_pill/application/providers.dart';
import 'package:care_pill/domain/services/speech_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/agent_fixture.dart';
import 'fakes/fakes.dart';

class HeldSpeechFake extends FakeSpeechService {
  Completer<SpeechAvailability>? preparing;
  Completer<SpeechResult>? finalizing;
  int cancelCount = 0;
  @override
  Future<SpeechAvailability> startListening({
    void Function(String)? onPartial,
    void Function()? onLimit,
    void Function(SpeechIssue)? onIssue,
  }) async => preparing?.future ?? const SpeechAvailability();
  @override
  Future<SpeechResult> finishListening() async =>
      finalizing?.future ?? const SpeechResult(text: '语音问题');
  @override
  Future<void> cancelListening() async {
    cancelCount++;
  }
}

void main() {
  late AgentFixture f;
  late ScriptedClient client;
  late HeldSpeechFake speech;
  late ProviderContainer container;
  late VoiceController voice;
  setUp(() async {
    f = AgentFixture();
    await f.initialize();
    client = ScriptedClient([textResult('回答')]);
    speech = HeldSpeechFake();
    container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(f.chats),
        agentStoreProvider.overrideWithValue(f.store),
        agentServiceProvider.overrideWithValue(f.agent(client)),
        speechServiceProvider.overrideWithValue(speech),
      ],
    );
    await container.read(assistantControllerProvider.future);
    voice = container.read(voiceControllerProvider.notifier);
    await voice.setVisible(true);
  });
  tearDown(() => container.dispose());
  test('hold then release sends exactly once and reads reply', () async {
    await voice.press();
    await Future<void>.delayed(const Duration(milliseconds: 310));
    await Future.wait([voice.release(), voice.release()]);
    expect(client.requests, hasLength(1));
    expect(speech.spoken, ['回答']);
    expect(container.read(voiceControllerProvider).phase, VoicePhase.idle);
  });
  test('short press and upward cancel never send', () async {
    await voice.press();
    await voice.release();
    expect(client.requests, isEmpty);
    await voice.press();
    voice.drag(70);
    await voice.release();
    expect(client.requests, isEmpty);
    expect(speech.cancelCount, greaterThan(0));
  });
  test(
    'release during permission initialization does not record or send later',
    () async {
      speech.preparing = Completer<SpeechAvailability>();
      final press = voice.press();
      await Future<void>.delayed(Duration.zero);
      await voice.release();
      speech.preparing!.complete(const SpeechAvailability());
      await press;
      expect(client.requests, isEmpty);
      expect(container.read(voiceControllerProvider).phase, VoicePhase.idle);
    },
  );
  test('hidden retained page discards pending recognition', () async {
    speech.finalizing = Completer<SpeechResult>();
    await voice.press();
    await Future<void>.delayed(const Duration(milliseconds: 310));
    final released = voice.release();
    await Future<void>.delayed(Duration.zero);
    await voice.setVisible(false);
    speech.finalizing!.complete(const SpeechResult(text: 'late text'));
    await released;
    expect(client.requests, isEmpty);
    expect(speech.spoken, isEmpty);
  });
  test('model reply persists after navigating away but never speaks on hidden page', () async {
    final response = Completer<AiChatResult>(), started = Completer<void>();
    client.responder = (_) {
      started.complete();
      return response.future;
    };
    await voice.press();
    await Future<void>.delayed(const Duration(milliseconds: 310));
    final release = voice.release();
    await started.future;
    await voice.setVisible(false);
    response.complete(textResult('late answer'));
    await release;
    expect(f.chats.messages.last.content, 'late answer');
    expect(speech.spoken, isEmpty);
    await voice.setVisible(true);
    expect(speech.spoken, isEmpty);
  });
}
