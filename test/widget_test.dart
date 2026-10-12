import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/core/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('smoke: 协议工具函数与口语化时间', () {
    expect(friendlyTime('08:00'), '早上 8 点');
    expect(friendlyTime('20:30'), '晚上 8 点半');
    expect(isValidHhMm('8:05'), isTrue);
    expect(isValidHhMm('25:00'), isFalse);
    expect(extractJsonObject('前缀 {"tool": "x"} 后缀'), {
      'tool': 'x',
    });
  });
}
