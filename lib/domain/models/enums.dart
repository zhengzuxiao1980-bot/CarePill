/// 全部业务枚举（docs/05 数据模型）。
///
/// `json` 值与数据库/导出文件中的存储字符串一致（docs/05 表结构定义）。
library;

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../i18n/strings.g.dart';

@JsonEnum(valueField: 'json')
enum MedicationForm {
  tablet('tablet'),
  capsule('capsule'),
  liquid('liquid'),
  patch('patch'),
  spray('spray'),
  injection('injection'),
  other('other');

  const MedicationForm(this.json);
  final String json;
  String get label => switch (this) {
    tablet => tr.enums.medicationForm.tablet,
    capsule => tr.enums.medicationForm.capsule,
    liquid => tr.enums.medicationForm.liquid,
    patch => tr.enums.medicationForm.patch,
    spray => tr.enums.medicationForm.spray,
    injection => tr.enums.medicationForm.injection,
    other => tr.enums.medicationForm.other,
  };

  static MedicationForm fromJsonString(String? s) =>
      MedicationForm.values.where((e) => e.json == s).firstOrNull ??
      MedicationForm.other;
}

enum MedicationStatus {
  active('active'),
  archived('archived');

  const MedicationStatus(this.json);
  final String json;
  String get label => switch (this) {
    active => tr.enums.medicationStatus.active,
    archived => tr.enums.medicationStatus.archived,
  };
}

/// 药品来源（docs/02 F1：AI 录入保留溯源）。
enum MedicationSource {
  manual('manual'),
  aiPhoto('ai_photo'),
  barcode('barcode');

  const MedicationSource(this.json);
  final String json;
  String get label => switch (this) {
    manual => tr.enums.medicationSource.manual,
    aiPhoto => tr.enums.medicationSource.aiPhoto,
    barcode => tr.barcode.entry,
  };
}

@JsonEnum(valueField: 'json')
enum FrequencyType {
  daily('daily'),
  weekdays('weekdays'),
  intervalDays('interval_days'),
  asNeeded('as_needed');

  const FrequencyType(this.json);
  final String json;
  String get label => switch (this) {
    daily => tr.enums.frequencyType.daily,
    weekdays => tr.enums.frequencyType.weekdays,
    intervalDays => tr.enums.frequencyType.intervalDays,
    asNeeded => tr.enums.frequencyType.asNeeded,
  };
}

enum ScheduleStatus {
  active('active'),
  paused('paused');

  const ScheduleStatus(this.json);
  final String json;
  String get label => switch (this) {
    active => tr.enums.scheduleStatus.active,
    paused => tr.enums.scheduleStatus.paused,
  };
}

@JsonEnum(valueField: 'json')
enum MealRelation {
  before('before'),
  with_('with'),
  after('after');

  const MealRelation(this.json);
  final String json;
  String get label => switch (this) {
    before => tr.enums.mealRelation.before,
    with_ => tr.enums.mealRelation.with_,
    after => tr.enums.mealRelation.after,
  };

  static MealRelation? tryFromJsonString(String? s) {
    for (final e in MealRelation.values) {
      if (e.json == s) {
        return e;
      }
    }
    return null;
  }
}

@JsonEnum(valueField: 'json')
enum DoseStatus {
  pending('pending'),
  taken('taken'),
  skipped('skipped'),
  missed('missed');

  const DoseStatus(this.json);
  final String json;
  String get label => switch (this) {
    pending => tr.enums.doseStatus.pending,
    taken => tr.enums.doseStatus.taken,
    skipped => tr.enums.doseStatus.skipped,
    missed => tr.enums.doseStatus.missed,
  };
}

/// 打卡来源（docs/05：补记标记 catch_up 与按点打卡区分）。
@JsonEnum(valueField: 'json')
enum MarkSource {
  tap('tap'),
  notification('notification'),
  voice('voice'),
  ai('ai'),
  catchUp('catch_up');

  const MarkSource(this.json);
  final String json;
  String get label => switch (this) {
    tap => tr.enums.markSource.tap,
    notification => tr.enums.markSource.notification,
    voice => tr.enums.markSource.voice,
    ai => tr.enums.markSource.ai,
    catchUp => tr.enums.markSource.catchUp,
  };
}

enum ModelUsage {
  chat('chat'),
  vision('vision'),
  both('both');

  const ModelUsage(this.json);
  final String json;
  String get label => switch (this) {
    chat => tr.enums.modelUsage.chat,
    vision => tr.enums.modelUsage.vision,
    both => tr.enums.modelUsage.both,
  };
}

enum DraftSource {
  photo('photo'),
  chat('chat');

  const DraftSource(this.json);
  final String json;
  String get label => switch (this) {
    photo => tr.enums.draftSource.photo,
    chat => tr.enums.draftSource.chat,
  };
}

enum DraftStatus {
  pending('pending'),
  confirmed('confirmed'),
  discarded('discarded');

  const DraftStatus(this.json);
  final String json;
  String get label => switch (this) {
    pending => tr.enums.draftStatus.pending,
    confirmed => tr.enums.draftStatus.confirmed,
    discarded => tr.enums.draftStatus.discarded,
  };
}

enum ChatRole {
  user('user'),
  assistant('assistant'),
  tool('tool');

  const ChatRole(this.json);
  final String json;
  String get label => switch (this) {
    user => tr.enums.chatRole.user,
    assistant => tr.enums.chatRole.assistant,
    tool => tr.enums.chatRole.tool,
  };
}
