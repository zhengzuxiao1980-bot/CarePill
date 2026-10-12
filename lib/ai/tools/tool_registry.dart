import 'dart:convert';

import 'package:care_pill/i18n/strings.g.dart';
import 'package:collection/collection.dart';

import '../../core/app_logger.dart';
import '../../core/exceptions.dart';
import '../../core/formatters.dart';
import '../../domain/models/dose_task.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication_draft.dart';
import '../../domain/models/schedule.dart';
import '../../domain/models/view_models.dart';
import '../../domain/services/dose_service.dart';
import '../../domain/services/medication_service.dart';
import '../../domain/services/memory_service.dart';

/// 工具定义（docs/03 §4 Function Calling 工具集）。
class ToolSpec {
  const ToolSpec({
    required this.name,
    required this.description,
    required this.parameters,
    this.write = false,
  });

  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  /// 写类工具执行结果必须以"可撤销确认条"回显（docs/03 §4 写操作安全）。
  final bool write;

  Map<String, dynamic> get schema => {
    'type': 'object',
    'properties': parameters,
  };
}

/// 工具执行结果：data 回传模型，writeEvent 供 UI 撤销确认条。
class ToolOutcome {
  const ToolOutcome({required this.ok, required this.data, this.writeEvent});

  final bool ok;
  final Map<String, dynamic> data;
  final AgentWriteEvent? writeEvent;
}

/// 工具注册表与本地执行器（docs/04 架构图 TOOLS --> DS & MS）。
///
/// AI 只能通过这些工具读写数据，不存在"AI 自己编造用药情况"的通道。
class ToolRegistry {
  ToolRegistry({
    required DoseService doseService,
    required MedicationService medicationService,
    required Future<DraftUpsert> Function(MedicationDraftPayload payload)
    draftSaver,
    DateTime Function()? clock,
    this.memories,
    this.discardDraft,
  }) : _dose = doseService,
       _meds = medicationService,
       _saveDraft = draftSaver,
       _now = clock ?? (() => doseService.now);

  final DoseService _dose;
  final MedicationService _meds;
  final Future<DraftUpsert> Function(MedicationDraftPayload payload) _saveDraft;
  final DateTime Function() _now;
  final MemoryService? memories;
  final Future<void> Function(String id)? discardDraft;

  bool isWrite(String name) => specs.any((s) => s.name == name && s.write);

  static const String _dateDesc = 'yyyy-MM-dd 格式，不填默认今天';

