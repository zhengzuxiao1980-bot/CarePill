import 'package:care_pill/ai/client/ai_client.dart';
import 'package:care_pill/ai/client/ai_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<RequestOptions> requests;
  late OpenAiCompatibleClient client;

  setUp(() {
    requests = [];
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: request,
              statusCode: 200,
              data: {
                'choices': [
                  {
                    'message': {
                      'role': 'assistant',
                      'content': 'A medicine box',
                    },
                    'finish_reason': 'stop',
                  },
                ],
              },
            ),
          );
        },
      ),
    );
    client = OpenAiCompatibleClient(dio: dio);
    addTearDown(() => dio.close(force: true));
  });

  test('Flash vision sends the official base64 image_url format', () async {
    final result = await client.vision(
      const AiChatRequest(
        model: 'deepseek-flash',
        maxTokens: 500,
        messages: [
          AiProtocolMessage(
            role: AiRole.user,
            contentParts: [
              AiContentPart.text('这张图片里有什么？'),
              AiContentPart.imageUrl('data:image/jpeg;base64,/9j/2Q=='),
            ],
          ),
        ],
      ),
      config: const AiClientConfig(
        baseUrl: 'https://api.deepseek.com',
        apiKey: 'test-only-key',
        modelId: 'deepseek-flash',
      ),
    );
    expect(
      requests.single.uri.toString(),
      'https://api.deepseek.com/chat/completions',
    );
    expect(requests.single.data, {
      'model': 'deepseek-flash',
      'max_tokens': 500,
      'thinking': {'type': 'disabled'},
      'messages': [
        {
          'role': 'user',
          'content': [
            {'type': 'text', 'text': '这张图片里有什么？'},
            {
              'type': 'image_url',
              'image_url': {'url': 'data:image/jpeg;base64,/9j/2Q=='},
            },
          ],
        },
      ],
    });
    expect(result.message.text, 'A medicine box');
  });

  for (final model in [
    'deepseek-flash',
    'deepseek-v4-pro',
    'deepseek-v4-flash',
    'deepseek-v4-flash-vision-exp',
  ]) {
    test(
      '$model uses non-thinking mode across tool turns and /v1 URLs',
      () async {
        const tools = [
          AiToolSchema(
            name: 'get_dose_status',
            description: 'Read dose status',
            parameters: {'type': 'object', 'properties': <String, dynamic>{}},
          ),
        ];
        final messages = <AiProtocolMessage>[
          const AiProtocolMessage(role: AiRole.user, content: 'Taken today?'),
        ];
        for (var round = 0; round < 2; round++) {
          await client.chat(
            AiChatRequest(
              model: model,
              messages: List.of(messages),
              tools: tools,
            ),
            config: AiClientConfig(
              baseUrl: 'https://api.deepseek.com/v1/',
              apiKey: 'test-only-key',
              modelId: model,
              maxTokens: 500,
            ),
          );
          messages.addAll(const [
            AiProtocolMessage(
              role: AiRole.assistant,
              toolCalls: [
                AiToolCall(
                  id: 'call-1',
                  name: 'get_dose_status',
                  argumentsJson: '{}',
                ),
              ],
            ),
            AiProtocolMessage(
              role: AiRole.tool,
              toolCallId: 'call-1',
              content: '{"taken":true}',
            ),
          ]);
        }
        for (final request in requests) {
          expect(
            request.uri.toString(),
            'https://api.deepseek.com/v1/chat/completions',
          );
          final body = request.data as Map<String, dynamic>;
          expect(body['thinking'], {'type': 'disabled'});
          expect(body['max_tokens'], 500);
          expect(body['tool_choice'], 'auto');
          expect(body['tools'], hasLength(1));
        }
      },
    );
  }

  for (final (baseUrl, model) in [
    ('https://example.com/v1', 'deepseek-flash'),
    ('https://api.deepseek.com.proxy.example/v1', 'deepseek-flash'),
    ('https://openrouter.ai/api/v1', 'deepseek/deepseek-flash'),
    ('https://api.deepseek.com', 'custom-model'),
  ]) {
    test(
      'Preserves provider-specific requests for $baseUrl / $model',
      () async {
        await client.chat(
          AiChatRequest(
            model: model,
            messages: const [
              AiProtocolMessage(role: AiRole.user, content: 'Hello'),
            ],
          ),
          config: AiClientConfig(
            baseUrl: baseUrl,
            apiKey: 'test-only-key',
            modelId: model,
          ),
        );
        final body = requests.single.data as Map<String, dynamic>;
        expect(body.containsKey('thinking'), isFalse);
        expect(body['model'], model);
        expect(requests.single.uri.toString(), '$baseUrl/chat/completions');
      },
    );
  }
}
