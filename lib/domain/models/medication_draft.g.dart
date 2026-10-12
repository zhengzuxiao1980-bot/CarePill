// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationDraftPayload _$MedicationDraftPayloadFromJson(
  Map<String, dynamic> json,
) => _MedicationDraftPayload(
  name: json['name'] as String?,
  form: $enumDecodeNullable(_$MedicationFormEnumMap, json['form']),
  spec: json['spec'] as String?,
  doseUnit: json['dose_unit'] as String?,
  usageText: json['usage_text'] as String?,
  perDose: (json['per_dose'] as num?)?.toDouble(),
  times:
      (json['times'] as List<dynamic>?)
          ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  frequencyHint: json['frequency_hint'] as String?,
  notes: json['notes'] as String?,
  uncertain:
      (json['uncertain'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$MedicationDraftPayloadToJson(
  _MedicationDraftPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'form': _$MedicationFormEnumMap[instance.form],
  'spec': instance.spec,
  'dose_unit': instance.doseUnit,
  'usage_text': instance.usageText,
  'per_dose': instance.perDose,
  'times': instance.times.map((e) => e.toJson()).toList(),
  'frequency_hint': instance.frequencyHint,
  'notes': instance.notes,
  'uncertain': instance.uncertain,
};

const _$MedicationFormEnumMap = {
  MedicationForm.tablet: 'tablet',
  MedicationForm.capsule: 'capsule',
  MedicationForm.liquid: 'liquid',
  MedicationForm.patch: 'patch',
  MedicationForm.spray: 'spray',
  MedicationForm.injection: 'injection',
  MedicationForm.other: 'other',
};

_VisionExtractResult _$VisionExtractResultFromJson(Map<String, dynamic> json) =>
    _VisionExtractResult(
      notReadable: json['not_readable'] as bool? ?? false,
      medication: json['medication'] == null
          ? null
          : MedicationDraftPayload.fromJson(
              json['medication'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$VisionExtractResultToJson(
  _VisionExtractResult instance,
) => <String, dynamic>{
  'not_readable': instance.notReadable,
  'medication': instance.medication?.toJson(),
};