  /// 全部工具（docs/03 §4 表格；新增工具按 docs/04 §9.1 Playbook）。
  List<ToolSpec> get specs => [
    if (memories != null) ...[
      ToolSpec(
        name: 'search_memories',
        description: '查询用户明确保存的长期记忆（用户自述，不是实时用药记录）',
        parameters: {
          'query': {'type': 'string'},
        },
      ),
      ToolSpec(
        name: 'save_memory',
        description: '仅当用户明确要求记住或更正时保存；content 必须摘自当轮用户原话；更正传已有 id。',
        parameters: {
          'id': {'type': 'string'},
          'content': {'type': 'string'},
        },
        write: true,
      ),
      ToolSpec(
        name: 'forget_memory',
        description: '仅当用户明确要求遗忘时删除指定记忆，不明确先询问',
        parameters: {
          'id': {'type': 'string'},
        },
        write: true,
      ),
    ],
    ToolSpec(
      name: 'get_today_plan',
      description: '查询今天全部的吃药任务（药名、时刻、剂量、状态）',
      parameters: const {},
    ),
    ToolSpec(
      name: 'get_dose_status',
      description: '按日期查询吃药打卡情况，回答"今天吃没吃药"用这个',
      parameters: {
        'date': {'type': 'string', 'description': _dateDesc},
      },
    ),
    ToolSpec(
      name: 'get_next_dose',
      description: '查询最近一次还没吃的药（下一个要吃什么）',
      parameters: const {},
    ),
    ToolSpec(
      name: 'list_medications',
      description: '列出在吃的全部药和各自的吃药时间',
      parameters: const {},
    ),
    ToolSpec(
      name: 'get_medication_detail',
      description: '查某一种药的详情（规格、频次、备注）',
      parameters: {
        'name': {'type': 'string', 'description': '药名，用主人说的名字'},
      },
    ),
    ToolSpec(
      name: 'get_adherence_stats',
      description: '查询最近 N 天吃了多少次、漏了多少次',
      parameters: {
        'days': {'type': 'integer', 'description': '查最近几天，默认 7，最多 90'},
      },
    ),
    ToolSpec(
      name: 'mark_dose_taken',
      description: '帮主人记一笔：某次的药吃过了（支持补记；只能记今天和昨天）',
      parameters: {
        'task_id': {'type': 'string', 'description': '任务 ID，从查询工具结果里原样拿'},
        'medication_name': {
          'type': 'string',
          'description': '当没有 task_id 时，用药名匹配今天（或昨天）的任务',
        },
        'when': {
          'type': 'string',
          'description': '实际吃药时间（yyyy-MM-dd HH:mm），不填=现在',
        },
        'scheduled_date': {
          'type': 'string',
          'description': '目标任务的计划日期 yyyy-MM-dd，不是实际吃药日期',
        },
        'scheduled_time': {
          'type': 'string',
          'description': '目标任务的计划时刻 HH:mm，不是实际吃药时刻',
        },
        'note': {'type': 'string', 'description': '备注，如"刚才吃的"'},
      },
      write: true,
    ),
    ToolSpec(
      name: 'skip_dose',
      description: '帮主人记一笔：这一次不吃了',
      parameters: {
        'task_id': {'type': 'string', 'description': '任务 ID'},
        'reason': {'type': 'string', 'description': '原因，如"副作用"'},
      },
      write: true,
    ),
    ToolSpec(
      name: 'create_medication_draft',
      description: '主人在聊天里描述了一个新药时，把它记成草稿（要主人确认后才生效）',
      parameters: {
        'draft': {
          'type': 'object',
          'description':
              '药品草稿：name(名)、form(剂型)、spec(规格)、dose_unit(单位)、'
              'usage_text(用法用量原话)、times:[{time,dose,meal}]',
        },
      },
      write: true,
    ),
  ];

  /// 执行工具（Agent 执行环调用；10 秒超时由 AgentService 包）。
  Future<ToolOutcome> execute(
    String name,
    Map<String, dynamic> args, {
    String userText = '',
    String sourceMessageId = '',
  }) async {
    AppLog.i('工具执行 $name 参数数=${args.length}');
    try {
      final spec = specs.where((s) => s.name == name).firstOrNull;
      if (spec == null) {
        return ToolOutcome(ok: false, data: {'error': tr.agentV2.invalidArgs});
      }
      for (final entry in args.entries) {
        final schema = spec.parameters[entry.key];
        if (schema is Map && entry.value != null) {
          final type = schema['type'];
          if ((type == 'string' && entry.value is! String) ||
              (type == 'object' && entry.value is! Map<String, dynamic>) ||
              (type == 'integer' &&
                  entry.value is! int &&
                  (entry.value is! String ||
                      int.tryParse(entry.value as String) == null))) {
            return ToolOutcome(
              ok: false,
              data: {'error': tr.agentV2.invalidArgs, 'field': entry.key},
            );
          }
        }
      }
      if (name.endsWith('_memory') || name == 'search_memories') {
        final data = await memories!.tool(
          name,
          args,
          userText: userText,
          sourceMessageId: sourceMessageId,
        );
        final saved = data['memory'] as Map<String, dynamic>?;
        return ToolOutcome(
          ok: !data.containsKey('error'),
          data: data,
          writeEvent: data.containsKey('error') || name == 'search_memories'
              ? null
              : AgentWriteEvent(
                  kind: 'memory',
                  taskId: (saved?['id'] ?? data['id']) as String,
                  summary: saved == null
                      ? tr.agentV2.memoryDeleted
                      : '${tr.agentV2.remembered}：${saved['content']}',
                ),
        );
      }
      final outcome = switch (name) {
        'get_today_plan' => await _getTodayPlan(),
        'get_dose_status' => await _getDoseStatus(args),
        'get_next_dose' => await _getNextDose(),
        'list_medications' => await _listMedications(),
        'get_medication_detail' => await _getMedicationDetail(args),
        'get_adherence_stats' => await _getAdherenceStats(args),
        'mark_dose_taken' => await _markDoseTaken(args),
        'skip_dose' => await _skipDose(args),
        'create_medication_draft' => await _createMedicationDraft(args),
        _ => const ToolOutcome(ok: false, data: {'error': '未知工具'}),
      };
      AppLog.d('工具结果 $name: ${AppLog.snippet(jsonEncode(outcome.data), 400)}');
      return outcome;
    } on AppException catch (e) {
      return ToolOutcome(ok: false, data: {'error': e.runtimeType.toString()});
    } on StateError catch (e) {
      return ToolOutcome(ok: false, data: {'error': e.message});
    } on TypeError {
      return ToolOutcome(ok: false, data: {'error': tr.agentV2.invalidArgs});
    } on FormatException {
      return ToolOutcome(ok: false, data: {'error': tr.agentV2.invalidArgs});
    }
  }

