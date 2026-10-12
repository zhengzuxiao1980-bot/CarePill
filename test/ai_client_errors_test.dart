import 'package:care_pill/ai/client/ai_client.dart';
import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/core/cancellation.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/agent_fixture.dart';

void main() {
  for (final scenario in [
    (401, 'tools unsupported', AiErrorCode.authentication),
    (403, 'forbidden', AiErrorCode.authentication),
    (429, 'tools unsupported', AiErrorCode.rateLimited),
    (400, 'tools are not supported', AiErrorCode.capabilityMissing),
    (400, 'maximum context length exceeded', AiErrorCode.contextLength),
    (400, 'invalid tools schema', AiErrorCode.protocol),
    (500, 'server failure', AiErrorCode.protocol),
  ]) {
    test('HTTP ${scenario.$1} ${scenario.$2} maps precisely', () async {
      final dio = Dio();
      addTearDown(() => dio.close(force: true));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.badResponse,
                response: Response<Map<String, dynamic>>(
                  requestOptions: request,
                  statusCode: scenario.$1,
                  data: {
                    'error': {'message': scenario.$2},
                  },
                ),
              ),
            );
          },
        ),
      );
      await expectLater(
        OpenAiCompatibleClient(dio: dio).chat(
          const AiChatRequest(model: 'test', messages: []),
          config: const AiClientConfig(
            baseUrl: 'https://example.test',
            apiKey: 'test-only',
            modelId: 'test',
          ),
        ),
        throwsA(isA<AiException>().having((e) => e.code, 'code', scenario.$3)),
      );
    });
  }
  test(
    'authentication failure never falls back or performs local writes',
    () async {
      final fixture = AgentFixture();
      await fixture.initialize();
      final client = ScriptedClient([
        const AiException(AiErrorCode.authentication),
      ]);
      final result = await fixture.agent(client).handleUserInput('帮我记上测试药');
      expect(result.error, isA<AiException>());
      expect(result.writes, isEmpty);
      expect(client.requests, hasLength(1));
    },
  );
  test('pre-cancelled requests never reach transport', () async {
    final signal = CancellationSignal()..cancel();
    await expectLater(
      OpenAiCompatibleClient().chat(
        AiChatRequest(model: 'test', messages: const [], cancellation: signal),
        config: const AiClientConfig(
          baseUrl: 'https://example.test',
          apiKey: '',
          modelId: 'test',
        ),
      ),
      throwsA(isA<OperationCancelled>()),
    );
  });
}
