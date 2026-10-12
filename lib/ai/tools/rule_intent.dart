import 'package:care_pill/i18n/strings.g.dart';

import '../../core/formatters.dart';

/// 二级降级：本地规则意图匹配（docs/03 §5）。
///
/// 对高频问题做本地意图识别，命中则直接执行对应工具并让模型润色回答。
class RuleIntent {
  const RuleIntent({required this.tool, required this.args});

  final String tool;
  final Map<String, dynamic> args;
}

abstract final class RuleIntentMatcher {
  /// "吃没吃/吃了没" → get_dose_status；
  /// "下一个/接下来/下顿" → get_next_dose；
  /// "记一下/吃过了/帮我记上" → mark_dose_taken（带药名与时间解析）。
  static RuleIntent? match(
    String text, {
    List<String> medicationNames = const [],
    DateTime Function()? clock,
  }) {
    final t = text.trim();
    final now = (clock ?? DateTime.now)();

    final mark = _matchMarkDose(t, medicationNames, now);
    if (mark != null) {
      return mark;
    }

    if (RegExp(
      r'(吃没吃|吃了没|吃过吗|吃药了吗|吃了吗|有没有吃|\b(?:did i take|have i taken)\b)',
      caseSensitive: false,
    ).hasMatch(t)) {
      return const RuleIntent(tool: 'get_dose_status', args: {});
    }
    if (RegExp(
      r'(下一个|接下来|下顿|下一顿|待会儿吃什么|等下吃什么|\bnext (?:dose|medicine|medication)\b)',
      caseSensitive: false,
    ).hasMatch(t)) {
      return const RuleIntent(tool: 'get_next_dose', args: {});
    }
    return null;
  }

  /// "帮我记上刚才吃过降压药了" / "昨天晚上的药忘了记"。
  static RuleIntent? _matchMarkDose(
    String t,
    List<String> medicationNames,
    DateTime now,
  ) {
    final wantsMark = RegExp(r'(记一下|记上|帮我记|忘了按|补一下|补记|吃过了|吃完了)').hasMatch(t);
    if (!wantsMark) {
      return null;
    }

    final mentioned = medicationNames
        .where((name) => name.isNotEmpty && t.contains(name))
        .toSet();
    final medName = mentioned.length == 1 ? mentioned.single : null;

    DateTime? when;
    if (RegExp(r'昨天').hasMatch(t)) {
      when = now.subtract(const Duration(days: 1));
      final m = RegExp(r'(\d{1,2})\s*[:：点]\s*(\d{1,2})?').firstMatch(t);
      if (m != null) {
        final hour = int.tryParse(m.group(1)!);
        final minute = int.tryParse(m.group(2) ?? '0') ?? 0;
        if (hour != null && hour < 24 && minute < 60) {
          when = DateTime(when.year, when.month, when.day, hour, minute);
        }
      }
    } else {
      // "刚才/早上/晚上 X 点"：解析今天时刻。
      final m = RegExp(r'(\d{1,2})\s*[:：点]\s*(\d{1,2})?').firstMatch(t);
      if (m != null) {
        final hour = int.tryParse(m.group(1)!);
        final minute = int.tryParse(m.group(2) ?? '0') ?? 0;
        if (hour != null && hour < 24 && minute < 60) {
          when = DateTime(now.year, now.month, now.day, hour, minute);
        }
      }
    }

    final whenText = when == null ? null : '${when.isoDate} ${when.hhMm}';
    return RuleIntent(
      tool: 'mark_dose_taken',
      args: {
        'medication_name': ?medName,
        'when': ?whenText,
        if (t.contains('昨天'))
          'scheduled_date': now.subtract(const Duration(days: 1)).isoDate,
        if (t.contains('今天')) 'scheduled_date': now.isoDate,
        'note': t,
      },
    );
  }

  /// 意图是否属于医疗咨询边界（直接走安全话术，不打扰模型也可答）。
  static bool isMedicalAdviceQuestion(String text) =>
      RegExp(r'(停药|换药|加量|减量|剂量.*(改|调)|(能|可不可以|要不要).*(停|换))').hasMatch(text);

  /// 是否描述了急症症状（docs/03 §8：立即建议就医）。
  static bool isEmergency(String text) =>
      RegExp(r'(胸(口)?(疼|痛)|喘不上气|呼吸困难|头晕.*(倒|摔倒)|摔倒|晕倒|意识不清|说不出话)')
          .hasMatch(text);
}

/// 意图命中的本地兜底回答模板（模型不可用时保证可懂）。
String cannedReplyForTool(String tool, Map<String, dynamic> data) {
  if (data['error'] != null) return data['error'].toString();
  switch (tool) {
    case 'get_dose_status':
      final summary = data['summary'];
      return summary is String && summary.isNotEmpty
          ? tr.ruleIntent.statusReply(arg1: (summary).toString())
          : tr.ruleIntent.noSchedule;
    case 'get_next_dose':
      if (data['none'] == true) {
        return tr.ruleIntent.allDone;
      }
      final time = data['friendly_time'];
      final med = data['medication'];
      return tr.ruleIntent.nextReply(
        arg1: (time).toString(),
        arg2: (med).toString(),
      );
    case 'mark_dose_taken':
      return data['marked'] == true
          ? tr.ruleIntent.recordedReply
          : tr.agentService.notUnderstood;
    default:
      return tr.ruleIntent.acknowledged;
  }
}