  Future<List<DoseTaskView>> _todayViews() => _dose.todayViews();

  Future<ToolOutcome> _getTodayPlan() async {
    final views = await _todayViews();
    return ToolOutcome(
      ok: true,
      data: {'date': _now().isoDate, 'tasks': views.map(_taskJson).toList()},
    );
  }

  Future<ToolOutcome> _getDoseStatus(Map<String, dynamic> args) async {
    final dateText = args['date'] as String?;
    var date = _now();
    if (dateText != null && dateText.isNotEmpty) {
      if (dateText == 'today' || dateText.contains('今天')) {
        date = _now();
      } else if (dateText == 'yesterday' || dateText.contains('昨天')) {
        date = _now().subtract(const Duration(days: 1));
      } else {
        try {
          date = parseIsoDate(dateText);
        } catch (_) {
          return const ToolOutcome(
            ok: false,
            data: {'error': '日期格式应为 yyyy-MM-dd'},
          );
        }
      }
    }
    final views = await _dose.viewsForDate(date);
    final taken = views.where((v) => v.task.isTaken).length;
    final missed = views.where((v) => v.task.isMissed).length;
    return ToolOutcome(
      ok: true,
      data: {
        'date': date.isoDate,
        'summary': tr.toolRegistry.statusSummary(
          arg1: (views.length).toString(),
          arg2: (taken).toString(),
          arg3: (missed).toString(),
          arg4: (views.length - taken - missed).toString(),
        ),
        'tasks': views.map(_taskJson).toList(),
      },
    );
  }

  Future<ToolOutcome> _getNextDose() async {
    final next = await _dose.nextPending();
    if (next == null) {
      return ToolOutcome(
        ok: true,
        data: {'none': true, 'message': tr.toolRegistry.allDone},
      );
    }
    return ToolOutcome(
      ok: true,
      data: _taskJson(next)
        ..['friendly_time'] = friendlyTime(next.task.scheduledTime),
    );
  }

  Future<ToolOutcome> _listMedications() async {
    final cards = await _meds.cards();
    return ToolOutcome(
      ok: true,
      data: {
        'medications': cards
            .map(
              (c) => {
                'name': c.medication.name,
                'form': c.medication.form.label,
                'spec': c.medication.spec,
                'unit': c.medication.doseUnit,
                'next_time': c.nextDoseSummary,
                'schedules': c.schedules
                    .map(
                      (s) => {
                        'frequency': s.frequencyType.label,
                        'times': s.times.map((t) => t.time).join('、'),
                      },
                    )
                    .toList(),
              },
            )
            .toList(),
      },
    );
  }

