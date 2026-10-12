// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => _TimeSlot(
  time: json['time'] as String,
  dose: (json['dose'] as num?)?.toDouble(),
  meal: $enumDecodeNullable(_$MealRelationEnumMap, json['meal']),
);

Map<String, dynamic> _$TimeSlotToJson(_TimeSlot instance) => <String, dynamic>{
  'time': instance.time,
  'dose': ?instance.dose,
  'meal': ?_$MealRelationEnumMap[instance.meal],
};

const _$MealRelationEnumMap = {
  MealRelation.before: 'before',
  MealRelation.with_: 'with',
  MealRelation.after: 'after',
};

_MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) =>
    _MedicationSchedule(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      frequencyType: $enumDecode(_$FrequencyTypeEnumMap, json['frequencyType']),
      weekdays: (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      intervalDays: (json['intervalDays'] as num?)?.toInt(),
      anchorDate: json['anchorDate'] as String?,
      times:
          (json['times'] as List<dynamic>?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      mealRelation: $enumDecodeNullable(
        _$MealRelationEnumMap,
        json['mealRelation'],
      ),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      status: $enumDecode(_$ScheduleStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MedicationScheduleToJson(_MedicationSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationId': instance.medicationId,
      'frequencyType': _$FrequencyTypeEnumMap[instance.frequencyType]!,
      'weekdays': instance.weekdays,
      'intervalDays': instance.intervalDays,
      'anchorDate': instance.anchorDate,
      'times': instance.times.map((e) => e.toJson()).toList(),
      'mealRelation': _$MealRelationEnumMap[instance.mealRelation],
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'status': _$ScheduleStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FrequencyTypeEnumMap = {
  FrequencyType.daily: 'daily',
  FrequencyType.weekdays: 'weekdays',
  FrequencyType.intervalDays: 'interval_days',
  FrequencyType.asNeeded: 'as_needed',
};

const _$ScheduleStatusEnumMap = {
  ScheduleStatus.active: 'active',
  ScheduleStatus.paused: 'paused',
};
