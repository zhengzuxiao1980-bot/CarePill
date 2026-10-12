// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specMeta = const VerificationMeta('spec');
  @override
  late final GeneratedColumn<String> spec = GeneratedColumn<String>(
    'spec',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doseUnitMeta = const VerificationMeta(
    'doseUnit',
  );
  @override
  late final GeneratedColumn<String> doseUnit = GeneratedColumn<String>(
    'dose_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiExtractJsonMeta = const VerificationMeta(
    'aiExtractJson',
  );
  @override
  late final GeneratedColumn<String> aiExtractJson = GeneratedColumn<String>(
    'ai_extract_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    form,
    spec,
    doseUnit,
    notes,
    photoPath,
    source,
    aiExtractJson,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('spec')) {
      context.handle(
        _specMeta,
        spec.isAcceptableOrUnknown(data['spec']!, _specMeta),
      );
    }
    if (data.containsKey('dose_unit')) {
      context.handle(
        _doseUnitMeta,
        doseUnit.isAcceptableOrUnknown(data['dose_unit']!, _doseUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_doseUnitMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('ai_extract_json')) {
      context.handle(
        _aiExtractJsonMeta,
        aiExtractJson.isAcceptableOrUnknown(
          data['ai_extract_json']!,
          _aiExtractJsonMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      )!,
      spec: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec'],
      ),
      doseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_unit'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      aiExtractJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_extract_json'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationRow extends DataClass implements Insertable<MedicationRow> {
  final String id;
  final String name;
  final String form;
  final String? spec;
  final String doseUnit;
  final String? notes;
  final String? photoPath;
  final String source;
  final String? aiExtractJson;
  final String status;
  final int createdAt;
  final int updatedAt;
  const MedicationRow({
    required this.id,
    required this.name,
    required this.form,
    this.spec,
    required this.doseUnit,
    this.notes,
    this.photoPath,
    required this.source,
    this.aiExtractJson,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['form'] = Variable<String>(form);
    if (!nullToAbsent || spec != null) {
      map['spec'] = Variable<String>(spec);
    }
    map['dose_unit'] = Variable<String>(doseUnit);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || aiExtractJson != null) {
      map['ai_extract_json'] = Variable<String>(aiExtractJson);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      form: Value(form),
      spec: spec == null && nullToAbsent ? const Value.absent() : Value(spec),
      doseUnit: Value(doseUnit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      source: Value(source),
      aiExtractJson: aiExtractJson == null && nullToAbsent
          ? const Value.absent()
          : Value(aiExtractJson),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      form: serializer.fromJson<String>(json['form']),
      spec: serializer.fromJson<String?>(json['spec']),
      doseUnit: serializer.fromJson<String>(json['doseUnit']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      source: serializer.fromJson<String>(json['source']),
      aiExtractJson: serializer.fromJson<String?>(json['aiExtractJson']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'form': serializer.toJson<String>(form),
      'spec': serializer.toJson<String?>(spec),
      'doseUnit': serializer.toJson<String>(doseUnit),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'source': serializer.toJson<String>(source),
      'aiExtractJson': serializer.toJson<String?>(aiExtractJson),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MedicationRow copyWith({
    String? id,
    String? name,
    String? form,
    Value<String?> spec = const Value.absent(),
    String? doseUnit,
    Value<String?> notes = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    String? source,
    Value<String?> aiExtractJson = const Value.absent(),
    String? status,
    int? createdAt,
    int? updatedAt,
  }) => MedicationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    form: form ?? this.form,
    spec: spec.present ? spec.value : this.spec,
    doseUnit: doseUnit ?? this.doseUnit,
    notes: notes.present ? notes.value : this.notes,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    source: source ?? this.source,
    aiExtractJson: aiExtractJson.present
        ? aiExtractJson.value
        : this.aiExtractJson,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicationRow copyWithCompanion(MedicationsCompanion data) {
    return MedicationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      form: data.form.present ? data.form.value : this.form,
      spec: data.spec.present ? data.spec.value : this.spec,
      doseUnit: data.doseUnit.present ? data.doseUnit.value : this.doseUnit,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      source: data.source.present ? data.source.value : this.source,
      aiExtractJson: data.aiExtractJson.present
          ? data.aiExtractJson.value
          : this.aiExtractJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('spec: $spec, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('source: $source, ')
          ..write('aiExtractJson: $aiExtractJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    form,
    spec,
    doseUnit,
    notes,
    photoPath,
    source,
    aiExtractJson,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.form == this.form &&
          other.spec == this.spec &&
          other.doseUnit == this.doseUnit &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.source == this.source &&
          other.aiExtractJson == this.aiExtractJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicationsCompanion extends UpdateCompanion<MedicationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> form;
  final Value<String?> spec;
  final Value<String> doseUnit;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<String> source;
  final Value<String?> aiExtractJson;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.form = const Value.absent(),
    this.spec = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.source = const Value.absent(),
    this.aiExtractJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    required String form,
    this.spec = const Value.absent(),
    required String doseUnit,
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    required String source,
    this.aiExtractJson = const Value.absent(),
    required String status,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       form = Value(form),
       doseUnit = Value(doseUnit),
       source = Value(source),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MedicationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? form,
    Expression<String>? spec,
    Expression<String>? doseUnit,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<String>? source,
    Expression<String>? aiExtractJson,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (form != null) 'form': form,
      if (spec != null) 'spec': spec,
      if (doseUnit != null) 'dose_unit': doseUnit,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (source != null) 'source': source,
      if (aiExtractJson != null) 'ai_extract_json': aiExtractJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? form,
    Value<String?>? spec,
    Value<String>? doseUnit,
    Value<String?>? notes,
    Value<String?>? photoPath,
    Value<String>? source,
    Value<String?>? aiExtractJson,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      form: form ?? this.form,
      spec: spec ?? this.spec,
      doseUnit: doseUnit ?? this.doseUnit,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      source: source ?? this.source,
      aiExtractJson: aiExtractJson ?? this.aiExtractJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (spec.present) {
      map['spec'] = Variable<String>(spec.value);
    }
    if (doseUnit.present) {
      map['dose_unit'] = Variable<String>(doseUnit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (aiExtractJson.present) {
      map['ai_extract_json'] = Variable<String>(aiExtractJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('spec: $spec, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('source: $source, ')
          ..write('aiExtractJson: $aiExtractJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationSchedulesTable extends MedicationSchedules
    with TableInfo<$MedicationSchedulesTable, ScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyTypeMeta = const VerificationMeta(
    'frequencyType',
  );
  @override
  late final GeneratedColumn<String> frequencyType = GeneratedColumn<String>(
    'frequency_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
    'weekdays',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<String> anchorDate = GeneratedColumn<String>(
    'anchor_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesJsonMeta = const VerificationMeta(
    'timesJson',
  );
  @override
  late final GeneratedColumn<String> timesJson = GeneratedColumn<String>(
    'times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealRelationMeta = const VerificationMeta(
    'mealRelation',
  );
  @override
  late final GeneratedColumn<String> mealRelation = GeneratedColumn<String>(
    'meal_relation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    frequencyType,
    weekdays,
    intervalDays,
    anchorDate,
    timesJson,
    mealRelation,
    startDate,
    endDate,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('frequency_type')) {
      context.handle(
        _frequencyTypeMeta,
        frequencyType.isAcceptableOrUnknown(
          data['frequency_type']!,
          _frequencyTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyTypeMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    }
    if (data.containsKey('times_json')) {
      context.handle(
        _timesJsonMeta,
        timesJson.isAcceptableOrUnknown(data['times_json']!, _timesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_timesJsonMeta);
    }
    if (data.containsKey('meal_relation')) {
      context.handle(
        _mealRelationMeta,
        mealRelation.isAcceptableOrUnknown(
          data['meal_relation']!,
          _mealRelationMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      frequencyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_type'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays'],
      ),
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      ),
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_date'],
      ),
      timesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times_json'],
      )!,
      mealRelation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_relation'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationSchedulesTable createAlias(String alias) {
    return $MedicationSchedulesTable(attachedDatabase, alias);
  }
}

class ScheduleRow extends DataClass implements Insertable<ScheduleRow> {
  final String id;
  final String medicationId;
  final String frequencyType;
  final String? weekdays;
  final int? intervalDays;
  final String? anchorDate;
  final String timesJson;
  final String? mealRelation;
  final String startDate;
  final String? endDate;
  final String status;
  final int createdAt;
  const ScheduleRow({
    required this.id,
    required this.medicationId,
    required this.frequencyType,
    this.weekdays,
    this.intervalDays,
    this.anchorDate,
    required this.timesJson,
    this.mealRelation,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['frequency_type'] = Variable<String>(frequencyType);
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || anchorDate != null) {
      map['anchor_date'] = Variable<String>(anchorDate);
    }
    map['times_json'] = Variable<String>(timesJson);
    if (!nullToAbsent || mealRelation != null) {
      map['meal_relation'] = Variable<String>(mealRelation);
    }
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MedicationSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MedicationSchedulesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      frequencyType: Value(frequencyType),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      anchorDate: anchorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(anchorDate),
      timesJson: Value(timesJson),
      mealRelation: mealRelation == null && nullToAbsent
          ? const Value.absent()
          : Value(mealRelation),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      frequencyType: serializer.fromJson<String>(json['frequencyType']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      anchorDate: serializer.fromJson<String?>(json['anchorDate']),
      timesJson: serializer.fromJson<String>(json['timesJson']),
      mealRelation: serializer.fromJson<String?>(json['mealRelation']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'frequencyType': serializer.toJson<String>(frequencyType),
      'weekdays': serializer.toJson<String?>(weekdays),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'anchorDate': serializer.toJson<String?>(anchorDate),
      'timesJson': serializer.toJson<String>(timesJson),
      'mealRelation': serializer.toJson<String?>(mealRelation),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ScheduleRow copyWith({
    String? id,
    String? medicationId,
    String? frequencyType,
    Value<String?> weekdays = const Value.absent(),
    Value<int?> intervalDays = const Value.absent(),
    Value<String?> anchorDate = const Value.absent(),
    String? timesJson,
    Value<String?> mealRelation = const Value.absent(),
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    String? status,
    int? createdAt,
  }) => ScheduleRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    frequencyType: frequencyType ?? this.frequencyType,
    weekdays: weekdays.present ? weekdays.value : this.weekdays,
    intervalDays: intervalDays.present ? intervalDays.value : this.intervalDays,
    anchorDate: anchorDate.present ? anchorDate.value : this.anchorDate,
    timesJson: timesJson ?? this.timesJson,
    mealRelation: mealRelation.present ? mealRelation.value : this.mealRelation,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ScheduleRow copyWithCompanion(MedicationSchedulesCompanion data) {
    return ScheduleRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      frequencyType: data.frequencyType.present
          ? data.frequencyType.value
          : this.frequencyType,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      timesJson: data.timesJson.present ? data.timesJson.value : this.timesJson,
      mealRelation: data.mealRelation.present
          ? data.mealRelation.value
          : this.mealRelation,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('timesJson: $timesJson, ')
          ..write('mealRelation: $mealRelation, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    frequencyType,
    weekdays,
    intervalDays,
    anchorDate,
    timesJson,
    mealRelation,
    startDate,
    endDate,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.frequencyType == this.frequencyType &&
          other.weekdays == this.weekdays &&
          other.intervalDays == this.intervalDays &&
          other.anchorDate == this.anchorDate &&
          other.timesJson == this.timesJson &&
          other.mealRelation == this.mealRelation &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class MedicationSchedulesCompanion extends UpdateCompanion<ScheduleRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> frequencyType;
  final Value<String?> weekdays;
  final Value<int?> intervalDays;
  final Value<String?> anchorDate;
  final Value<String> timesJson;
  final Value<String?> mealRelation;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> rowid;
  const MedicationSchedulesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.mealRelation = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationSchedulesCompanion.insert({
    required String id,
    required String medicationId,
    required String frequencyType,
    this.weekdays = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.anchorDate = const Value.absent(),
    required String timesJson,
    this.mealRelation = const Value.absent(),
    required String startDate,
    this.endDate = const Value.absent(),
    required String status,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       frequencyType = Value(frequencyType),
       timesJson = Value(timesJson),
       startDate = Value(startDate),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ScheduleRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? frequencyType,
    Expression<String>? weekdays,
    Expression<int>? intervalDays,
    Expression<String>? anchorDate,
    Expression<String>? timesJson,
    Expression<String>? mealRelation,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (frequencyType != null) 'frequency_type': frequencyType,
      if (weekdays != null) 'weekdays': weekdays,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (timesJson != null) 'times_json': timesJson,
      if (mealRelation != null) 'meal_relation': mealRelation,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationSchedulesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? frequencyType,
    Value<String?>? weekdays,
    Value<int?>? intervalDays,
    Value<String?>? anchorDate,
    Value<String>? timesJson,
    Value<String?>? mealRelation,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicationSchedulesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      frequencyType: frequencyType ?? this.frequencyType,
      weekdays: weekdays ?? this.weekdays,
      intervalDays: intervalDays ?? this.intervalDays,
      anchorDate: anchorDate ?? this.anchorDate,
      timesJson: timesJson ?? this.timesJson,
      mealRelation: mealRelation ?? this.mealRelation,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (frequencyType.present) {
      map['frequency_type'] = Variable<String>(frequencyType.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<String>(anchorDate.value);
    }
    if (timesJson.present) {
      map['times_json'] = Variable<String>(timesJson.value);
    }
    if (mealRelation.present) {
      map['meal_relation'] = Variable<String>(mealRelation.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('timesJson: $timesJson, ')
          ..write('mealRelation: $mealRelation, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseTasksTable extends DoseTasks
    with TableInfo<$DoseTasksTable, DoseTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
    'scheduled_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<String> scheduledTime = GeneratedColumn<String>(
    'scheduled_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedDoseMeta = const VerificationMeta(
    'plannedDose',
  );
  @override
  late final GeneratedColumn<double> plannedDose = GeneratedColumn<double>(
    'planned_dose',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<int> takenAt = GeneratedColumn<int>(
    'taken_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _markSourceMeta = const VerificationMeta(
    'markSource',
  );
  @override
  late final GeneratedColumn<String> markSource = GeneratedColumn<String>(
    'mark_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduleId,
    medicationId,
    scheduledDate,
    scheduledTime,
    plannedDose,
    status,
    takenAt,
    markSource,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseTaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('planned_dose')) {
      context.handle(
        _plannedDoseMeta,
        plannedDose.isAcceptableOrUnknown(
          data['planned_dose']!,
          _plannedDoseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDoseMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('mark_source')) {
      context.handle(
        _markSourceMeta,
        markSource.isAcceptableOrUnknown(data['mark_source']!, _markSourceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseTaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseTaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_date'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_time'],
      )!,
      plannedDose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_dose'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taken_at'],
      ),
      markSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mark_source'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $DoseTasksTable createAlias(String alias) {
    return $DoseTasksTable(attachedDatabase, alias);
  }
}

class DoseTaskRow extends DataClass implements Insertable<DoseTaskRow> {
  final String id;
  final String scheduleId;
  final String medicationId;
  final String scheduledDate;
  final String scheduledTime;
  final double plannedDose;
  final String status;
  final int? takenAt;
  final String? markSource;
  final String? note;
  const DoseTaskRow({
    required this.id,
    required this.scheduleId,
    required this.medicationId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.plannedDose,
    required this.status,
    this.takenAt,
    this.markSource,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['medication_id'] = Variable<String>(medicationId);
    map['scheduled_date'] = Variable<String>(scheduledDate);
    map['scheduled_time'] = Variable<String>(scheduledTime);
    map['planned_dose'] = Variable<double>(plannedDose);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<int>(takenAt);
    }
    if (!nullToAbsent || markSource != null) {
      map['mark_source'] = Variable<String>(markSource);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DoseTasksCompanion toCompanion(bool nullToAbsent) {
    return DoseTasksCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      medicationId: Value(medicationId),
      scheduledDate: Value(scheduledDate),
      scheduledTime: Value(scheduledTime),
      plannedDose: Value(plannedDose),
      status: Value(status),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      markSource: markSource == null && nullToAbsent
          ? const Value.absent()
          : Value(markSource),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DoseTaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseTaskRow(
      id: serializer.fromJson<String>(json['id']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduledDate: serializer.fromJson<String>(json['scheduledDate']),
      scheduledTime: serializer.fromJson<String>(json['scheduledTime']),
      plannedDose: serializer.fromJson<double>(json['plannedDose']),
      status: serializer.fromJson<String>(json['status']),
      takenAt: serializer.fromJson<int?>(json['takenAt']),
      markSource: serializer.fromJson<String?>(json['markSource']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduledDate': serializer.toJson<String>(scheduledDate),
      'scheduledTime': serializer.toJson<String>(scheduledTime),
      'plannedDose': serializer.toJson<double>(plannedDose),
      'status': serializer.toJson<String>(status),
      'takenAt': serializer.toJson<int?>(takenAt),
      'markSource': serializer.toJson<String?>(markSource),
      'note': serializer.toJson<String?>(note),
    };
  }

  DoseTaskRow copyWith({
    String? id,
    String? scheduleId,
    String? medicationId,
    String? scheduledDate,
    String? scheduledTime,
    double? plannedDose,
    String? status,
    Value<int?> takenAt = const Value.absent(),
    Value<String?> markSource = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => DoseTaskRow(
    id: id ?? this.id,
    scheduleId: scheduleId ?? this.scheduleId,
    medicationId: medicationId ?? this.medicationId,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    scheduledTime: scheduledTime ?? this.scheduledTime,
    plannedDose: plannedDose ?? this.plannedDose,
    status: status ?? this.status,
    takenAt: takenAt.present ? takenAt.value : this.takenAt,
    markSource: markSource.present ? markSource.value : this.markSource,
    note: note.present ? note.value : this.note,
  );
  DoseTaskRow copyWithCompanion(DoseTasksCompanion data) {
    return DoseTaskRow(
      id: data.id.present ? data.id.value : this.id,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      plannedDose: data.plannedDose.present
          ? data.plannedDose.value
          : this.plannedDose,
      status: data.status.present ? data.status.value : this.status,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      markSource: data.markSource.present
          ? data.markSource.value
          : this.markSource,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseTaskRow(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('plannedDose: $plannedDose, ')
          ..write('status: $status, ')
          ..write('takenAt: $takenAt, ')
          ..write('markSource: $markSource, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scheduleId,
    medicationId,
    scheduledDate,
    scheduledTime,
    plannedDose,
    status,
    takenAt,
    markSource,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseTaskRow &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.medicationId == this.medicationId &&
          other.scheduledDate == this.scheduledDate &&
          other.scheduledTime == this.scheduledTime &&
          other.plannedDose == this.plannedDose &&
          other.status == this.status &&
          other.takenAt == this.takenAt &&
          other.markSource == this.markSource &&
          other.note == this.note);
}

class DoseTasksCompanion extends UpdateCompanion<DoseTaskRow> {
  final Value<String> id;
  final Value<String> scheduleId;
  final Value<String> medicationId;
  final Value<String> scheduledDate;
  final Value<String> scheduledTime;
  final Value<double> plannedDose;
  final Value<String> status;
  final Value<int?> takenAt;
  final Value<String?> markSource;
  final Value<String?> note;
  final Value<int> rowid;
  const DoseTasksCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.plannedDose = const Value.absent(),
    this.status = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.markSource = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseTasksCompanion.insert({
    required String id,
    required String scheduleId,
    required String medicationId,
    required String scheduledDate,
    required String scheduledTime,
    required double plannedDose,
    required String status,
    this.takenAt = const Value.absent(),
    this.markSource = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduleId = Value(scheduleId),
       medicationId = Value(medicationId),
       scheduledDate = Value(scheduledDate),
       scheduledTime = Value(scheduledTime),
       plannedDose = Value(plannedDose),
       status = Value(status);
  static Insertable<DoseTaskRow> custom({
    Expression<String>? id,
    Expression<String>? scheduleId,
    Expression<String>? medicationId,
    Expression<String>? scheduledDate,
    Expression<String>? scheduledTime,
    Expression<double>? plannedDose,
    Expression<String>? status,
    Expression<int>? takenAt,
    Expression<String>? markSource,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (plannedDose != null) 'planned_dose': plannedDose,
      if (status != null) 'status': status,
      if (takenAt != null) 'taken_at': takenAt,
      if (markSource != null) 'mark_source': markSource,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? scheduleId,
    Value<String>? medicationId,
    Value<String>? scheduledDate,
    Value<String>? scheduledTime,
    Value<double>? plannedDose,
    Value<String>? status,
    Value<int?>? takenAt,
    Value<String?>? markSource,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return DoseTasksCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      medicationId: medicationId ?? this.medicationId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      plannedDose: plannedDose ?? this.plannedDose,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
      markSource: markSource ?? this.markSource,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<String>(scheduledTime.value);
    }
    if (plannedDose.present) {
      map['planned_dose'] = Variable<double>(plannedDose.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<int>(takenAt.value);
    }
    if (markSource.present) {
      map['mark_source'] = Variable<String>(markSource.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseTasksCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('plannedDose: $plannedDose, ')
          ..write('status: $status, ')
          ..write('takenAt: $takenAt, ')
          ..write('markSource: $markSource, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatSessionsTable extends ChatSessions
    with TableInfo<$ChatSessionsTable, ChatSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChatSessionsTable createAlias(String alias) {
    return $ChatSessionsTable(attachedDatabase, alias);
  }
}

class ChatSessionRow extends DataClass implements Insertable<ChatSessionRow> {
  final String id;
  final int createdAt;
  const ChatSessionRow({required this.id, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ChatSessionsCompanion toCompanion(bool nullToAbsent) {
    return ChatSessionsCompanion(id: Value(id), createdAt: Value(createdAt));
  }

  factory ChatSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatSessionRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ChatSessionRow copyWith({String? id, int? createdAt}) =>
      ChatSessionRow(id: id ?? this.id, createdAt: createdAt ?? this.createdAt);
  ChatSessionRow copyWithCompanion(ChatSessionsCompanion data) {
    return ChatSessionRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSessionRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt);
}

class ChatSessionsCompanion extends UpdateCompanion<ChatSessionRow> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ChatSessionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatSessionsCompanion.insert({
    required String id,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<ChatSessionRow> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatSessionsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ChatSessionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toolNameMeta = const VerificationMeta(
    'toolName',
  );
  @override
  late final GeneratedColumn<String> toolName = GeneratedColumn<String>(
    'tool_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toolPayloadMeta = const VerificationMeta(
    'toolPayload',
  );
  @override
  late final GeneratedColumn<String> toolPayload = GeneratedColumn<String>(
    'tool_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sequence,
    id,
    sessionId,
    role,
    content,
    toolName,
    toolPayload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('tool_name')) {
      context.handle(
        _toolNameMeta,
        toolName.isAcceptableOrUnknown(data['tool_name']!, _toolNameMeta),
      );
    }
    if (data.containsKey('tool_payload')) {
      context.handle(
        _toolPayloadMeta,
        toolPayload.isAcceptableOrUnknown(
          data['tool_payload']!,
          _toolPayloadMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageRow(
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      toolName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_name'],
      ),
      toolPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessageRow extends DataClass implements Insertable<ChatMessageRow> {
  final int sequence;
  final String id;
  final String sessionId;
  final String role;
  final String content;
  final String? toolName;
  final String? toolPayload;
  final int createdAt;
  const ChatMessageRow({
    required this.sequence,
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    this.toolName,
    this.toolPayload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sequence'] = Variable<int>(sequence);
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || toolName != null) {
      map['tool_name'] = Variable<String>(toolName);
    }
    if (!nullToAbsent || toolPayload != null) {
      map['tool_payload'] = Variable<String>(toolPayload);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      sequence: Value(sequence),
      id: Value(id),
      sessionId: Value(sessionId),
      role: Value(role),
      content: Value(content),
      toolName: toolName == null && nullToAbsent
          ? const Value.absent()
          : Value(toolName),
      toolPayload: toolPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(toolPayload),
      createdAt: Value(createdAt),
    );
  }

  factory ChatMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageRow(
      sequence: serializer.fromJson<int>(json['sequence']),
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      toolName: serializer.fromJson<String?>(json['toolName']),
      toolPayload: serializer.fromJson<String?>(json['toolPayload']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sequence': serializer.toJson<int>(sequence),
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'toolName': serializer.toJson<String?>(toolName),
      'toolPayload': serializer.toJson<String?>(toolPayload),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ChatMessageRow copyWith({
    int? sequence,
    String? id,
    String? sessionId,
    String? role,
    String? content,
    Value<String?> toolName = const Value.absent(),
    Value<String?> toolPayload = const Value.absent(),
    int? createdAt,
  }) => ChatMessageRow(
    sequence: sequence ?? this.sequence,
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    role: role ?? this.role,
    content: content ?? this.content,
    toolName: toolName.present ? toolName.value : this.toolName,
    toolPayload: toolPayload.present ? toolPayload.value : this.toolPayload,
    createdAt: createdAt ?? this.createdAt,
  );
  ChatMessageRow copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageRow(
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      toolName: data.toolName.present ? data.toolName.value : this.toolName,
      toolPayload: data.toolPayload.present
          ? data.toolPayload.value
          : this.toolPayload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageRow(')
          ..write('sequence: $sequence, ')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('toolName: $toolName, ')
          ..write('toolPayload: $toolPayload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sequence,
    id,
    sessionId,
    role,
    content,
    toolName,
    toolPayload,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageRow &&
          other.sequence == this.sequence &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.role == this.role &&
          other.content == this.content &&
          other.toolName == this.toolName &&
          other.toolPayload == this.toolPayload &&
          other.createdAt == this.createdAt);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageRow> {
  final Value<int> sequence;
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> role;
  final Value<String> content;
  final Value<String?> toolName;
  final Value<String?> toolPayload;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.sequence = const Value.absent(),
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.toolName = const Value.absent(),
    this.toolPayload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.sequence = const Value.absent(),
    required String id,
    required String sessionId,
    required String role,
    required String content,
    this.toolName = const Value.absent(),
    this.toolPayload = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<ChatMessageRow> custom({
    Expression<int>? sequence,
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? toolName,
    Expression<String>? toolPayload,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sequence != null) 'sequence': sequence,
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (toolName != null) 'tool_name': toolName,
      if (toolPayload != null) 'tool_payload': toolPayload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? sequence,
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? role,
    Value<String>? content,
    Value<String?>? toolName,
    Value<String?>? toolPayload,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ChatMessagesCompanion(
      sequence: sequence ?? this.sequence,
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      toolName: toolName ?? this.toolName,
      toolPayload: toolPayload ?? this.toolPayload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (toolName.present) {
      map['tool_name'] = Variable<String>(toolName.value);
    }
    if (toolPayload.present) {
      map['tool_payload'] = Variable<String>(toolPayload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('sequence: $sequence, ')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('toolName: $toolName, ')
          ..write('toolPayload: $toolPayload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiModelConfigsTable extends AiModelConfigs
    with TableInfo<$AiModelConfigsTable, ModelConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiModelConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contextWindowTokensMeta =
      const VerificationMeta('contextWindowTokens');
  @override
  late final GeneratedColumn<int> contextWindowTokens = GeneratedColumn<int>(
    'context_window_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8192),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supportsChatMeta = const VerificationMeta(
    'supportsChat',
  );
  @override
  late final GeneratedColumn<bool> supportsChat = GeneratedColumn<bool>(
    'supports_chat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_chat" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _supportsVisionMeta = const VerificationMeta(
    'supportsVision',
  );
  @override
  late final GeneratedColumn<bool> supportsVision = GeneratedColumn<bool>(
    'supports_vision',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_vision" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _supportsFunctionCallingMeta =
      const VerificationMeta('supportsFunctionCalling');
  @override
  late final GeneratedColumn<bool> supportsFunctionCalling =
      GeneratedColumn<bool>(
        'supports_function_calling',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("supports_function_calling" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxTokensMeta = const VerificationMeta(
    'maxTokens',
  );
  @override
  late final GeneratedColumn<int> maxTokens = GeneratedColumn<int>(
    'max_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageMeta = const VerificationMeta('usage');
  @override
  late final GeneratedColumn<String> usage = GeneratedColumn<String>(
    'usage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isChatDefaultMeta = const VerificationMeta(
    'isChatDefault',
  );
  @override
  late final GeneratedColumn<bool> isChatDefault = GeneratedColumn<bool>(
    'is_chat_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_chat_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contextWindowTokens,
    id,
    name,
    baseUrl,
    modelId,
    supportsChat,
    supportsVision,
    supportsFunctionCalling,
    temperature,
    maxTokens,
    usage,
    isChatDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_model_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelConfigRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('context_window_tokens')) {
      context.handle(
        _contextWindowTokensMeta,
        contextWindowTokens.isAcceptableOrUnknown(
          data['context_window_tokens']!,
          _contextWindowTokensMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('supports_chat')) {
      context.handle(
        _supportsChatMeta,
        supportsChat.isAcceptableOrUnknown(
          data['supports_chat']!,
          _supportsChatMeta,
        ),
      );
    }
    if (data.containsKey('supports_vision')) {
      context.handle(
        _supportsVisionMeta,
        supportsVision.isAcceptableOrUnknown(
          data['supports_vision']!,
          _supportsVisionMeta,
        ),
      );
    }
    if (data.containsKey('supports_function_calling')) {
      context.handle(
        _supportsFunctionCallingMeta,
        supportsFunctionCalling.isAcceptableOrUnknown(
          data['supports_function_calling']!,
          _supportsFunctionCallingMeta,
        ),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('max_tokens')) {
      context.handle(
        _maxTokensMeta,
        maxTokens.isAcceptableOrUnknown(data['max_tokens']!, _maxTokensMeta),
      );
    }
    if (data.containsKey('usage')) {
      context.handle(
        _usageMeta,
        usage.isAcceptableOrUnknown(data['usage']!, _usageMeta),
      );
    } else if (isInserting) {
      context.missing(_usageMeta);
    }
    if (data.containsKey('is_chat_default')) {
      context.handle(
        _isChatDefaultMeta,
        isChatDefault.isAcceptableOrUnknown(
          data['is_chat_default']!,
          _isChatDefaultMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelConfigRow(
      contextWindowTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}context_window_tokens'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      supportsChat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_chat'],
      )!,
      supportsVision: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_vision'],
      )!,
      supportsFunctionCalling: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_function_calling'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      maxTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_tokens'],
      ),
      usage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usage'],
      )!,
      isChatDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_chat_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AiModelConfigsTable createAlias(String alias) {
    return $AiModelConfigsTable(attachedDatabase, alias);
  }
}

class ModelConfigRow extends DataClass implements Insertable<ModelConfigRow> {
  final int contextWindowTokens;
  final String id;
  final String name;
  final String baseUrl;
  final String modelId;
  final bool supportsChat;
  final bool supportsVision;
  final bool supportsFunctionCalling;
  final double? temperature;
  final int? maxTokens;
  final String usage;
  final bool isChatDefault;
  final int createdAt;
  const ModelConfigRow({
    required this.contextWindowTokens,
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.modelId,
    required this.supportsChat,
    required this.supportsVision,
    required this.supportsFunctionCalling,
    this.temperature,
    this.maxTokens,
    required this.usage,
    required this.isChatDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['context_window_tokens'] = Variable<int>(contextWindowTokens);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['base_url'] = Variable<String>(baseUrl);
    map['model_id'] = Variable<String>(modelId);
    map['supports_chat'] = Variable<bool>(supportsChat);
    map['supports_vision'] = Variable<bool>(supportsVision);
    map['supports_function_calling'] = Variable<bool>(supportsFunctionCalling);
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || maxTokens != null) {
      map['max_tokens'] = Variable<int>(maxTokens);
    }
    map['usage'] = Variable<String>(usage);
    map['is_chat_default'] = Variable<bool>(isChatDefault);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  AiModelConfigsCompanion toCompanion(bool nullToAbsent) {
    return AiModelConfigsCompanion(
      contextWindowTokens: Value(contextWindowTokens),
      id: Value(id),
      name: Value(name),
      baseUrl: Value(baseUrl),
      modelId: Value(modelId),
      supportsChat: Value(supportsChat),
      supportsVision: Value(supportsVision),
      supportsFunctionCalling: Value(supportsFunctionCalling),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      maxTokens: maxTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(maxTokens),
      usage: Value(usage),
      isChatDefault: Value(isChatDefault),
      createdAt: Value(createdAt),
    );
  }

  factory ModelConfigRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelConfigRow(
      contextWindowTokens: serializer.fromJson<int>(
        json['contextWindowTokens'],
      ),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      modelId: serializer.fromJson<String>(json['modelId']),
      supportsChat: serializer.fromJson<bool>(json['supportsChat']),
      supportsVision: serializer.fromJson<bool>(json['supportsVision']),
      supportsFunctionCalling: serializer.fromJson<bool>(
        json['supportsFunctionCalling'],
      ),
      temperature: serializer.fromJson<double?>(json['temperature']),
      maxTokens: serializer.fromJson<int?>(json['maxTokens']),
      usage: serializer.fromJson<String>(json['usage']),
      isChatDefault: serializer.fromJson<bool>(json['isChatDefault']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contextWindowTokens': serializer.toJson<int>(contextWindowTokens),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'modelId': serializer.toJson<String>(modelId),
      'supportsChat': serializer.toJson<bool>(supportsChat),
      'supportsVision': serializer.toJson<bool>(supportsVision),
      'supportsFunctionCalling': serializer.toJson<bool>(
        supportsFunctionCalling,
      ),
      'temperature': serializer.toJson<double?>(temperature),
      'maxTokens': serializer.toJson<int?>(maxTokens),
      'usage': serializer.toJson<String>(usage),
      'isChatDefault': serializer.toJson<bool>(isChatDefault),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ModelConfigRow copyWith({
    int? contextWindowTokens,
    String? id,
    String? name,
    String? baseUrl,
    String? modelId,
    bool? supportsChat,
    bool? supportsVision,
    bool? supportsFunctionCalling,
    Value<double?> temperature = const Value.absent(),
    Value<int?> maxTokens = const Value.absent(),
    String? usage,
    bool? isChatDefault,
    int? createdAt,
  }) => ModelConfigRow(
    contextWindowTokens: contextWindowTokens ?? this.contextWindowTokens,
    id: id ?? this.id,
    name: name ?? this.name,
    baseUrl: baseUrl ?? this.baseUrl,
    modelId: modelId ?? this.modelId,
    supportsChat: supportsChat ?? this.supportsChat,
    supportsVision: supportsVision ?? this.supportsVision,
    supportsFunctionCalling:
        supportsFunctionCalling ?? this.supportsFunctionCalling,
    temperature: temperature.present ? temperature.value : this.temperature,
    maxTokens: maxTokens.present ? maxTokens.value : this.maxTokens,
    usage: usage ?? this.usage,
    isChatDefault: isChatDefault ?? this.isChatDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  ModelConfigRow copyWithCompanion(AiModelConfigsCompanion data) {
    return ModelConfigRow(
      contextWindowTokens: data.contextWindowTokens.present
          ? data.contextWindowTokens.value
          : this.contextWindowTokens,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      supportsChat: data.supportsChat.present
          ? data.supportsChat.value
          : this.supportsChat,
      supportsVision: data.supportsVision.present
          ? data.supportsVision.value
          : this.supportsVision,
      supportsFunctionCalling: data.supportsFunctionCalling.present
          ? data.supportsFunctionCalling.value
          : this.supportsFunctionCalling,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      maxTokens: data.maxTokens.present ? data.maxTokens.value : this.maxTokens,
      usage: data.usage.present ? data.usage.value : this.usage,
      isChatDefault: data.isChatDefault.present
          ? data.isChatDefault.value
          : this.isChatDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelConfigRow(')
          ..write('contextWindowTokens: $contextWindowTokens, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('modelId: $modelId, ')
          ..write('supportsChat: $supportsChat, ')
          ..write('supportsVision: $supportsVision, ')
          ..write('supportsFunctionCalling: $supportsFunctionCalling, ')
          ..write('temperature: $temperature, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('usage: $usage, ')
          ..write('isChatDefault: $isChatDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contextWindowTokens,
    id,
    name,
    baseUrl,
    modelId,
    supportsChat,
    supportsVision,
    supportsFunctionCalling,
    temperature,
    maxTokens,
    usage,
    isChatDefault,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelConfigRow &&
          other.contextWindowTokens == this.contextWindowTokens &&
          other.id == this.id &&
          other.name == this.name &&
          other.baseUrl == this.baseUrl &&
          other.modelId == this.modelId &&
          other.supportsChat == this.supportsChat &&
          other.supportsVision == this.supportsVision &&
          other.supportsFunctionCalling == this.supportsFunctionCalling &&
          other.temperature == this.temperature &&
          other.maxTokens == this.maxTokens &&
          other.usage == this.usage &&
          other.isChatDefault == this.isChatDefault &&
          other.createdAt == this.createdAt);
}

class AiModelConfigsCompanion extends UpdateCompanion<ModelConfigRow> {
  final Value<int> contextWindowTokens;
  final Value<String> id;
  final Value<String> name;
  final Value<String> baseUrl;
  final Value<String> modelId;
  final Value<bool> supportsChat;
  final Value<bool> supportsVision;
  final Value<bool> supportsFunctionCalling;
  final Value<double?> temperature;
  final Value<int?> maxTokens;
  final Value<String> usage;
  final Value<bool> isChatDefault;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AiModelConfigsCompanion({
    this.contextWindowTokens = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.modelId = const Value.absent(),
    this.supportsChat = const Value.absent(),
    this.supportsVision = const Value.absent(),
    this.supportsFunctionCalling = const Value.absent(),
    this.temperature = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.usage = const Value.absent(),
    this.isChatDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiModelConfigsCompanion.insert({
    this.contextWindowTokens = const Value.absent(),
    required String id,
    required String name,
    required String baseUrl,
    required String modelId,
    this.supportsChat = const Value.absent(),
    this.supportsVision = const Value.absent(),
    this.supportsFunctionCalling = const Value.absent(),
    this.temperature = const Value.absent(),
    this.maxTokens = const Value.absent(),
    required String usage,
    this.isChatDefault = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       baseUrl = Value(baseUrl),
       modelId = Value(modelId),
       usage = Value(usage),
       createdAt = Value(createdAt);
  static Insertable<ModelConfigRow> custom({
    Expression<int>? contextWindowTokens,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? baseUrl,
    Expression<String>? modelId,
    Expression<bool>? supportsChat,
    Expression<bool>? supportsVision,
    Expression<bool>? supportsFunctionCalling,
    Expression<double>? temperature,
    Expression<int>? maxTokens,
    Expression<String>? usage,
    Expression<bool>? isChatDefault,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contextWindowTokens != null)
        'context_window_tokens': contextWindowTokens,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (baseUrl != null) 'base_url': baseUrl,
      if (modelId != null) 'model_id': modelId,
      if (supportsChat != null) 'supports_chat': supportsChat,
      if (supportsVision != null) 'supports_vision': supportsVision,
      if (supportsFunctionCalling != null)
        'supports_function_calling': supportsFunctionCalling,
      if (temperature != null) 'temperature': temperature,
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (usage != null) 'usage': usage,
      if (isChatDefault != null) 'is_chat_default': isChatDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiModelConfigsCompanion copyWith({
    Value<int>? contextWindowTokens,
    Value<String>? id,
    Value<String>? name,
    Value<String>? baseUrl,
    Value<String>? modelId,
    Value<bool>? supportsChat,
    Value<bool>? supportsVision,
    Value<bool>? supportsFunctionCalling,
    Value<double?>? temperature,
    Value<int?>? maxTokens,
    Value<String>? usage,
    Value<bool>? isChatDefault,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return AiModelConfigsCompanion(
      contextWindowTokens: contextWindowTokens ?? this.contextWindowTokens,
      id: id ?? this.id,
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      modelId: modelId ?? this.modelId,
      supportsChat: supportsChat ?? this.supportsChat,
      supportsVision: supportsVision ?? this.supportsVision,
      supportsFunctionCalling:
          supportsFunctionCalling ?? this.supportsFunctionCalling,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      usage: usage ?? this.usage,
      isChatDefault: isChatDefault ?? this.isChatDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contextWindowTokens.present) {
      map['context_window_tokens'] = Variable<int>(contextWindowTokens.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (supportsChat.present) {
      map['supports_chat'] = Variable<bool>(supportsChat.value);
    }
    if (supportsVision.present) {
      map['supports_vision'] = Variable<bool>(supportsVision.value);
    }
    if (supportsFunctionCalling.present) {
      map['supports_function_calling'] = Variable<bool>(
        supportsFunctionCalling.value,
      );
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (maxTokens.present) {
      map['max_tokens'] = Variable<int>(maxTokens.value);
    }
    if (usage.present) {
      map['usage'] = Variable<String>(usage.value);
    }
    if (isChatDefault.present) {
      map['is_chat_default'] = Variable<bool>(isChatDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiModelConfigsCompanion(')
          ..write('contextWindowTokens: $contextWindowTokens, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('modelId: $modelId, ')
          ..write('supportsChat: $supportsChat, ')
          ..write('supportsVision: $supportsVision, ')
          ..write('supportsFunctionCalling: $supportsFunctionCalling, ')
          ..write('temperature: $temperature, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('usage: $usage, ')
          ..write('isChatDefault: $isChatDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationDraftsTable extends MedicationDrafts
    with TableInfo<$MedicationDraftsTable, DraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    payloadJson,
    photoPath,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationDraftsTable createAlias(String alias) {
    return $MedicationDraftsTable(attachedDatabase, alias);
  }
}

class DraftRow extends DataClass implements Insertable<DraftRow> {
  final String id;
  final String source;
  final String payloadJson;
  final String? photoPath;
  final String status;
  final int createdAt;
  const DraftRow({
    required this.id,
    required this.source,
    required this.payloadJson,
    this.photoPath,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source'] = Variable<String>(source);
    map['payload_json'] = Variable<String>(payloadJson);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MedicationDraftsCompanion toCompanion(bool nullToAbsent) {
    return MedicationDraftsCompanion(
      id: Value(id),
      source: Value(source),
      payloadJson: Value(payloadJson),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory DraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftRow(
      id: serializer.fromJson<String>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source': serializer.toJson<String>(source),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'photoPath': serializer.toJson<String?>(photoPath),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  DraftRow copyWith({
    String? id,
    String? source,
    String? payloadJson,
    Value<String?> photoPath = const Value.absent(),
    String? status,
    int? createdAt,
  }) => DraftRow(
    id: id ?? this.id,
    source: source ?? this.source,
    payloadJson: payloadJson ?? this.payloadJson,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  DraftRow copyWithCompanion(MedicationDraftsCompanion data) {
    return DraftRow(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftRow(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('photoPath: $photoPath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, source, payloadJson, photoPath, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftRow &&
          other.id == this.id &&
          other.source == this.source &&
          other.payloadJson == this.payloadJson &&
          other.photoPath == this.photoPath &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class MedicationDraftsCompanion extends UpdateCompanion<DraftRow> {
  final Value<String> id;
  final Value<String> source;
  final Value<String> payloadJson;
  final Value<String?> photoPath;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> rowid;
  const MedicationDraftsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationDraftsCompanion.insert({
    required String id,
    required String source,
    required String payloadJson,
    this.photoPath = const Value.absent(),
    required String status,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       source = Value(source),
       payloadJson = Value(payloadJson),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<DraftRow> custom({
    Expression<String>? id,
    Expression<String>? source,
    Expression<String>? payloadJson,
    Expression<String>? photoPath,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (photoPath != null) 'photo_path': photoPath,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? source,
    Value<String>? payloadJson,
    Value<String?>? photoPath,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicationDraftsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      payloadJson: payloadJson ?? this.payloadJson,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationDraftsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('photoPath: $photoPath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgentRecordsTable extends AgentRecords
    with TableInfo<$AgentRecordsTable, AgentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agent_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AgentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $AgentRecordsTable createAlias(String alias) {
    return $AgentRecordsTable(attachedDatabase, alias);
  }
}

class AgentRecord extends DataClass implements Insertable<AgentRecord> {
  final String id;
  final String kind;
  final String payload;
  const AgentRecord({
    required this.id,
    required this.kind,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  AgentRecordsCompanion toCompanion(bool nullToAbsent) {
    return AgentRecordsCompanion(
      id: Value(id),
      kind: Value(kind),
      payload: Value(payload),
    );
  }

  factory AgentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgentRecord(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String>(payload),
    };
  }

  AgentRecord copyWith({String? id, String? kind, String? payload}) =>
      AgentRecord(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        payload: payload ?? this.payload,
      );
  AgentRecord copyWithCompanion(AgentRecordsCompanion data) {
    return AgentRecord(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgentRecord(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgentRecord &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.payload == this.payload);
}

class AgentRecordsCompanion extends UpdateCompanion<AgentRecord> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> payload;
  final Value<int> rowid;
  const AgentRecordsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgentRecordsCompanion.insert({
    required String id,
    required String kind,
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       payload = Value(payload);
  static Insertable<AgentRecord> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgentRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return AgentRecordsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationSchedulesTable medicationSchedules =
      $MedicationSchedulesTable(this);
  late final $DoseTasksTable doseTasks = $DoseTasksTable(this);
  late final $ChatSessionsTable chatSessions = $ChatSessionsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $AiModelConfigsTable aiModelConfigs = $AiModelConfigsTable(this);
  late final $MedicationDraftsTable medicationDrafts = $MedicationDraftsTable(
    this,
  );
  late final $AgentRecordsTable agentRecords = $AgentRecordsTable(this);
  late final Index idxTasksDateTime = Index(
    'idx_tasks_date_time',
    'CREATE INDEX idx_tasks_date_time ON dose_tasks (scheduled_date, scheduled_time)',
  );
  late final Index idxTasksMedDate = Index(
    'idx_tasks_med_date',
    'CREATE INDEX idx_tasks_med_date ON dose_tasks (medication_id, scheduled_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    medications,
    medicationSchedules,
    doseTasks,
    chatSessions,
    chatMessages,
    aiModelConfigs,
    medicationDrafts,
    agentRecords,
    idxTasksDateTime,
    idxTasksMedDate,
  ];
}

typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String name,
      required String form,
      Value<String?> spec,
      required String doseUnit,
      Value<String?> notes,
      Value<String?> photoPath,
      required String source,
      Value<String?> aiExtractJson,
      required String status,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> form,
      Value<String?> spec,
      Value<String> doseUnit,
      Value<String?> notes,
      Value<String?> photoPath,
      Value<String> source,
      Value<String?> aiExtractJson,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spec => $composableBuilder(
    column: $table.spec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doseUnit => $composableBuilder(
    column: $table.doseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiExtractJson => $composableBuilder(
    column: $table.aiExtractJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spec => $composableBuilder(
    column: $table.spec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doseUnit => $composableBuilder(
    column: $table.doseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiExtractJson => $composableBuilder(
    column: $table.aiExtractJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get spec =>
      $composableBuilder(column: $table.spec, builder: (column) => column);

  GeneratedColumn<String> get doseUnit =>
      $composableBuilder(column: $table.doseUnit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get aiExtractJson => $composableBuilder(
    column: $table.aiExtractJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          MedicationRow,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (
            MedicationRow,
            BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRow>,
          ),
          MedicationRow,
          PrefetchHooks Function()
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> form = const Value.absent(),
                Value<String?> spec = const Value.absent(),
                Value<String> doseUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> aiExtractJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                form: form,
                spec: spec,
                doseUnit: doseUnit,
                notes: notes,
                photoPath: photoPath,
                source: source,
                aiExtractJson: aiExtractJson,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String form,
                Value<String?> spec = const Value.absent(),
                required String doseUnit,
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required String source,
                Value<String?> aiExtractJson = const Value.absent(),
                required String status,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                form: form,
                spec: spec,
                doseUnit: doseUnit,
                notes: notes,
                photoPath: photoPath,
                source: source,
                aiExtractJson: aiExtractJson,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, MedicationRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MedicationsTable,
                    MedicationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      MedicationRow,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (
        MedicationRow,
        BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRow>,
      ),
      MedicationRow,
      PrefetchHooks Function()
    >;
typedef $$MedicationSchedulesTableCreateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      required String id,
      required String medicationId,
      required String frequencyType,
      Value<String?> weekdays,
      Value<int?> intervalDays,
      Value<String?> anchorDate,
      required String timesJson,
      Value<String?> mealRelation,
      required String startDate,
      Value<String?> endDate,
      required String status,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$MedicationSchedulesTableUpdateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> frequencyType,
      Value<String?> weekdays,
      Value<int?> intervalDays,
      Value<String?> anchorDate,
      Value<String> timesJson,
      Value<String?> mealRelation,
      Value<String> startDate,
      Value<String?> endDate,
      Value<String> status,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$MedicationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timesJson => $composableBuilder(
    column: $table.timesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealRelation => $composableBuilder(
    column: $table.mealRelation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timesJson => $composableBuilder(
    column: $table.timesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealRelation => $composableBuilder(
    column: $table.mealRelation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => column);

  GeneratedColumn<String> get mealRelation => $composableBuilder(
    column: $table.mealRelation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MedicationSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationSchedulesTable,
          ScheduleRow,
          $$MedicationSchedulesTableFilterComposer,
          $$MedicationSchedulesTableOrderingComposer,
          $$MedicationSchedulesTableAnnotationComposer,
          $$MedicationSchedulesTableCreateCompanionBuilder,
          $$MedicationSchedulesTableUpdateCompanionBuilder,
          (
            ScheduleRow,
            BaseReferences<
              _$AppDatabase,
              $MedicationSchedulesTable,
              ScheduleRow
            >,
          ),
          ScheduleRow,
          PrefetchHooks Function()
        > {
  $$MedicationSchedulesTableTableManager(
    _$AppDatabase db,
    $MedicationSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationSchedulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MedicationSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> frequencyType = const Value.absent(),
                Value<String?> weekdays = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<String?> anchorDate = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<String?> mealRelation = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationSchedulesCompanion(
                id: id,
                medicationId: medicationId,
                frequencyType: frequencyType,
                weekdays: weekdays,
                intervalDays: intervalDays,
                anchorDate: anchorDate,
                timesJson: timesJson,
                mealRelation: mealRelation,
                startDate: startDate,
                endDate: endDate,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String frequencyType,
                Value<String?> weekdays = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<String?> anchorDate = const Value.absent(),
                required String timesJson,
                Value<String?> mealRelation = const Value.absent(),
                required String startDate,
                Value<String?> endDate = const Value.absent(),
                required String status,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationSchedulesCompanion.insert(
                id: id,
                medicationId: medicationId,
                frequencyType: frequencyType,
                weekdays: weekdays,
                intervalDays: intervalDays,
                anchorDate: anchorDate,
                timesJson: timesJson,
                mealRelation: mealRelation,
                startDate: startDate,
                endDate: endDate,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationSchedulesTable, ScheduleRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MedicationSchedulesTable,
                    ScheduleRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationSchedulesTable,
      ScheduleRow,
      $$MedicationSchedulesTableFilterComposer,
      $$MedicationSchedulesTableOrderingComposer,
      $$MedicationSchedulesTableAnnotationComposer,
      $$MedicationSchedulesTableCreateCompanionBuilder,
      $$MedicationSchedulesTableUpdateCompanionBuilder,
      (
        ScheduleRow,
        BaseReferences<_$AppDatabase, $MedicationSchedulesTable, ScheduleRow>,
      ),
      ScheduleRow,
      PrefetchHooks Function()
    >;
typedef $$DoseTasksTableCreateCompanionBuilder = DoseTasksCompanion Function({
  required String id,
  required String scheduleId,
  required String medicationId,
  required String scheduledDate,
  required String scheduledTime,
  required double plannedDose,
  required String status,
  Value<int?> takenAt,
  Value<String?> markSource,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$DoseTasksTableUpdateCompanionBuilder = DoseTasksCompanion Function({
  Value<String> id,
  Value<String> scheduleId,
  Value<String> medicationId,
  Value<String> scheduledDate,
  Value<String> scheduledTime,
  Value<double> plannedDose,
  Value<String> status,
  Value<int?> takenAt,
  Value<String?> markSource,
  Value<String?> note,
  Value<int> rowid,
});

class $$DoseTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DoseTasksTable> {
  $$DoseTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedDose => $composableBuilder(
    column: $table.plannedDose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get markSource => $composableBuilder(
    column: $table.markSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DoseTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseTasksTable> {
  $$DoseTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedDose => $composableBuilder(
    column: $table.plannedDose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get markSource => $composableBuilder(
    column: $table.markSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoseTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseTasksTable> {
  $$DoseTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedDose => $composableBuilder(
    column: $table.plannedDose,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get markSource => $composableBuilder(
    column: $table.markSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$DoseTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoseTasksTable,
          DoseTaskRow,
          $$DoseTasksTableFilterComposer,
          $$DoseTasksTableOrderingComposer,
          $$DoseTasksTableAnnotationComposer,
          $$DoseTasksTableCreateCompanionBuilder,
          $$DoseTasksTableUpdateCompanionBuilder,
          (
            DoseTaskRow,
            BaseReferences<_$AppDatabase, $DoseTasksTable, DoseTaskRow>,
          ),
          DoseTaskRow,
          PrefetchHooks Function()
        > {
  $$DoseTasksTableTableManager(_$AppDatabase db, $DoseTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scheduleId = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> scheduledDate = const Value.absent(),
                Value<String> scheduledTime = const Value.absent(),
                Value<double> plannedDose = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> takenAt = const Value.absent(),
                Value<String?> markSource = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseTasksCompanion(
                id: id,
                scheduleId: scheduleId,
                medicationId: medicationId,
                scheduledDate: scheduledDate,
                scheduledTime: scheduledTime,
                plannedDose: plannedDose,
                status: status,
                takenAt: takenAt,
                markSource: markSource,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scheduleId,
                required String medicationId,
                required String scheduledDate,
                required String scheduledTime,
                required double plannedDose,
                required String status,
                Value<int?> takenAt = const Value.absent(),
                Value<String?> markSource = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseTasksCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                medicationId: medicationId,
                scheduledDate: scheduledDate,
                scheduledTime: scheduledTime,
                plannedDose: plannedDose,
                status: status,
                takenAt: takenAt,
                markSource: markSource,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoseTasksTable, DoseTaskRow>(table),
                  BaseReferences<_$AppDatabase, $DoseTasksTable, DoseTaskRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DoseTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoseTasksTable,
      DoseTaskRow,
      $$DoseTasksTableFilterComposer,
      $$DoseTasksTableOrderingComposer,
      $$DoseTasksTableAnnotationComposer,
      $$DoseTasksTableCreateCompanionBuilder,
      $$DoseTasksTableUpdateCompanionBuilder,
      (
        DoseTaskRow,
        BaseReferences<_$AppDatabase, $DoseTasksTable, DoseTaskRow>,
      ),
      DoseTaskRow,
      PrefetchHooks Function()
    >;
typedef $$ChatSessionsTableCreateCompanionBuilder =
    ChatSessionsCompanion Function({
      required String id,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ChatSessionsTableUpdateCompanionBuilder =
    ChatSessionsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$ChatSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatSessionsTable,
          ChatSessionRow,
          $$ChatSessionsTableFilterComposer,
          $$ChatSessionsTableOrderingComposer,
          $$ChatSessionsTableAnnotationComposer,
          $$ChatSessionsTableCreateCompanionBuilder,
          $$ChatSessionsTableUpdateCompanionBuilder,
          (
            ChatSessionRow,
            BaseReferences<_$AppDatabase, $ChatSessionsTable, ChatSessionRow>,
          ),
          ChatSessionRow,
          PrefetchHooks Function()
        > {
  $$ChatSessionsTableTableManager(_$AppDatabase db, $ChatSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatSessionsCompanion(
                id: id,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ChatSessionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatSessionsTable, ChatSessionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChatSessionsTable,
                    ChatSessionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatSessionsTable,
      ChatSessionRow,
      $$ChatSessionsTableFilterComposer,
      $$ChatSessionsTableOrderingComposer,
      $$ChatSessionsTableAnnotationComposer,
      $$ChatSessionsTableCreateCompanionBuilder,
      $$ChatSessionsTableUpdateCompanionBuilder,
      (
        ChatSessionRow,
        BaseReferences<_$AppDatabase, $ChatSessionsTable, ChatSessionRow>,
      ),
      ChatSessionRow,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> sequence,
      required String id,
      required String sessionId,
      required String role,
      required String content,
      Value<String?> toolName,
      Value<String?> toolPayload,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> sequence,
      Value<String> id,
      Value<String> sessionId,
      Value<String> role,
      Value<String> content,
      Value<String?> toolName,
      Value<String?> toolPayload,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolName => $composableBuilder(
    column: $table.toolName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolPayload => $composableBuilder(
    column: $table.toolPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolName => $composableBuilder(
    column: $table.toolName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolPayload => $composableBuilder(
    column: $table.toolPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get toolName =>
      $composableBuilder(column: $table.toolName, builder: (column) => column);

  GeneratedColumn<String> get toolPayload => $composableBuilder(
    column: $table.toolPayload,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessageRow,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessageRow,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageRow>,
          ),
          ChatMessageRow,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sequence = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> toolName = const Value.absent(),
                Value<String?> toolPayload = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion(
                sequence: sequence,
                id: id,
                sessionId: sessionId,
                role: role,
                content: content,
                toolName: toolName,
                toolPayload: toolPayload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> sequence = const Value.absent(),
                required String id,
                required String sessionId,
                required String role,
                required String content,
                Value<String?> toolName = const Value.absent(),
                Value<String?> toolPayload = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                sequence: sequence,
                id: id,
                sessionId: sessionId,
                role: role,
                content: content,
                toolName: toolName,
                toolPayload: toolPayload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatMessagesTable, ChatMessageRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChatMessagesTable,
                    ChatMessageRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessageRow,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessageRow,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageRow>,
      ),
      ChatMessageRow,
      PrefetchHooks Function()
    >;
typedef $$AiModelConfigsTableCreateCompanionBuilder =
    AiModelConfigsCompanion Function({
      Value<int> contextWindowTokens,
      required String id,
      required String name,
      required String baseUrl,
      required String modelId,
      Value<bool> supportsChat,
      Value<bool> supportsVision,
      Value<bool> supportsFunctionCalling,
      Value<double?> temperature,
      Value<int?> maxTokens,
      required String usage,
      Value<bool> isChatDefault,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$AiModelConfigsTableUpdateCompanionBuilder =
    AiModelConfigsCompanion Function({
      Value<int> contextWindowTokens,
      Value<String> id,
      Value<String> name,
      Value<String> baseUrl,
      Value<String> modelId,
      Value<bool> supportsChat,
      Value<bool> supportsVision,
      Value<bool> supportsFunctionCalling,
      Value<double?> temperature,
      Value<int?> maxTokens,
      Value<String> usage,
      Value<bool> isChatDefault,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$AiModelConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $AiModelConfigsTable> {
  $$AiModelConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get contextWindowTokens => $composableBuilder(
    column: $table.contextWindowTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsChat => $composableBuilder(
    column: $table.supportsChat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsVision => $composableBuilder(
    column: $table.supportsVision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsFunctionCalling => $composableBuilder(
    column: $table.supportsFunctionCalling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usage => $composableBuilder(
    column: $table.usage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChatDefault => $composableBuilder(
    column: $table.isChatDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiModelConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiModelConfigsTable> {
  $$AiModelConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get contextWindowTokens => $composableBuilder(
    column: $table.contextWindowTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsChat => $composableBuilder(
    column: $table.supportsChat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsVision => $composableBuilder(
    column: $table.supportsVision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsFunctionCalling => $composableBuilder(
    column: $table.supportsFunctionCalling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usage => $composableBuilder(
    column: $table.usage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChatDefault => $composableBuilder(
    column: $table.isChatDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiModelConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiModelConfigsTable> {
  $$AiModelConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get contextWindowTokens => $composableBuilder(
    column: $table.contextWindowTokens,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<bool> get supportsChat => $composableBuilder(
    column: $table.supportsChat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsVision => $composableBuilder(
    column: $table.supportsVision,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsFunctionCalling => $composableBuilder(
    column: $table.supportsFunctionCalling,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxTokens =>
      $composableBuilder(column: $table.maxTokens, builder: (column) => column);

  GeneratedColumn<String> get usage =>
      $composableBuilder(column: $table.usage, builder: (column) => column);

  GeneratedColumn<bool> get isChatDefault => $composableBuilder(
    column: $table.isChatDefault,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AiModelConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiModelConfigsTable,
          ModelConfigRow,
          $$AiModelConfigsTableFilterComposer,
          $$AiModelConfigsTableOrderingComposer,
          $$AiModelConfigsTableAnnotationComposer,
          $$AiModelConfigsTableCreateCompanionBuilder,
          $$AiModelConfigsTableUpdateCompanionBuilder,
          (
            ModelConfigRow,
            BaseReferences<_$AppDatabase, $AiModelConfigsTable, ModelConfigRow>,
          ),
          ModelConfigRow,
          PrefetchHooks Function()
        > {
  $$AiModelConfigsTableTableManager(
    _$AppDatabase db,
    $AiModelConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiModelConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiModelConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiModelConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contextWindowTokens = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<bool> supportsChat = const Value.absent(),
                Value<bool> supportsVision = const Value.absent(),
                Value<bool> supportsFunctionCalling = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<String> usage = const Value.absent(),
                Value<bool> isChatDefault = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiModelConfigsCompanion(
                contextWindowTokens: contextWindowTokens,
                id: id,
                name: name,
                baseUrl: baseUrl,
                modelId: modelId,
                supportsChat: supportsChat,
                supportsVision: supportsVision,
                supportsFunctionCalling: supportsFunctionCalling,
                temperature: temperature,
                maxTokens: maxTokens,
                usage: usage,
                isChatDefault: isChatDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> contextWindowTokens = const Value.absent(),
                required String id,
                required String name,
                required String baseUrl,
                required String modelId,
                Value<bool> supportsChat = const Value.absent(),
                Value<bool> supportsVision = const Value.absent(),
                Value<bool> supportsFunctionCalling = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                required String usage,
                Value<bool> isChatDefault = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AiModelConfigsCompanion.insert(
                contextWindowTokens: contextWindowTokens,
                id: id,
                name: name,
                baseUrl: baseUrl,
                modelId: modelId,
                supportsChat: supportsChat,
                supportsVision: supportsVision,
                supportsFunctionCalling: supportsFunctionCalling,
                temperature: temperature,
                maxTokens: maxTokens,
                usage: usage,
                isChatDefault: isChatDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiModelConfigsTable, ModelConfigRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AiModelConfigsTable,
                    ModelConfigRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiModelConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiModelConfigsTable,
      ModelConfigRow,
      $$AiModelConfigsTableFilterComposer,
      $$AiModelConfigsTableOrderingComposer,
      $$AiModelConfigsTableAnnotationComposer,
      $$AiModelConfigsTableCreateCompanionBuilder,
      $$AiModelConfigsTableUpdateCompanionBuilder,
      (
        ModelConfigRow,
        BaseReferences<_$AppDatabase, $AiModelConfigsTable, ModelConfigRow>,
      ),
      ModelConfigRow,
      PrefetchHooks Function()
    >;
typedef $$MedicationDraftsTableCreateCompanionBuilder =
    MedicationDraftsCompanion Function({
      required String id,
      required String source,
      required String payloadJson,
      Value<String?> photoPath,
      required String status,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$MedicationDraftsTableUpdateCompanionBuilder =
    MedicationDraftsCompanion Function({
      Value<String> id,
      Value<String> source,
      Value<String> payloadJson,
      Value<String?> photoPath,
      Value<String> status,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$MedicationDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationDraftsTable> {
  $$MedicationDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationDraftsTable> {
  $$MedicationDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationDraftsTable> {
  $$MedicationDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MedicationDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationDraftsTable,
          DraftRow,
          $$MedicationDraftsTableFilterComposer,
          $$MedicationDraftsTableOrderingComposer,
          $$MedicationDraftsTableAnnotationComposer,
          $$MedicationDraftsTableCreateCompanionBuilder,
          $$MedicationDraftsTableUpdateCompanionBuilder,
          (
            DraftRow,
            BaseReferences<_$AppDatabase, $MedicationDraftsTable, DraftRow>,
          ),
          DraftRow,
          PrefetchHooks Function()
        > {
  $$MedicationDraftsTableTableManager(
    _$AppDatabase db,
    $MedicationDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationDraftsCompanion(
                id: id,
                source: source,
                payloadJson: payloadJson,
                photoPath: photoPath,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String source,
                required String payloadJson,
                Value<String?> photoPath = const Value.absent(),
                required String status,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationDraftsCompanion.insert(
                id: id,
                source: source,
                payloadJson: payloadJson,
                photoPath: photoPath,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationDraftsTable, DraftRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MedicationDraftsTable,
                    DraftRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationDraftsTable,
      DraftRow,
      $$MedicationDraftsTableFilterComposer,
      $$MedicationDraftsTableOrderingComposer,
      $$MedicationDraftsTableAnnotationComposer,
      $$MedicationDraftsTableCreateCompanionBuilder,
      $$MedicationDraftsTableUpdateCompanionBuilder,
      (
        DraftRow,
        BaseReferences<_$AppDatabase, $MedicationDraftsTable, DraftRow>,
      ),
      DraftRow,
      PrefetchHooks Function()
    >;
typedef $$AgentRecordsTableCreateCompanionBuilder =
    AgentRecordsCompanion Function({
      required String id,
      required String kind,
      required String payload,
      Value<int> rowid,
    });
typedef $$AgentRecordsTableUpdateCompanionBuilder =
    AgentRecordsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> payload,
      Value<int> rowid,
    });

class $$AgentRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AgentRecordsTable> {
  $$AgentRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AgentRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AgentRecordsTable> {
  $$AgentRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AgentRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgentRecordsTable> {
  $$AgentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$AgentRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AgentRecordsTable,
          AgentRecord,
          $$AgentRecordsTableFilterComposer,
          $$AgentRecordsTableOrderingComposer,
          $$AgentRecordsTableAnnotationComposer,
          $$AgentRecordsTableCreateCompanionBuilder,
          $$AgentRecordsTableUpdateCompanionBuilder,
          (
            AgentRecord,
            BaseReferences<_$AppDatabase, $AgentRecordsTable, AgentRecord>,
          ),
          AgentRecord,
          PrefetchHooks Function()
        > {
  $$AgentRecordsTableTableManager(_$AppDatabase db, $AgentRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AgentRecordsCompanion(
                id: id,
                kind: kind,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => AgentRecordsCompanion.insert(
                id: id,
                kind: kind,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AgentRecordsTable, AgentRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AgentRecordsTable,
                    AgentRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AgentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AgentRecordsTable,
      AgentRecord,
      $$AgentRecordsTableFilterComposer,
      $$AgentRecordsTableOrderingComposer,
      $$AgentRecordsTableAnnotationComposer,
      $$AgentRecordsTableCreateCompanionBuilder,
      $$AgentRecordsTableUpdateCompanionBuilder,
      (
        AgentRecord,
        BaseReferences<_$AppDatabase, $AgentRecordsTable, AgentRecord>,
      ),
      AgentRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationSchedulesTableTableManager get medicationSchedules =>
      $$MedicationSchedulesTableTableManager(_db, _db.medicationSchedules);
  $$DoseTasksTableTableManager get doseTasks =>
      $$DoseTasksTableTableManager(_db, _db.doseTasks);
  $$ChatSessionsTableTableManager get chatSessions =>
      $$ChatSessionsTableTableManager(_db, _db.chatSessions);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$AiModelConfigsTableTableManager get aiModelConfigs =>
      $$AiModelConfigsTableTableManager(_db, _db.aiModelConfigs);
  $$MedicationDraftsTableTableManager get medicationDrafts =>
      $$MedicationDraftsTableTableManager(_db, _db.medicationDrafts);
  $$AgentRecordsTableTableManager get agentRecords =>
      $$AgentRecordsTableTableManager(_db, _db.agentRecords);
}