  Future<ToolOutcome> _getMedicationDetail(Map<String, dynamic> args) async {
    final name = args['name'] as String?;
    if (name == null || name.isEmpty) {
      return const ToolOutcome(ok: false, data: {'error': '缺少 name'});
    }
    final matches = (await _meds.cards())
        .where(
          (c) =>
              c.medication.name == name ||
              c.medication.name.contains(name) ||
              name.contains(c.medication.name),
        )
        .toList();
    if (matches.length > 1) {
      return ToolOutcome(
        ok: false,
        data: {
          'error': tr.agentV2.ambiguous,
          'candidates': matches
              .map((c) => {'id': c.medication.id, 'name': c.medication.name})
              .toList(),
        },
      );
    }
    final med = matches.firstOrNull?.medication;
    if (med == null) {
      return ToolOutcome(ok: true, data: {'found': false, 'name': name});
    }
    final schedules = await _meds.schedulesOf(med.id);
    return ToolOutcome(
      ok: true,
      data: {
        'found': true,
        'name': med.name,
        'form': med.form.label,
        'spec': med.spec,
        'unit': med.doseUnit,
        'notes': med.notes,
        'schedules': schedules
            .map(
              (s) => {
                'frequency': s.frequencyType.label,
                'times': s.times
                    .map((t) => '${t.time}(${t.effectiveDose}${med.doseUnit})')
                    .join('、'),
              },
            )
            .toList(),
      },
    );
  }

  Future<ToolOutcome> _getAdherenceStats(Map<String, dynamic> args) async {
    final daysRaw = args['days'];
    var days = 7;
    if (daysRaw is int) {
      days = daysRaw;
    } else if (daysRaw is String) {
      days = int.tryParse(daysRaw) ?? 7;
    }
    days = days.clamp(1, 90);
    final stats = await _dose.adherence(days: days);
    return ToolOutcome(
      ok: true,
      data: stats.toToolJson()..['friendly'] = stats.toFriendlyText(),
    );
  }

  /// Resolve before executing so operation keys use the actual target.
  Future<Map<String, dynamic>> resolveWriteArguments(
    String name,
    Map<String, dynamic> args,
  ) async {
    if (name == 'save_memory' &&
        args['id'] == null &&
        args['content'] is String &&
        memories != null) {
      final duplicates = (await memories!.all())
          .where((m) => m['content'] == args['content'])
          .toList();
      if (duplicates.length == 1) {
        return {...args, 'id': duplicates.single['id']};
      }
    }
    if (name != 'mark_dose_taken' ||
        (args['task_id'] is String && (args['task_id'] as String).isNotEmpty)) {
      return args;
    }
    final medName = args['medication_name'];
    if (medName is! String || medName.trim().isEmpty) return args;
    final cards = await _meds.cards();
    final exact = cards.where((c) => c.medication.name == medName).toList();
    final matches = exact.isNotEmpty
        ? exact
        : cards
              .where(
                (c) =>
                    c.medication.name.contains(medName) ||
                    medName.contains(c.medication.name),
              )
              .toList();
    if (matches.length != 1) return args;
    final views = [
      ...await _dose.viewsForDate(_now()),
      ...await _dose.viewsForDate(_now().subtract(const Duration(days: 1))),
    ];
    final candidates = views
        .where(
          (v) =>
              v.task.medicationId == matches.single.medication.id &&
              (v.task.isPending || v.task.isMissed),
        )
        .where(
          (v) =>
              args['scheduled_date'] == null ||
              v.task.scheduledDate == args['scheduled_date'],
        )
        .where(
          (v) =>
              args['scheduled_time'] == null ||
              v.task.scheduledTime == args['scheduled_time'],
        )
        .toList();
    if (candidates.length == 1) {
      return {...args, 'task_id': candidates.single.task.id};
    }
    return args;
  }

  Future<Map<String, dynamic>?> snapshot(
    String name,
    Map<String, dynamic> args,
  ) async {
    if ((name == 'mark_dose_taken' || name == 'skip_dose') &&
        args['task_id'] is String) {
      try {
        return await _dose.taskSnapshot(args['task_id'] as String);
      } on StateError {
        return null;
      }
    }
    if ((name == 'save_memory' || name == 'forget_memory') &&
        args['id'] is String) {
      return memories!.store.get('memory:${args['id']}');
    }
    return null;
  }

  Future<void> undo(
    String name,
    String target,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  ) async {
    if (name == 'mark_dose_taken' || name == 'skip_dose') {
      if (before == null || after == null) throw StateError('undo_conflict');
      await _dose.restoreSnapshot(before, after);
    } else if (name == 'save_memory' || name == 'forget_memory') {
      final current = await memories!.store.get('memory:$target');
      if (!const DeepCollectionEquality().equals(current, after)) {
        throw StateError('undo_conflict');
      }
      if (current != null) await memories!.delete(target);
      if (before != null) {
        await memories!.store.put('memory:$target', 'memory', before);
        await memories!.suppress(before);
      }
    } else if (name == 'create_medication_draft') {
      if (discardDraft == null) throw StateError('undo_conflict');
      await discardDraft!(target);
    }
  }

