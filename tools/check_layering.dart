// 分层依赖检查（docs/04 §7：不靠自觉，用脚本约束 import 方向）。
//
// 运行：dart run tools/check_layering.dart
// CI 中与 flutter analyze / flutter test 一起执行；发现违例以非零码退出。
import 'dart:io';

final class _Rule {
  const _Rule(this.scope, this.forbiddenPrefixes, this.reason);

  /// 作用的目录前缀，如 lib/domain/
  final String scope;

  /// 禁止的 import 前缀（dart: / package: / 相对路径均按此匹配）
  final List<String> forbiddenPrefixes;
  final String reason;
}

final List<_Rule> _rules = [
  _Rule(
    'lib/domain/',
    [
      'package:flutter/',
      'package:flutter_riverpod/',
      'package:care_pill/ui/',
      'package:care_pill/application/',
    ],
    '领域层必须纯 Dart，只依赖 core/data(models接口)/ai（docs/04 §7）',
  ),
  _Rule(
    'lib/ai/',
    [
      'package:care_pill/ui/',
      'package:care_pill/application/',
    ],
    'ai/ 只被调用，不碰 UI（docs/04 §7）',
  ),
  _Rule(
    'lib/data/',
    [
      'package:care_pill/ui/',
      'package:care_pill/application/',
    ],
    '数据层不反向依赖表现/应用层（docs/04 §7）',
  ),
  _Rule(
    'lib/ui/',
    [
      'package:care_pill/data/db/',
      'package:care_pill/data/repositories/',
      'package:care_pill/data/backup/',
    ],
    'UI 禁止直查 DB/仓库，必须走 application providers（docs/04 §7）',
  ),
  _Rule(
    'lib/background/',
    [
      'package:care_pill/ui/',
    ],
    'background/ 只做入口转发，不写业务不碰页面（docs/04 §7）',
  ),
];

int violations = 0;

void main() {
  final dartFiles = <String>[];
  for (final dir in [
    'lib',
    'test',
    'tools',
  ]) {
    final d = Directory(dir);
    if (d.existsSync()) {
      dartFiles.addAll(
        d
            .listSync(recursive: true)
            .whereType<File>()
            .map((f) => f.path.replaceAll('\\', '/')),
      );
    }
  }

  for (final path in dartFiles) {
    if (!path.endsWith('.dart') ||
        path.endsWith('.g.dart') ||
        path.endsWith('.freezed.dart')) {
      continue;
    }
    final content = File(path);
    for (final rule in _rules) {
      if (!path.startsWith(rule.scope) || path == 'tools/check_layering.dart') {
        continue;
      }
      for (final line in content.readAsLinesSync()) {
        final trimmed = line.trim();
        if (!trimmed.startsWith('import ')) {
          continue;
        }
        for (final prefix in rule.forbiddenPrefixes) {
          if (trimmed.contains(prefix)) {
            stderr.writeln(
              '✗ 违例: $path\n    $trimmed\n    规则: ${rule.reason}',
            );
            violations++;
          }
        }
      }
    }
  }

  if (violations > 0) {
    stderr.writeln('分层检查失败：$violations 处违例（docs/04 §7）');
    exit(1);
  }
  stdout.writeln('✓ 分层依赖检查通过（${_rules.length} 条规则）');
}