  Future<ToolOutcome> _markDoseTaken(Map<String, dynamic> args) async {
    final resolved = await resolveWriteArguments('mark_dose_taken', args);
    final id = resolved['task_id'] as String?;
    final views = [
      ...await _dose.viewsForDate(_now()),
      ...await _dose.viewsForDate(_now().subtract(const Duration(days: 1))),
    ];
    if (id == null || id.isEmpty) {
      final name = args['medication_name'] as String? ?? '';
      final candidates = views
          .where(
            (v) =>
                name.isNotEmpty &&
                (v.medicationName.contains(name) ||
                    name.contains(v.medicationName)),
          )
          .where((v) => v.task.isPending || v.task.isMissed)
          .toList();
      return ToolOutcome(
        ok: false,
        data: {
          'error': candidates.isEmpty
              ? tr.agentV2.notFound
              : tr.agentV2.ambiguous,
          'candidates': candidates.map(_taskJson).toList(),
        },
      );
    }
    final target = views.where((v) => v.task.id == id).firstOrNull;
    if (target == null) {
      return ToolOutcome(
        ok: false,
        data: {'error': tr.toolRegistry.recordingWindow},
      );
    }
    if ((args['scheduled_date'] != null &&
            target.task.scheduledDate != args['scheduled_date']) ||
        (args['scheduled_time'] != null &&
            target.task.scheduledTime != args['scheduled_time'])) {
      return ToolOutcome(ok: false, data: {'error': tr.agentV2.ambiguous});
    }
    final requestedName = args['medication_name'] as String?;
    if (requestedName != null &&
        requestedName.isNotEmpty &&
        !target.medicationName.contains(requestedName) &&
        !requestedName.contains(target.medicationName)) {
      return ToolOutcome(ok: false, data: {'error': tr.agentV2.ambiguous});
    }
    DateTime? when;
    final whenText = args['when'] as String?;
    if (whenText != null && whenText.isNotEmpty) {
      when = DateTime.tryParse(whenText) ?? _parseLoose(whenText);
      if (when == null || !_isTodayOrYesterday(when)) {
        return ToolOutcome(
          ok: false,
          data: {'error': tr.toolRegistry.recordingWindow},
        );
      }
    }
    final updated = await _dose.markTaken(
      id,
      source: MarkSource.ai,
      at: when,
      note: args['note'] as String?,
    );
    return ToolOutcome(
      ok: true,
      data: {
        'marked': true,
        'task_id': id,
        'medication': target.medicationName,
        'catch_up': updated.isCatchUp,
      },
      writeEvent: AgentWriteEvent(
        kind: 'taken',
        taskId: id,
        summary: tr.toolRegistry.recorded(
          arg1:
              '${target.medicationName} ${friendlyTime(updated.scheduledTime)}',
        ),
      ),
    );
  }

  Future<ToolOutcome> _skipDose(Map<String, dynamic> args) async {
    final taskId = args['task_id'] as String?;
    final reason = args['reason'] as String?;
    if (taskId == null || taskId.isEmpty) {
      return const ToolOutcome(ok: false, data: {'error': '缺少 task_id'});
    }
    // 写工具和 mark_dose_taken 保持同一安全边界：AI 只能操作今天或昨天的
    // 任务，避免模型拿到旧历史 ID 后悄悄改写统计。
    final now = _now();
    final recent = [
      ...await _dose.viewsForDate(now),
      ...await _dose.viewsForDate(now.subtract(const Duration(days: 1))),
    ];
    if (!recent.any((view) => view.task.id == taskId)) {
      return ToolOutcome(
        ok: false,
        data: {'error': tr.toolRegistry.recordingWindow},
      );
    }
    final updated = await _dose.skip(taskId, reason: reason);
    return ToolOutcome(
      ok: true,
      data: {'skipped': true, 'task_id': updated.id},
      writeEvent: AgentWriteEvent(
        kind: 'skipped',
        taskId: updated.id,
        summary: tr.toolRegistry.skipped,
      ),
    );
  }

  Future<ToolOutcome> _createMedicationDraft(Map<String, dynamic> args) async {
    final raw = args['draft'];
    if (raw is! Map<String, dynamic>) {
      return const ToolOutcome(ok: false, data: {'error': '缺少 draft 对象'});
    }
    if ((raw['per_dose'] != null &&
            (raw['per_dose'] is! num || (raw['per_dose'] as num) <= 0)) ||
        (raw['times'] != null && raw['times'] is! List)) {
      return ToolOutcome(ok: false, data: {'error': tr.agentV2.invalidArgs});
    }
    for (final slot in raw['times'] as List? ?? []) {
      if (slot is! Map ||
          slot['time'] is! String ||
          !isValidHhMm(slot['time'] as String) ||
          (slot['dose'] != null &&
              (slot['dose'] is! num || (slot['dose'] as num) <= 0))) {
        return ToolOutcome(ok: false, data: {'error': tr.agentV2.invalidArgs});
      }
    }
    final payload = _payloadFromArgs(raw);
    if ((payload.name ?? '').trim().isEmpty) {
      return const ToolOutcome(ok: false, data: {'error': '草稿缺少药名'});
    }
    final result = await _saveDraft(payload);
    return ToolOutcome(
      ok: true,
      data: {'draft_id': result.draftId, 'message': tr.toolRegistry.draftSaved},
      writeEvent: AgentWriteEvent(
        kind: 'draft',
        taskId: result.draftId,
        summary: tr.toolRegistry.draftCreated(arg1: (payload.name).toString()),
      ),
    );
  }

  MedicationDraftPayload _payloadFromArgs(Map<String, dynamic> raw) {
    final times = <TimeSlot>[];
    final rawTimes = raw['times'];
    if (rawTimes is List) {
      for (final t in rawTimes) {
        if (t is! Map<String, dynamic>) {
          continue;
        }
        final time = t['time'] as String?;
        if (time == null || !isValidHhMm(time)) {
          continue;
        }
        final dose = t['dose'];
        final mealText = t['meal'] as String?;
        times.add(
          TimeSlot(
            time: time,
            dose: dose is num ? dose.toDouble() : null,
            meal: MealRelation.tryFromJsonString(mealText),
          ),
        );
      }
    }
    return MedicationDraftPayload(
      name: raw['name'] as String?,
      form: MedicationForm.values
          .where((f) => f.json == raw['form'])
          .firstOrNull,
      spec: raw['spec'] as String?,
      doseUnit: raw['dose_unit'] as String? ?? raw['unit'] as String?,
      usageText: raw['usage_text'] as String?,
      perDose: raw['per_dose'] is num
          ? (raw['per_dose'] as num).toDouble()
          : null,
      times: times,
      frequencyHint: raw['frequency_hint'] as String?,
      notes: raw['notes'] as String?,
    );
  }

  DateTime? _parseLoose(String text) {
    // "今天 20:30" / "20:30" / "刚才"
    final m = RegExp(r'(\d{1,2})[:：点](\d{1,2})?').firstMatch(text);
    if (m == null) {
      return null;
    }
    final now = _now();
    final hour = int.parse(m.group(1)!);
    final minute = int.tryParse(m.group(2) ?? '0') ?? 0;
    if (hour > 23 || minute > 59) {
      return null;
    }
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  bool _isTodayOrYesterday(DateTime value) {
    final today = _now().dateOnly;
    final date = value.dateOnly;
    return date == today || date == today.subtract(const Duration(days: 1));
  }

  Map<String, dynamic> _taskJson(DoseTaskView view) => {
    'task_id': view.task.id,
    'medication': view.medicationName,
    'date': view.task.scheduledDate,
    'time': view.task.scheduledTime,
    'dose': view.task.plannedDose,
    'unit': view.doseUnit,
    'status': view.task.status.json,
    'meal': view.meal?.json,
    if (view.task.isCatchUp) 'catch_up': true,
  };
}

/// 草稿保存结果（draft_id 供 UI 跳转确认页）。
class DraftUpsert {
  const DraftUpsert({required this.draftId});
  final String draftId;
}
