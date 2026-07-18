// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BirdsTable extends Birds with TableInfo<$BirdsTable, Bird> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BirdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
      'breed', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Unknown'));
  static const VerificationMeta _eggColorMeta =
      const VerificationMeta('eggColor');
  @override
  late final GeneratedColumn<String> eggColor = GeneratedColumn<String>(
      'egg_color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hatchDateMeta =
      const VerificationMeta('hatchDate');
  @override
  late final GeneratedColumn<DateTime> hatchDate = GeneratedColumn<DateTime>(
      'hatch_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('laying'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, breed, eggColor, hatchDate, status, notes, photoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'birds';
  @override
  VerificationContext validateIntegrity(Insertable<Bird> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('breed')) {
      context.handle(
          _breedMeta, breed.isAcceptableOrUnknown(data['breed']!, _breedMeta));
    }
    if (data.containsKey('egg_color')) {
      context.handle(_eggColorMeta,
          eggColor.isAcceptableOrUnknown(data['egg_color']!, _eggColorMeta));
    }
    if (data.containsKey('hatch_date')) {
      context.handle(_hatchDateMeta,
          hatchDate.isAcceptableOrUnknown(data['hatch_date']!, _hatchDateMeta));
    } else if (isInserting) {
      context.missing(_hatchDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bird map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bird(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      breed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed'])!,
      eggColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}egg_color']),
      hatchDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}hatch_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
    );
  }

  @override
  $BirdsTable createAlias(String alias) {
    return $BirdsTable(attachedDatabase, alias);
  }
}

class Bird extends DataClass implements Insertable<Bird> {
  final int id;
  final String breed;
  final String? eggColor;
  final DateTime hatchDate;
  final String status;
  final String? notes;
  final String? photoPath;
  const Bird(
      {required this.id,
      required this.breed,
      this.eggColor,
      required this.hatchDate,
      required this.status,
      this.notes,
      this.photoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['breed'] = Variable<String>(breed);
    if (!nullToAbsent || eggColor != null) {
      map['egg_color'] = Variable<String>(eggColor);
    }
    map['hatch_date'] = Variable<DateTime>(hatchDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  BirdsCompanion toCompanion(bool nullToAbsent) {
    return BirdsCompanion(
      id: Value(id),
      breed: Value(breed),
      eggColor: eggColor == null && nullToAbsent
          ? const Value.absent()
          : Value(eggColor),
      hatchDate: Value(hatchDate),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory Bird.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bird(
      id: serializer.fromJson<int>(json['id']),
      breed: serializer.fromJson<String>(json['breed']),
      eggColor: serializer.fromJson<String?>(json['eggColor']),
      hatchDate: serializer.fromJson<DateTime>(json['hatchDate']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'breed': serializer.toJson<String>(breed),
      'eggColor': serializer.toJson<String?>(eggColor),
      'hatchDate': serializer.toJson<DateTime>(hatchDate),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  Bird copyWith(
          {int? id,
          String? breed,
          Value<String?> eggColor = const Value.absent(),
          DateTime? hatchDate,
          String? status,
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent()}) =>
      Bird(
        id: id ?? this.id,
        breed: breed ?? this.breed,
        eggColor: eggColor.present ? eggColor.value : this.eggColor,
        hatchDate: hatchDate ?? this.hatchDate,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
      );
  Bird copyWithCompanion(BirdsCompanion data) {
    return Bird(
      id: data.id.present ? data.id.value : this.id,
      breed: data.breed.present ? data.breed.value : this.breed,
      eggColor: data.eggColor.present ? data.eggColor.value : this.eggColor,
      hatchDate: data.hatchDate.present ? data.hatchDate.value : this.hatchDate,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bird(')
          ..write('id: $id, ')
          ..write('breed: $breed, ')
          ..write('eggColor: $eggColor, ')
          ..write('hatchDate: $hatchDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, breed, eggColor, hatchDate, status, notes, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bird &&
          other.id == this.id &&
          other.breed == this.breed &&
          other.eggColor == this.eggColor &&
          other.hatchDate == this.hatchDate &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath);
}

class BirdsCompanion extends UpdateCompanion<Bird> {
  final Value<int> id;
  final Value<String> breed;
  final Value<String?> eggColor;
  final Value<DateTime> hatchDate;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String?> photoPath;
  const BirdsCompanion({
    this.id = const Value.absent(),
    this.breed = const Value.absent(),
    this.eggColor = const Value.absent(),
    this.hatchDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  BirdsCompanion.insert({
    this.id = const Value.absent(),
    this.breed = const Value.absent(),
    this.eggColor = const Value.absent(),
    required DateTime hatchDate,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
  }) : hatchDate = Value(hatchDate);
  static Insertable<Bird> custom({
    Expression<int>? id,
    Expression<String>? breed,
    Expression<String>? eggColor,
    Expression<DateTime>? hatchDate,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (breed != null) 'breed': breed,
      if (eggColor != null) 'egg_color': eggColor,
      if (hatchDate != null) 'hatch_date': hatchDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  BirdsCompanion copyWith(
      {Value<int>? id,
      Value<String>? breed,
      Value<String?>? eggColor,
      Value<DateTime>? hatchDate,
      Value<String>? status,
      Value<String?>? notes,
      Value<String?>? photoPath}) {
    return BirdsCompanion(
      id: id ?? this.id,
      breed: breed ?? this.breed,
      eggColor: eggColor ?? this.eggColor,
      hatchDate: hatchDate ?? this.hatchDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (eggColor.present) {
      map['egg_color'] = Variable<String>(eggColor.value);
    }
    if (hatchDate.present) {
      map['hatch_date'] = Variable<DateTime>(hatchDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BirdsCompanion(')
          ..write('id: $id, ')
          ..write('breed: $breed, ')
          ..write('eggColor: $eggColor, ')
          ..write('hatchDate: $hatchDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _layingHensMeta =
      const VerificationMeta('layingHens');
  @override
  late final GeneratedColumn<int> layingHens = GeneratedColumn<int>(
      'laying_hens', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _eggsBrownMeta =
      const VerificationMeta('eggsBrown');
  @override
  late final GeneratedColumn<int> eggsBrown = GeneratedColumn<int>(
      'eggs_brown', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _eggsColoredMeta =
      const VerificationMeta('eggsColored');
  @override
  late final GeneratedColumn<int> eggsColored = GeneratedColumn<int>(
      'eggs_colored', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _eggsWhiteMeta =
      const VerificationMeta('eggsWhite');
  @override
  late final GeneratedColumn<int> eggsWhite = GeneratedColumn<int>(
      'eggs_white', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, layingHens, eggsBrown, eggsColored, eggsWhite, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(Insertable<DailyLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('laying_hens')) {
      context.handle(
          _layingHensMeta,
          layingHens.isAcceptableOrUnknown(
              data['laying_hens']!, _layingHensMeta));
    }
    if (data.containsKey('eggs_brown')) {
      context.handle(_eggsBrownMeta,
          eggsBrown.isAcceptableOrUnknown(data['eggs_brown']!, _eggsBrownMeta));
    }
    if (data.containsKey('eggs_colored')) {
      context.handle(
          _eggsColoredMeta,
          eggsColored.isAcceptableOrUnknown(
              data['eggs_colored']!, _eggsColoredMeta));
    }
    if (data.containsKey('eggs_white')) {
      context.handle(_eggsWhiteMeta,
          eggsWhite.isAcceptableOrUnknown(data['eggs_white']!, _eggsWhiteMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      layingHens: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}laying_hens'])!,
      eggsBrown: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}eggs_brown'])!,
      eggsColored: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}eggs_colored'])!,
      eggsWhite: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}eggs_white'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final int id;
  final DateTime date;
  final int layingHens;
  final int eggsBrown;
  final int eggsColored;
  final int eggsWhite;
  final String? notes;
  const DailyLog(
      {required this.id,
      required this.date,
      required this.layingHens,
      required this.eggsBrown,
      required this.eggsColored,
      required this.eggsWhite,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['laying_hens'] = Variable<int>(layingHens);
    map['eggs_brown'] = Variable<int>(eggsBrown);
    map['eggs_colored'] = Variable<int>(eggsColored);
    map['eggs_white'] = Variable<int>(eggsWhite);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      date: Value(date),
      layingHens: Value(layingHens),
      eggsBrown: Value(eggsBrown),
      eggsColored: Value(eggsColored),
      eggsWhite: Value(eggsWhite),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory DailyLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      layingHens: serializer.fromJson<int>(json['layingHens']),
      eggsBrown: serializer.fromJson<int>(json['eggsBrown']),
      eggsColored: serializer.fromJson<int>(json['eggsColored']),
      eggsWhite: serializer.fromJson<int>(json['eggsWhite']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'layingHens': serializer.toJson<int>(layingHens),
      'eggsBrown': serializer.toJson<int>(eggsBrown),
      'eggsColored': serializer.toJson<int>(eggsColored),
      'eggsWhite': serializer.toJson<int>(eggsWhite),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DailyLog copyWith(
          {int? id,
          DateTime? date,
          int? layingHens,
          int? eggsBrown,
          int? eggsColored,
          int? eggsWhite,
          Value<String?> notes = const Value.absent()}) =>
      DailyLog(
        id: id ?? this.id,
        date: date ?? this.date,
        layingHens: layingHens ?? this.layingHens,
        eggsBrown: eggsBrown ?? this.eggsBrown,
        eggsColored: eggsColored ?? this.eggsColored,
        eggsWhite: eggsWhite ?? this.eggsWhite,
        notes: notes.present ? notes.value : this.notes,
      );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      layingHens:
          data.layingHens.present ? data.layingHens.value : this.layingHens,
      eggsBrown: data.eggsBrown.present ? data.eggsBrown.value : this.eggsBrown,
      eggsColored:
          data.eggsColored.present ? data.eggsColored.value : this.eggsColored,
      eggsWhite: data.eggsWhite.present ? data.eggsWhite.value : this.eggsWhite,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('layingHens: $layingHens, ')
          ..write('eggsBrown: $eggsBrown, ')
          ..write('eggsColored: $eggsColored, ')
          ..write('eggsWhite: $eggsWhite, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, date, layingHens, eggsBrown, eggsColored, eggsWhite, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.layingHens == this.layingHens &&
          other.eggsBrown == this.eggsBrown &&
          other.eggsColored == this.eggsColored &&
          other.eggsWhite == this.eggsWhite &&
          other.notes == this.notes);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> layingHens;
  final Value<int> eggsBrown;
  final Value<int> eggsColored;
  final Value<int> eggsWhite;
  final Value<String?> notes;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.layingHens = const Value.absent(),
    this.eggsBrown = const Value.absent(),
    this.eggsColored = const Value.absent(),
    this.eggsWhite = const Value.absent(),
    this.notes = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.layingHens = const Value.absent(),
    this.eggsBrown = const Value.absent(),
    this.eggsColored = const Value.absent(),
    this.eggsWhite = const Value.absent(),
    this.notes = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? layingHens,
    Expression<int>? eggsBrown,
    Expression<int>? eggsColored,
    Expression<int>? eggsWhite,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (layingHens != null) 'laying_hens': layingHens,
      if (eggsBrown != null) 'eggs_brown': eggsBrown,
      if (eggsColored != null) 'eggs_colored': eggsColored,
      if (eggsWhite != null) 'eggs_white': eggsWhite,
      if (notes != null) 'notes': notes,
    });
  }

  DailyLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? layingHens,
      Value<int>? eggsBrown,
      Value<int>? eggsColored,
      Value<int>? eggsWhite,
      Value<String?>? notes}) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      layingHens: layingHens ?? this.layingHens,
      eggsBrown: eggsBrown ?? this.eggsBrown,
      eggsColored: eggsColored ?? this.eggsColored,
      eggsWhite: eggsWhite ?? this.eggsWhite,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (layingHens.present) {
      map['laying_hens'] = Variable<int>(layingHens.value);
    }
    if (eggsBrown.present) {
      map['eggs_brown'] = Variable<int>(eggsBrown.value);
    }
    if (eggsColored.present) {
      map['eggs_colored'] = Variable<int>(eggsColored.value);
    }
    if (eggsWhite.present) {
      map['eggs_white'] = Variable<int>(eggsWhite.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('layingHens: $layingHens, ')
          ..write('eggsBrown: $eggsBrown, ')
          ..write('eggsColored: $eggsColored, ')
          ..write('eggsWhite: $eggsWhite, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dozens'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, type, quantity, unit, amount, customerName, isPaid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final DateTime date;
  final String type;
  final double quantity;
  final String unit;
  final double amount;
  final String? customerName;
  final bool isPaid;
  const Sale(
      {required this.id,
      required this.date,
      required this.type,
      required this.quantity,
      required this.unit,
      required this.amount,
      this.customerName,
      required this.isPaid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['is_paid'] = Variable<bool>(isPaid);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      quantity: Value(quantity),
      unit: Value(unit),
      amount: Value(amount),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      isPaid: Value(isPaid),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      amount: serializer.fromJson<double>(json['amount']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'amount': serializer.toJson<double>(amount),
      'customerName': serializer.toJson<String?>(customerName),
      'isPaid': serializer.toJson<bool>(isPaid),
    };
  }

  Sale copyWith(
          {int? id,
          DateTime? date,
          String? type,
          double? quantity,
          String? unit,
          double? amount,
          Value<String?> customerName = const Value.absent(),
          bool? isPaid}) =>
      Sale(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        amount: amount ?? this.amount,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        isPaid: isPaid ?? this.isPaid,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      amount: data.amount.present ? data.amount.value : this.amount,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('customerName: $customerName, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, type, quantity, unit, amount, customerName, isPaid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.amount == this.amount &&
          other.customerName == this.customerName &&
          other.isPaid == this.isPaid);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> amount;
  final Value<String?> customerName;
  final Value<bool> isPaid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.amount = const Value.absent(),
    this.customerName = const Value.absent(),
    this.isPaid = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    required double quantity,
    this.unit = const Value.absent(),
    required double amount,
    this.customerName = const Value.absent(),
    this.isPaid = const Value.absent(),
  })  : date = Value(date),
        type = Value(type),
        quantity = Value(quantity),
        amount = Value(amount);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? amount,
    Expression<String>? customerName,
    Expression<bool>? isPaid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (amount != null) 'amount': amount,
      if (customerName != null) 'customer_name': customerName,
      if (isPaid != null) 'is_paid': isPaid,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? type,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double>? amount,
      Value<String?>? customerName,
      Value<bool>? isPaid}) {
    return SalesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      amount: amount ?? this.amount,
      customerName: customerName ?? this.customerName,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('customerName: $customerName, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _poundsMeta = const VerificationMeta('pounds');
  @override
  late final GeneratedColumn<double> pounds = GeneratedColumn<double>(
      'pounds', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, category, amount, description, pounds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('pounds')) {
      context.handle(_poundsMeta,
          pounds.isAcceptableOrUnknown(data['pounds']!, _poundsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      pounds: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pounds']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime date;
  final String category;
  final double amount;
  final String? description;
  final double? pounds;
  const Expense(
      {required this.id,
      required this.date,
      required this.category,
      required this.amount,
      this.description,
      this.pounds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || pounds != null) {
      map['pounds'] = Variable<double>(pounds);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      pounds:
          pounds == null && nullToAbsent ? const Value.absent() : Value(pounds),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      pounds: serializer.fromJson<double?>(json['pounds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'pounds': serializer.toJson<double?>(pounds),
    };
  }

  Expense copyWith(
          {int? id,
          DateTime? date,
          String? category,
          double? amount,
          Value<String?> description = const Value.absent(),
          Value<double?> pounds = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        date: date ?? this.date,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        description: description.present ? description.value : this.description,
        pounds: pounds.present ? pounds.value : this.pounds,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      pounds: data.pounds.present ? data.pounds.value : this.pounds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('pounds: $pounds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, category, amount, description, pounds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.pounds == this.pounds);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> description;
  final Value<double?> pounds;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.pounds = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String category,
    required double amount,
    this.description = const Value.absent(),
    this.pounds = const Value.absent(),
  })  : date = Value(date),
        category = Value(category),
        amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<double>? pounds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (pounds != null) 'pounds': pounds,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? category,
      Value<double>? amount,
      Value<String?>? description,
      Value<double?>? pounds}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      pounds: pounds ?? this.pounds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (pounds.present) {
      map['pounds'] = Variable<double>(pounds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('pounds: $pounds')
          ..write(')'))
        .toString();
  }
}

class $FlockPurchasesTable extends FlockPurchases
    with TableInfo<$FlockPurchasesTable, FlockPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlockPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _supplierMeta =
      const VerificationMeta('supplier');
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
      'supplier', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hatchedCountMeta =
      const VerificationMeta('hatchedCount');
  @override
  late final GeneratedColumn<int> hatchedCount = GeneratedColumn<int>(
      'hatched_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, type, quantity, cost, supplier, hatchedCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flock_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<FlockPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('supplier')) {
      context.handle(_supplierMeta,
          supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta));
    }
    if (data.containsKey('hatched_count')) {
      context.handle(
          _hatchedCountMeta,
          hatchedCount.isAcceptableOrUnknown(
              data['hatched_count']!, _hatchedCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlockPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlockPurchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost'])!,
      supplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier']),
      hatchedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hatched_count']),
    );
  }

  @override
  $FlockPurchasesTable createAlias(String alias) {
    return $FlockPurchasesTable(attachedDatabase, alias);
  }
}

class FlockPurchase extends DataClass implements Insertable<FlockPurchase> {
  final int id;
  final DateTime date;
  final String type;
  final int quantity;
  final double cost;
  final String? supplier;
  final int? hatchedCount;
  const FlockPurchase(
      {required this.id,
      required this.date,
      required this.type,
      required this.quantity,
      required this.cost,
      this.supplier,
      this.hatchedCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['quantity'] = Variable<int>(quantity);
    map['cost'] = Variable<double>(cost);
    if (!nullToAbsent || supplier != null) {
      map['supplier'] = Variable<String>(supplier);
    }
    if (!nullToAbsent || hatchedCount != null) {
      map['hatched_count'] = Variable<int>(hatchedCount);
    }
    return map;
  }

  FlockPurchasesCompanion toCompanion(bool nullToAbsent) {
    return FlockPurchasesCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      quantity: Value(quantity),
      cost: Value(cost),
      supplier: supplier == null && nullToAbsent
          ? const Value.absent()
          : Value(supplier),
      hatchedCount: hatchedCount == null && nullToAbsent
          ? const Value.absent()
          : Value(hatchedCount),
    );
  }

  factory FlockPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlockPurchase(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      quantity: serializer.fromJson<int>(json['quantity']),
      cost: serializer.fromJson<double>(json['cost']),
      supplier: serializer.fromJson<String?>(json['supplier']),
      hatchedCount: serializer.fromJson<int?>(json['hatchedCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'quantity': serializer.toJson<int>(quantity),
      'cost': serializer.toJson<double>(cost),
      'supplier': serializer.toJson<String?>(supplier),
      'hatchedCount': serializer.toJson<int?>(hatchedCount),
    };
  }

  FlockPurchase copyWith(
          {int? id,
          DateTime? date,
          String? type,
          int? quantity,
          double? cost,
          Value<String?> supplier = const Value.absent(),
          Value<int?> hatchedCount = const Value.absent()}) =>
      FlockPurchase(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        quantity: quantity ?? this.quantity,
        cost: cost ?? this.cost,
        supplier: supplier.present ? supplier.value : this.supplier,
        hatchedCount:
            hatchedCount.present ? hatchedCount.value : this.hatchedCount,
      );
  FlockPurchase copyWithCompanion(FlockPurchasesCompanion data) {
    return FlockPurchase(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      cost: data.cost.present ? data.cost.value : this.cost,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      hatchedCount: data.hatchedCount.present
          ? data.hatchedCount.value
          : this.hatchedCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlockPurchase(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('cost: $cost, ')
          ..write('supplier: $supplier, ')
          ..write('hatchedCount: $hatchedCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, type, quantity, cost, supplier, hatchedCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlockPurchase &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.cost == this.cost &&
          other.supplier == this.supplier &&
          other.hatchedCount == this.hatchedCount);
}

class FlockPurchasesCompanion extends UpdateCompanion<FlockPurchase> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<int> quantity;
  final Value<double> cost;
  final Value<String?> supplier;
  final Value<int?> hatchedCount;
  const FlockPurchasesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.cost = const Value.absent(),
    this.supplier = const Value.absent(),
    this.hatchedCount = const Value.absent(),
  });
  FlockPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    required int quantity,
    required double cost,
    this.supplier = const Value.absent(),
    this.hatchedCount = const Value.absent(),
  })  : date = Value(date),
        type = Value(type),
        quantity = Value(quantity),
        cost = Value(cost);
  static Insertable<FlockPurchase> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? quantity,
    Expression<double>? cost,
    Expression<String>? supplier,
    Expression<int>? hatchedCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (cost != null) 'cost': cost,
      if (supplier != null) 'supplier': supplier,
      if (hatchedCount != null) 'hatched_count': hatchedCount,
    });
  }

  FlockPurchasesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? type,
      Value<int>? quantity,
      Value<double>? cost,
      Value<String?>? supplier,
      Value<int?>? hatchedCount}) {
    return FlockPurchasesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      cost: cost ?? this.cost,
      supplier: supplier ?? this.supplier,
      hatchedCount: hatchedCount ?? this.hatchedCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (hatchedCount.present) {
      map['hatched_count'] = Variable<int>(hatchedCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlockPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('cost: $cost, ')
          ..write('supplier: $supplier, ')
          ..write('hatchedCount: $hatchedCount')
          ..write(')'))
        .toString();
  }
}

class $FlockLossesTable extends FlockLosses
    with TableInfo<$FlockLossesTable, FlockLossesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlockLossesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _predatorSubtypeMeta =
      const VerificationMeta('predatorSubtype');
  @override
  late final GeneratedColumn<String> predatorSubtype = GeneratedColumn<String>(
      'predator_subtype', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, type, quantity, predatorSubtype];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flock_losses';
  @override
  VerificationContext validateIntegrity(Insertable<FlockLossesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('predator_subtype')) {
      context.handle(
          _predatorSubtypeMeta,
          predatorSubtype.isAcceptableOrUnknown(
              data['predator_subtype']!, _predatorSubtypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlockLossesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlockLossesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      predatorSubtype: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}predator_subtype']),
    );
  }

  @override
  $FlockLossesTable createAlias(String alias) {
    return $FlockLossesTable(attachedDatabase, alias);
  }
}

class FlockLossesData extends DataClass implements Insertable<FlockLossesData> {
  final int id;
  final DateTime date;
  final String type;
  final int quantity;
  final String? predatorSubtype;
  const FlockLossesData(
      {required this.id,
      required this.date,
      required this.type,
      required this.quantity,
      this.predatorSubtype});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || predatorSubtype != null) {
      map['predator_subtype'] = Variable<String>(predatorSubtype);
    }
    return map;
  }

  FlockLossesCompanion toCompanion(bool nullToAbsent) {
    return FlockLossesCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      quantity: Value(quantity),
      predatorSubtype: predatorSubtype == null && nullToAbsent
          ? const Value.absent()
          : Value(predatorSubtype),
    );
  }

  factory FlockLossesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlockLossesData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      quantity: serializer.fromJson<int>(json['quantity']),
      predatorSubtype: serializer.fromJson<String?>(json['predatorSubtype']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'quantity': serializer.toJson<int>(quantity),
      'predatorSubtype': serializer.toJson<String?>(predatorSubtype),
    };
  }

  FlockLossesData copyWith(
          {int? id,
          DateTime? date,
          String? type,
          int? quantity,
          Value<String?> predatorSubtype = const Value.absent()}) =>
      FlockLossesData(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        quantity: quantity ?? this.quantity,
        predatorSubtype: predatorSubtype.present
            ? predatorSubtype.value
            : this.predatorSubtype,
      );
  FlockLossesData copyWithCompanion(FlockLossesCompanion data) {
    return FlockLossesData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      predatorSubtype: data.predatorSubtype.present
          ? data.predatorSubtype.value
          : this.predatorSubtype,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlockLossesData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('predatorSubtype: $predatorSubtype')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, type, quantity, predatorSubtype);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlockLossesData &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.predatorSubtype == this.predatorSubtype);
}

class FlockLossesCompanion extends UpdateCompanion<FlockLossesData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<int> quantity;
  final Value<String?> predatorSubtype;
  const FlockLossesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.predatorSubtype = const Value.absent(),
  });
  FlockLossesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    required int quantity,
    this.predatorSubtype = const Value.absent(),
  })  : date = Value(date),
        type = Value(type),
        quantity = Value(quantity);
  static Insertable<FlockLossesData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? quantity,
    Expression<String>? predatorSubtype,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (predatorSubtype != null) 'predator_subtype': predatorSubtype,
    });
  }

  FlockLossesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? type,
      Value<int>? quantity,
      Value<String?>? predatorSubtype}) {
    return FlockLossesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      predatorSubtype: predatorSubtype ?? this.predatorSubtype,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (predatorSubtype.present) {
      map['predator_subtype'] = Variable<String>(predatorSubtype.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlockLossesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('predatorSubtype: $predatorSubtype')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('USD'));
  static const VerificationMeta _weightUnitMeta =
      const VerificationMeta('weightUnit');
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
      'weight_unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('lbs'));
  static const VerificationMeta _darkModeMeta =
      const VerificationMeta('darkMode');
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
      'dark_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dark_mode" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, currency, weightUnit, darkMode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
          _weightUnitMeta,
          weightUnit.isAcceptableOrUnknown(
              data['weight_unit']!, _weightUnitMeta));
    }
    if (data.containsKey('dark_mode')) {
      context.handle(_darkModeMeta,
          darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      weightUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weight_unit'])!,
      darkMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dark_mode'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String currency;
  final String weightUnit;
  final bool darkMode;
  const Setting(
      {required this.id,
      required this.currency,
      required this.weightUnit,
      required this.darkMode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency'] = Variable<String>(currency);
    map['weight_unit'] = Variable<String>(weightUnit);
    map['dark_mode'] = Variable<bool>(darkMode);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      currency: Value(currency),
      weightUnit: Value(weightUnit),
      darkMode: Value(darkMode),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      currency: serializer.fromJson<String>(json['currency']),
      weightUnit: serializer.fromJson<String>(json['weightUnit']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currency': serializer.toJson<String>(currency),
      'weightUnit': serializer.toJson<String>(weightUnit),
      'darkMode': serializer.toJson<bool>(darkMode),
    };
  }

  Setting copyWith(
          {int? id, String? currency, String? weightUnit, bool? darkMode}) =>
      Setting(
        id: id ?? this.id,
        currency: currency ?? this.currency,
        weightUnit: weightUnit ?? this.weightUnit,
        darkMode: darkMode ?? this.darkMode,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      currency: data.currency.present ? data.currency.value : this.currency,
      weightUnit:
          data.weightUnit.present ? data.weightUnit.value : this.weightUnit,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currency, weightUnit, darkMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.currency == this.currency &&
          other.weightUnit == this.weightUnit &&
          other.darkMode == this.darkMode);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> currency;
  final Value<String> weightUnit;
  final Value<bool> darkMode;
  final Value<int> rowid;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.currency = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.currency = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? currency,
    Expression<String>? weightUnit,
    Expression<bool>? darkMode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currency != null) 'currency': currency,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (darkMode != null) 'dark_mode': darkMode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? currency,
      Value<String>? weightUnit,
      Value<bool>? darkMode,
      Value<int>? rowid}) {
    return SettingsCompanion(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      weightUnit: weightUnit ?? this.weightUnit,
      darkMode: darkMode ?? this.darkMode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('darkMode: $darkMode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequencyDaysMeta =
      const VerificationMeta('frequencyDays');
  @override
  late final GeneratedColumn<int> frequencyDays = GeneratedColumn<int>(
      'frequency_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastCompletedDateMeta =
      const VerificationMeta('lastCompletedDate');
  @override
  late final GeneratedColumn<DateTime> lastCompletedDate =
      GeneratedColumn<DateTime>('last_completed_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notifyOnAndroidMeta =
      const VerificationMeta('notifyOnAndroid');
  @override
  late final GeneratedColumn<bool> notifyOnAndroid = GeneratedColumn<bool>(
      'notify_on_android', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notify_on_android" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        title,
        frequencyDays,
        nextDueDate,
        lastCompletedDate,
        notes,
        isActive,
        notifyOnAndroid
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('frequency_days')) {
      context.handle(
          _frequencyDaysMeta,
          frequencyDays.isAcceptableOrUnknown(
              data['frequency_days']!, _frequencyDaysMeta));
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('last_completed_date')) {
      context.handle(
          _lastCompletedDateMeta,
          lastCompletedDate.isAcceptableOrUnknown(
              data['last_completed_date']!, _lastCompletedDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('notify_on_android')) {
      context.handle(
          _notifyOnAndroidMeta,
          notifyOnAndroid.isAcceptableOrUnknown(
              data['notify_on_android']!, _notifyOnAndroidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      frequencyDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency_days'])!,
      nextDueDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_due_date'])!,
      lastCompletedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_completed_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      notifyOnAndroid: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notify_on_android'])!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final String type;
  final String title;
  final int frequencyDays;
  final DateTime nextDueDate;
  final DateTime? lastCompletedDate;
  final String? notes;
  final bool isActive;
  final bool notifyOnAndroid;
  const Reminder(
      {required this.id,
      required this.type,
      required this.title,
      required this.frequencyDays,
      required this.nextDueDate,
      this.lastCompletedDate,
      this.notes,
      required this.isActive,
      required this.notifyOnAndroid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['frequency_days'] = Variable<int>(frequencyDays);
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    if (!nullToAbsent || lastCompletedDate != null) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['notify_on_android'] = Variable<bool>(notifyOnAndroid);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      frequencyDays: Value(frequencyDays),
      nextDueDate: Value(nextDueDate),
      lastCompletedDate: lastCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      notifyOnAndroid: Value(notifyOnAndroid),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      frequencyDays: serializer.fromJson<int>(json['frequencyDays']),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      lastCompletedDate:
          serializer.fromJson<DateTime?>(json['lastCompletedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notifyOnAndroid: serializer.fromJson<bool>(json['notifyOnAndroid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'frequencyDays': serializer.toJson<int>(frequencyDays),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'lastCompletedDate': serializer.toJson<DateTime?>(lastCompletedDate),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'notifyOnAndroid': serializer.toJson<bool>(notifyOnAndroid),
    };
  }

  Reminder copyWith(
          {int? id,
          String? type,
          String? title,
          int? frequencyDays,
          DateTime? nextDueDate,
          Value<DateTime?> lastCompletedDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          bool? notifyOnAndroid}) =>
      Reminder(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        frequencyDays: frequencyDays ?? this.frequencyDays,
        nextDueDate: nextDueDate ?? this.nextDueDate,
        lastCompletedDate: lastCompletedDate.present
            ? lastCompletedDate.value
            : this.lastCompletedDate,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        notifyOnAndroid: notifyOnAndroid ?? this.notifyOnAndroid,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      frequencyDays: data.frequencyDays.present
          ? data.frequencyDays.value
          : this.frequencyDays,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      lastCompletedDate: data.lastCompletedDate.present
          ? data.lastCompletedDate.value
          : this.lastCompletedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notifyOnAndroid: data.notifyOnAndroid.present
          ? data.notifyOnAndroid.value
          : this.notifyOnAndroid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('notifyOnAndroid: $notifyOnAndroid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, title, frequencyDays, nextDueDate,
      lastCompletedDate, notes, isActive, notifyOnAndroid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.frequencyDays == this.frequencyDays &&
          other.nextDueDate == this.nextDueDate &&
          other.lastCompletedDate == this.lastCompletedDate &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.notifyOnAndroid == this.notifyOnAndroid);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> title;
  final Value<int> frequencyDays;
  final Value<DateTime> nextDueDate;
  final Value<DateTime?> lastCompletedDate;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<bool> notifyOnAndroid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.frequencyDays = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notifyOnAndroid = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    this.frequencyDays = const Value.absent(),
    required DateTime nextDueDate,
    this.lastCompletedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notifyOnAndroid = const Value.absent(),
  })  : type = Value(type),
        title = Value(title),
        nextDueDate = Value(nextDueDate);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<int>? frequencyDays,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? lastCompletedDate,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<bool>? notifyOnAndroid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (frequencyDays != null) 'frequency_days': frequencyDays,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (lastCompletedDate != null) 'last_completed_date': lastCompletedDate,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (notifyOnAndroid != null) 'notify_on_android': notifyOnAndroid,
    });
  }

  RemindersCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? title,
      Value<int>? frequencyDays,
      Value<DateTime>? nextDueDate,
      Value<DateTime?>? lastCompletedDate,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<bool>? notifyOnAndroid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      notifyOnAndroid: notifyOnAndroid ?? this.notifyOnAndroid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (frequencyDays.present) {
      map['frequency_days'] = Variable<int>(frequencyDays.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (lastCompletedDate.present) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notifyOnAndroid.present) {
      map['notify_on_android'] = Variable<bool>(notifyOnAndroid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('notifyOnAndroid: $notifyOnAndroid')
          ..write(')'))
        .toString();
  }
}

class $SavedGuidesTable extends SavedGuides
    with TableInfo<$SavedGuidesTable, SavedGuide> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedGuidesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guideIdMeta =
      const VerificationMeta('guideId');
  @override
  late final GeneratedColumn<String> guideId = GeneratedColumn<String>(
      'guide_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [guideId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_guides';
  @override
  VerificationContext validateIntegrity(Insertable<SavedGuide> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guide_id')) {
      context.handle(_guideIdMeta,
          guideId.isAcceptableOrUnknown(data['guide_id']!, _guideIdMeta));
    } else if (isInserting) {
      context.missing(_guideIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guideId};
  @override
  SavedGuide map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedGuide(
      guideId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guide_id'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $SavedGuidesTable createAlias(String alias) {
    return $SavedGuidesTable(attachedDatabase, alias);
  }
}

class SavedGuide extends DataClass implements Insertable<SavedGuide> {
  final String guideId;
  final DateTime savedAt;
  const SavedGuide({required this.guideId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guide_id'] = Variable<String>(guideId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedGuidesCompanion toCompanion(bool nullToAbsent) {
    return SavedGuidesCompanion(
      guideId: Value(guideId),
      savedAt: Value(savedAt),
    );
  }

  factory SavedGuide.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedGuide(
      guideId: serializer.fromJson<String>(json['guideId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guideId': serializer.toJson<String>(guideId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedGuide copyWith({String? guideId, DateTime? savedAt}) => SavedGuide(
        guideId: guideId ?? this.guideId,
        savedAt: savedAt ?? this.savedAt,
      );
  SavedGuide copyWithCompanion(SavedGuidesCompanion data) {
    return SavedGuide(
      guideId: data.guideId.present ? data.guideId.value : this.guideId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedGuide(')
          ..write('guideId: $guideId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(guideId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedGuide &&
          other.guideId == this.guideId &&
          other.savedAt == this.savedAt);
}

class SavedGuidesCompanion extends UpdateCompanion<SavedGuide> {
  final Value<String> guideId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const SavedGuidesCompanion({
    this.guideId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedGuidesCompanion.insert({
    required String guideId,
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  })  : guideId = Value(guideId),
        savedAt = Value(savedAt);
  static Insertable<SavedGuide> custom({
    Expression<String>? guideId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guideId != null) 'guide_id': guideId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedGuidesCompanion copyWith(
      {Value<String>? guideId, Value<DateTime>? savedAt, Value<int>? rowid}) {
    return SavedGuidesCompanion(
      guideId: guideId ?? this.guideId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guideId.present) {
      map['guide_id'] = Variable<String>(guideId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedGuidesCompanion(')
          ..write('guideId: $guideId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadGuidesTable extends ReadGuides
    with TableInfo<$ReadGuidesTable, ReadGuide> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadGuidesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guideIdMeta =
      const VerificationMeta('guideId');
  @override
  late final GeneratedColumn<String> guideId = GeneratedColumn<String>(
      'guide_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressPercentMeta =
      const VerificationMeta('progressPercent');
  @override
  late final GeneratedColumn<int> progressPercent = GeneratedColumn<int>(
      'progress_percent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastReadAtMeta =
      const VerificationMeta('lastReadAt');
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
      'last_read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [guideId, progressPercent, completed, lastReadAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'read_guides';
  @override
  VerificationContext validateIntegrity(Insertable<ReadGuide> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guide_id')) {
      context.handle(_guideIdMeta,
          guideId.isAcceptableOrUnknown(data['guide_id']!, _guideIdMeta));
    } else if (isInserting) {
      context.missing(_guideIdMeta);
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
          _progressPercentMeta,
          progressPercent.isAcceptableOrUnknown(
              data['progress_percent']!, _progressPercentMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
          _lastReadAtMeta,
          lastReadAt.isAcceptableOrUnknown(
              data['last_read_at']!, _lastReadAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guideId};
  @override
  ReadGuide map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadGuide(
      guideId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guide_id'])!,
      progressPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress_percent'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      lastReadAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read_at']),
    );
  }

  @override
  $ReadGuidesTable createAlias(String alias) {
    return $ReadGuidesTable(attachedDatabase, alias);
  }
}

class ReadGuide extends DataClass implements Insertable<ReadGuide> {
  final String guideId;
  final int progressPercent;
  final bool completed;
  final DateTime? lastReadAt;
  const ReadGuide(
      {required this.guideId,
      required this.progressPercent,
      required this.completed,
      this.lastReadAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guide_id'] = Variable<String>(guideId);
    map['progress_percent'] = Variable<int>(progressPercent);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    return map;
  }

  ReadGuidesCompanion toCompanion(bool nullToAbsent) {
    return ReadGuidesCompanion(
      guideId: Value(guideId),
      progressPercent: Value(progressPercent),
      completed: Value(completed),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
    );
  }

  factory ReadGuide.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadGuide(
      guideId: serializer.fromJson<String>(json['guideId']),
      progressPercent: serializer.fromJson<int>(json['progressPercent']),
      completed: serializer.fromJson<bool>(json['completed']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guideId': serializer.toJson<String>(guideId),
      'progressPercent': serializer.toJson<int>(progressPercent),
      'completed': serializer.toJson<bool>(completed),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
    };
  }

  ReadGuide copyWith(
          {String? guideId,
          int? progressPercent,
          bool? completed,
          Value<DateTime?> lastReadAt = const Value.absent()}) =>
      ReadGuide(
        guideId: guideId ?? this.guideId,
        progressPercent: progressPercent ?? this.progressPercent,
        completed: completed ?? this.completed,
        lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
      );
  ReadGuide copyWithCompanion(ReadGuidesCompanion data) {
    return ReadGuide(
      guideId: data.guideId.present ? data.guideId.value : this.guideId,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      completed: data.completed.present ? data.completed.value : this.completed,
      lastReadAt:
          data.lastReadAt.present ? data.lastReadAt.value : this.lastReadAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadGuide(')
          ..write('guideId: $guideId, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('completed: $completed, ')
          ..write('lastReadAt: $lastReadAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(guideId, progressPercent, completed, lastReadAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadGuide &&
          other.guideId == this.guideId &&
          other.progressPercent == this.progressPercent &&
          other.completed == this.completed &&
          other.lastReadAt == this.lastReadAt);
}

class ReadGuidesCompanion extends UpdateCompanion<ReadGuide> {
  final Value<String> guideId;
  final Value<int> progressPercent;
  final Value<bool> completed;
  final Value<DateTime?> lastReadAt;
  final Value<int> rowid;
  const ReadGuidesCompanion({
    this.guideId = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.completed = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadGuidesCompanion.insert({
    required String guideId,
    this.progressPercent = const Value.absent(),
    this.completed = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : guideId = Value(guideId);
  static Insertable<ReadGuide> custom({
    Expression<String>? guideId,
    Expression<int>? progressPercent,
    Expression<bool>? completed,
    Expression<DateTime>? lastReadAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guideId != null) 'guide_id': guideId,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (completed != null) 'completed': completed,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadGuidesCompanion copyWith(
      {Value<String>? guideId,
      Value<int>? progressPercent,
      Value<bool>? completed,
      Value<DateTime?>? lastReadAt,
      Value<int>? rowid}) {
    return ReadGuidesCompanion(
      guideId: guideId ?? this.guideId,
      progressPercent: progressPercent ?? this.progressPercent,
      completed: completed ?? this.completed,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guideId.present) {
      map['guide_id'] = Variable<String>(guideId.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<int>(progressPercent.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadGuidesCompanion(')
          ..write('guideId: $guideId, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('completed: $completed, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareLogsTable extends CareLogs with TableInfo<$CareLogsTable, CareLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Care Note'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, title, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_logs';
  @override
  VerificationContext validateIntegrity(Insertable<CareLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CareLogsTable createAlias(String alias) {
    return $CareLogsTable(attachedDatabase, alias);
  }
}

class CareLog extends DataClass implements Insertable<CareLog> {
  final int id;
  final DateTime date;
  final String title;
  final String? notes;
  final DateTime createdAt;
  const CareLog(
      {required this.id,
      required this.date,
      required this.title,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CareLogsCompanion toCompanion(bool nullToAbsent) {
    return CareLogsCompanion(
      id: Value(id),
      date: Value(date),
      title: Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory CareLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CareLog copyWith(
          {int? id,
          DateTime? date,
          String? title,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      CareLog(
        id: id ?? this.id,
        date: date ?? this.date,
        title: title ?? this.title,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  CareLog copyWithCompanion(CareLogsCompanion data) {
    return CareLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, title, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CareLogsCompanion extends UpdateCompanion<CareLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> title;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const CareLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CareLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  })  : date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<CareLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CareLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? title,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return CareLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CareLogPhotosTable extends CareLogPhotos
    with TableInfo<$CareLogPhotosTable, CareLogPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareLogPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _careLogIdMeta =
      const VerificationMeta('careLogId');
  @override
  late final GeneratedColumn<int> careLogId = GeneratedColumn<int>(
      'care_log_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES care_logs (id) ON DELETE CASCADE'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _galleryUriMeta =
      const VerificationMeta('galleryUri');
  @override
  late final GeneratedColumn<String> galleryUri = GeneratedColumn<String>(
      'gallery_uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _captionMeta =
      const VerificationMeta('caption');
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
      'caption', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, careLogId, filePath, galleryUri, caption, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_log_photos';
  @override
  VerificationContext validateIntegrity(Insertable<CareLogPhoto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('care_log_id')) {
      context.handle(
          _careLogIdMeta,
          careLogId.isAcceptableOrUnknown(
              data['care_log_id']!, _careLogIdMeta));
    } else if (isInserting) {
      context.missing(_careLogIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('gallery_uri')) {
      context.handle(
          _galleryUriMeta,
          galleryUri.isAcceptableOrUnknown(
              data['gallery_uri']!, _galleryUriMeta));
    }
    if (data.containsKey('caption')) {
      context.handle(_captionMeta,
          caption.isAcceptableOrUnknown(data['caption']!, _captionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareLogPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareLogPhoto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      careLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}care_log_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      galleryUri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gallery_uri']),
      caption: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caption']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CareLogPhotosTable createAlias(String alias) {
    return $CareLogPhotosTable(attachedDatabase, alias);
  }
}

class CareLogPhoto extends DataClass implements Insertable<CareLogPhoto> {
  final int id;
  final int careLogId;
  final String filePath;
  final String? galleryUri;
  final String? caption;
  final DateTime createdAt;
  const CareLogPhoto(
      {required this.id,
      required this.careLogId,
      required this.filePath,
      this.galleryUri,
      this.caption,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['care_log_id'] = Variable<int>(careLogId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || galleryUri != null) {
      map['gallery_uri'] = Variable<String>(galleryUri);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CareLogPhotosCompanion toCompanion(bool nullToAbsent) {
    return CareLogPhotosCompanion(
      id: Value(id),
      careLogId: Value(careLogId),
      filePath: Value(filePath),
      galleryUri: galleryUri == null && nullToAbsent
          ? const Value.absent()
          : Value(galleryUri),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      createdAt: Value(createdAt),
    );
  }

  factory CareLogPhoto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareLogPhoto(
      id: serializer.fromJson<int>(json['id']),
      careLogId: serializer.fromJson<int>(json['careLogId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      galleryUri: serializer.fromJson<String?>(json['galleryUri']),
      caption: serializer.fromJson<String?>(json['caption']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careLogId': serializer.toJson<int>(careLogId),
      'filePath': serializer.toJson<String>(filePath),
      'galleryUri': serializer.toJson<String?>(galleryUri),
      'caption': serializer.toJson<String?>(caption),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CareLogPhoto copyWith(
          {int? id,
          int? careLogId,
          String? filePath,
          Value<String?> galleryUri = const Value.absent(),
          Value<String?> caption = const Value.absent(),
          DateTime? createdAt}) =>
      CareLogPhoto(
        id: id ?? this.id,
        careLogId: careLogId ?? this.careLogId,
        filePath: filePath ?? this.filePath,
        galleryUri: galleryUri.present ? galleryUri.value : this.galleryUri,
        caption: caption.present ? caption.value : this.caption,
        createdAt: createdAt ?? this.createdAt,
      );
  CareLogPhoto copyWithCompanion(CareLogPhotosCompanion data) {
    return CareLogPhoto(
      id: data.id.present ? data.id.value : this.id,
      careLogId: data.careLogId.present ? data.careLogId.value : this.careLogId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      galleryUri:
          data.galleryUri.present ? data.galleryUri.value : this.galleryUri,
      caption: data.caption.present ? data.caption.value : this.caption,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareLogPhoto(')
          ..write('id: $id, ')
          ..write('careLogId: $careLogId, ')
          ..write('filePath: $filePath, ')
          ..write('galleryUri: $galleryUri, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, careLogId, filePath, galleryUri, caption, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareLogPhoto &&
          other.id == this.id &&
          other.careLogId == this.careLogId &&
          other.filePath == this.filePath &&
          other.galleryUri == this.galleryUri &&
          other.caption == this.caption &&
          other.createdAt == this.createdAt);
}

class CareLogPhotosCompanion extends UpdateCompanion<CareLogPhoto> {
  final Value<int> id;
  final Value<int> careLogId;
  final Value<String> filePath;
  final Value<String?> galleryUri;
  final Value<String?> caption;
  final Value<DateTime> createdAt;
  const CareLogPhotosCompanion({
    this.id = const Value.absent(),
    this.careLogId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.galleryUri = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CareLogPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int careLogId,
    required String filePath,
    this.galleryUri = const Value.absent(),
    this.caption = const Value.absent(),
    required DateTime createdAt,
  })  : careLogId = Value(careLogId),
        filePath = Value(filePath),
        createdAt = Value(createdAt);
  static Insertable<CareLogPhoto> custom({
    Expression<int>? id,
    Expression<int>? careLogId,
    Expression<String>? filePath,
    Expression<String>? galleryUri,
    Expression<String>? caption,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careLogId != null) 'care_log_id': careLogId,
      if (filePath != null) 'file_path': filePath,
      if (galleryUri != null) 'gallery_uri': galleryUri,
      if (caption != null) 'caption': caption,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CareLogPhotosCompanion copyWith(
      {Value<int>? id,
      Value<int>? careLogId,
      Value<String>? filePath,
      Value<String?>? galleryUri,
      Value<String?>? caption,
      Value<DateTime>? createdAt}) {
    return CareLogPhotosCompanion(
      id: id ?? this.id,
      careLogId: careLogId ?? this.careLogId,
      filePath: filePath ?? this.filePath,
      galleryUri: galleryUri ?? this.galleryUri,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careLogId.present) {
      map['care_log_id'] = Variable<int>(careLogId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (galleryUri.present) {
      map['gallery_uri'] = Variable<String>(galleryUri.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareLogPhotosCompanion(')
          ..write('id: $id, ')
          ..write('careLogId: $careLogId, ')
          ..write('filePath: $filePath, ')
          ..write('galleryUri: $galleryUri, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastOrderDateMeta =
      const VerificationMeta('lastOrderDate');
  @override
  late final GeneratedColumn<DateTime> lastOrderDate =
      GeneratedColumn<DateTime>('last_order_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalSpentMeta =
      const VerificationMeta('totalSpent');
  @override
  late final GeneratedColumn<double> totalSpent = GeneratedColumn<double>(
      'total_spent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _unpaidBalanceMeta =
      const VerificationMeta('unpaidBalance');
  @override
  late final GeneratedColumn<double> unpaidBalance = GeneratedColumn<double>(
      'unpaid_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        notes,
        createdAt,
        lastOrderDate,
        totalSpent,
        unpaidBalance
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_order_date')) {
      context.handle(
          _lastOrderDateMeta,
          lastOrderDate.isAcceptableOrUnknown(
              data['last_order_date']!, _lastOrderDateMeta));
    }
    if (data.containsKey('total_spent')) {
      context.handle(
          _totalSpentMeta,
          totalSpent.isAcceptableOrUnknown(
              data['total_spent']!, _totalSpentMeta));
    }
    if (data.containsKey('unpaid_balance')) {
      context.handle(
          _unpaidBalanceMeta,
          unpaidBalance.isAcceptableOrUnknown(
              data['unpaid_balance']!, _unpaidBalanceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastOrderDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_order_date']),
      totalSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_spent'])!,
      unpaidBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unpaid_balance'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime? lastOrderDate;
  final double totalSpent;
  final double unpaidBalance;
  const Customer(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.createdAt,
      this.lastOrderDate,
      required this.totalSpent,
      required this.unpaidBalance});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastOrderDate != null) {
      map['last_order_date'] = Variable<DateTime>(lastOrderDate);
    }
    map['total_spent'] = Variable<double>(totalSpent);
    map['unpaid_balance'] = Variable<double>(unpaidBalance);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      lastOrderDate: lastOrderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOrderDate),
      totalSpent: Value(totalSpent),
      unpaidBalance: Value(unpaidBalance),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastOrderDate: serializer.fromJson<DateTime?>(json['lastOrderDate']),
      totalSpent: serializer.fromJson<double>(json['totalSpent']),
      unpaidBalance: serializer.fromJson<double>(json['unpaidBalance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastOrderDate': serializer.toJson<DateTime?>(lastOrderDate),
      'totalSpent': serializer.toJson<double>(totalSpent),
      'unpaidBalance': serializer.toJson<double>(unpaidBalance),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> lastOrderDate = const Value.absent(),
          double? totalSpent,
          double? unpaidBalance}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        lastOrderDate:
            lastOrderDate.present ? lastOrderDate.value : this.lastOrderDate,
        totalSpent: totalSpent ?? this.totalSpent,
        unpaidBalance: unpaidBalance ?? this.unpaidBalance,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastOrderDate: data.lastOrderDate.present
          ? data.lastOrderDate.value
          : this.lastOrderDate,
      totalSpent:
          data.totalSpent.present ? data.totalSpent.value : this.totalSpent,
      unpaidBalance: data.unpaidBalance.present
          ? data.unpaidBalance.value
          : this.unpaidBalance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastOrderDate: $lastOrderDate, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('unpaidBalance: $unpaidBalance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, address, notes,
      createdAt, lastOrderDate, totalSpent, unpaidBalance);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.lastOrderDate == this.lastOrderDate &&
          other.totalSpent == this.totalSpent &&
          other.unpaidBalance == this.unpaidBalance);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastOrderDate;
  final Value<double> totalSpent;
  final Value<double> unpaidBalance;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastOrderDate = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.unpaidBalance = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.lastOrderDate = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.unpaidBalance = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastOrderDate,
    Expression<double>? totalSpent,
    Expression<double>? unpaidBalance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (lastOrderDate != null) 'last_order_date': lastOrderDate,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (unpaidBalance != null) 'unpaid_balance': unpaidBalance,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastOrderDate,
      Value<double>? totalSpent,
      Value<double>? unpaidBalance}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      totalSpent: totalSpent ?? this.totalSpent,
      unpaidBalance: unpaidBalance ?? this.unpaidBalance,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastOrderDate.present) {
      map['last_order_date'] = Variable<DateTime>(lastOrderDate.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<double>(totalSpent.value);
    }
    if (unpaidBalance.present) {
      map['unpaid_balance'] = Variable<double>(unpaidBalance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastOrderDate: $lastOrderDate, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('unpaidBalance: $unpaidBalance')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES customers (id) ON DELETE SET NULL'));
  static const VerificationMeta _orderDateMeta =
      const VerificationMeta('orderDate');
  @override
  late final GeneratedColumn<DateTime> orderDate = GeneratedColumn<DateTime>(
      'order_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deliveryDateMeta =
      const VerificationMeta('deliveryDate');
  @override
  late final GeneratedColumn<DateTime> deliveryDate = GeneratedColumn<DateTime>(
      'delivery_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('confirmed'));
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeliveredMeta =
      const VerificationMeta('isDelivered');
  @override
  late final GeneratedColumn<bool> isDelivered = GeneratedColumn<bool>(
      'is_delivered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_delivered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerId,
        orderDate,
        deliveryDate,
        status,
        isPaid,
        isDelivered,
        invoiceNumber,
        notes,
        subtotal,
        totalAmount,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('order_date')) {
      context.handle(_orderDateMeta,
          orderDate.isAcceptableOrUnknown(data['order_date']!, _orderDateMeta));
    } else if (isInserting) {
      context.missing(_orderDateMeta);
    }
    if (data.containsKey('delivery_date')) {
      context.handle(
          _deliveryDateMeta,
          deliveryDate.isAcceptableOrUnknown(
              data['delivery_date']!, _deliveryDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('is_delivered')) {
      context.handle(
          _isDeliveredMeta,
          isDelivered.isAcceptableOrUnknown(
              data['is_delivered']!, _isDeliveredMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      orderDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}order_date'])!,
      deliveryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delivery_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      isDelivered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_delivered'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final int? customerId;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String status;
  final bool isPaid;
  final bool isDelivered;
  final String? invoiceNumber;
  final String? notes;
  final double subtotal;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Order(
      {required this.id,
      this.customerId,
      required this.orderDate,
      this.deliveryDate,
      required this.status,
      required this.isPaid,
      required this.isDelivered,
      this.invoiceNumber,
      this.notes,
      required this.subtotal,
      required this.totalAmount,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['order_date'] = Variable<DateTime>(orderDate);
    if (!nullToAbsent || deliveryDate != null) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate);
    }
    map['status'] = Variable<String>(status);
    map['is_paid'] = Variable<bool>(isPaid);
    map['is_delivered'] = Variable<bool>(isDelivered);
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['total_amount'] = Variable<double>(totalAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      orderDate: Value(orderDate),
      deliveryDate: deliveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryDate),
      status: Value(status),
      isPaid: Value(isPaid),
      isDelivered: Value(isDelivered),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      subtotal: Value(subtotal),
      totalAmount: Value(totalAmount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      orderDate: serializer.fromJson<DateTime>(json['orderDate']),
      deliveryDate: serializer.fromJson<DateTime?>(json['deliveryDate']),
      status: serializer.fromJson<String>(json['status']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      isDelivered: serializer.fromJson<bool>(json['isDelivered']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int?>(customerId),
      'orderDate': serializer.toJson<DateTime>(orderDate),
      'deliveryDate': serializer.toJson<DateTime?>(deliveryDate),
      'status': serializer.toJson<String>(status),
      'isPaid': serializer.toJson<bool>(isPaid),
      'isDelivered': serializer.toJson<bool>(isDelivered),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'notes': serializer.toJson<String?>(notes),
      'subtotal': serializer.toJson<double>(subtotal),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Order copyWith(
          {int? id,
          Value<int?> customerId = const Value.absent(),
          DateTime? orderDate,
          Value<DateTime?> deliveryDate = const Value.absent(),
          String? status,
          bool? isPaid,
          bool? isDelivered,
          Value<String?> invoiceNumber = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          double? subtotal,
          double? totalAmount,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Order(
        id: id ?? this.id,
        customerId: customerId.present ? customerId.value : this.customerId,
        orderDate: orderDate ?? this.orderDate,
        deliveryDate:
            deliveryDate.present ? deliveryDate.value : this.deliveryDate,
        status: status ?? this.status,
        isPaid: isPaid ?? this.isPaid,
        isDelivered: isDelivered ?? this.isDelivered,
        invoiceNumber:
            invoiceNumber.present ? invoiceNumber.value : this.invoiceNumber,
        notes: notes.present ? notes.value : this.notes,
        subtotal: subtotal ?? this.subtotal,
        totalAmount: totalAmount ?? this.totalAmount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      orderDate: data.orderDate.present ? data.orderDate.value : this.orderDate,
      deliveryDate: data.deliveryDate.present
          ? data.deliveryDate.value
          : this.deliveryDate,
      status: data.status.present ? data.status.value : this.status,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      isDelivered:
          data.isDelivered.present ? data.isDelivered.value : this.isDelivered,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('orderDate: $orderDate, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('status: $status, ')
          ..write('isPaid: $isPaid, ')
          ..write('isDelivered: $isDelivered, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('notes: $notes, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      customerId,
      orderDate,
      deliveryDate,
      status,
      isPaid,
      isDelivered,
      invoiceNumber,
      notes,
      subtotal,
      totalAmount,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.orderDate == this.orderDate &&
          other.deliveryDate == this.deliveryDate &&
          other.status == this.status &&
          other.isPaid == this.isPaid &&
          other.isDelivered == this.isDelivered &&
          other.invoiceNumber == this.invoiceNumber &&
          other.notes == this.notes &&
          other.subtotal == this.subtotal &&
          other.totalAmount == this.totalAmount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<int?> customerId;
  final Value<DateTime> orderDate;
  final Value<DateTime?> deliveryDate;
  final Value<String> status;
  final Value<bool> isPaid;
  final Value<bool> isDelivered;
  final Value<String?> invoiceNumber;
  final Value<String?> notes;
  final Value<double> subtotal;
  final Value<double> totalAmount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.orderDate = const Value.absent(),
    this.deliveryDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.isDelivered = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    required DateTime orderDate,
    this.deliveryDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.isDelivered = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalAmount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : orderDate = Value(orderDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<DateTime>? orderDate,
    Expression<DateTime>? deliveryDate,
    Expression<String>? status,
    Expression<bool>? isPaid,
    Expression<bool>? isDelivered,
    Expression<String>? invoiceNumber,
    Expression<String>? notes,
    Expression<double>? subtotal,
    Expression<double>? totalAmount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (orderDate != null) 'order_date': orderDate,
      if (deliveryDate != null) 'delivery_date': deliveryDate,
      if (status != null) 'status': status,
      if (isPaid != null) 'is_paid': isPaid,
      if (isDelivered != null) 'is_delivered': isDelivered,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (notes != null) 'notes': notes,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<int?>? customerId,
      Value<DateTime>? orderDate,
      Value<DateTime?>? deliveryDate,
      Value<String>? status,
      Value<bool>? isPaid,
      Value<bool>? isDelivered,
      Value<String?>? invoiceNumber,
      Value<String?>? notes,
      Value<double>? subtotal,
      Value<double>? totalAmount,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return OrdersCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      isPaid: isPaid ?? this.isPaid,
      isDelivered: isDelivered ?? this.isDelivered,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      notes: notes ?? this.notes,
      subtotal: subtotal ?? this.subtotal,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (orderDate.present) {
      map['order_date'] = Variable<DateTime>(orderDate.value);
    }
    if (deliveryDate.present) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (isDelivered.present) {
      map['is_delivered'] = Variable<bool>(isDelivered.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('orderDate: $orderDate, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('status: $status, ')
          ..write('isPaid: $isPaid, ')
          ..write('isDelivered: $isDelivered, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('notes: $notes, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES orders (id) ON DELETE CASCADE'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        type,
        description,
        quantity,
        unit,
        unitPrice,
        lineTotal,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final String type;
  final String description;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double lineTotal;
  final String? notes;
  const OrderItem(
      {required this.id,
      required this.orderId,
      required this.type,
      required this.description,
      required this.quantity,
      required this.unit,
      required this.unitPrice,
      required this.lineTotal,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['unit_price'] = Variable<double>(unitPrice);
    map['line_total'] = Variable<double>(lineTotal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      type: Value(type),
      description: Value(description),
      quantity: Value(quantity),
      unit: Value(unit),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          String? type,
          String? description,
          double? quantity,
          String? unit,
          double? unitPrice,
          double? lineTotal,
          Value<String?> notes = const Value.absent()}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        type: type ?? this.type,
        description: description ?? this.description,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        unitPrice: unitPrice ?? this.unitPrice,
        lineTotal: lineTotal ?? this.lineTotal,
        notes: notes.present ? notes.value : this.notes,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, type, description, quantity,
      unit, unitPrice, lineTotal, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.type == this.type &&
          other.description == this.description &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal &&
          other.notes == this.notes);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<String> type;
  final Value<String> description;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> unitPrice;
  final Value<double> lineTotal;
  final Value<String?> notes;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.notes = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required String type,
    required String description,
    required double quantity,
    required String unit,
    required double unitPrice,
    required double lineTotal,
    this.notes = const Value.absent(),
  })  : orderId = Value(orderId),
        type = Value(type),
        description = Value(description),
        quantity = Value(quantity),
        unit = Value(unit),
        unitPrice = Value(unitPrice),
        lineTotal = Value(lineTotal);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? unitPrice,
    Expression<double>? lineTotal,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (notes != null) 'notes': notes,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<String>? type,
      Value<String>? description,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double>? unitPrice,
      Value<double>? lineTotal,
      Value<String?>? notes}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      type: type ?? this.type,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BirdsTable birds = $BirdsTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $FlockPurchasesTable flockPurchases = $FlockPurchasesTable(this);
  late final $FlockLossesTable flockLosses = $FlockLossesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $SavedGuidesTable savedGuides = $SavedGuidesTable(this);
  late final $ReadGuidesTable readGuides = $ReadGuidesTable(this);
  late final $CareLogsTable careLogs = $CareLogsTable(this);
  late final $CareLogPhotosTable careLogPhotos = $CareLogPhotosTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        birds,
        dailyLogs,
        sales,
        expenses,
        flockPurchases,
        flockLosses,
        settings,
        reminders,
        savedGuides,
        readGuides,
        careLogs,
        careLogPhotos,
        customers,
        orders,
        orderItems
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('care_logs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('care_log_photos', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('customers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('orders', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('orders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('order_items', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$BirdsTableCreateCompanionBuilder = BirdsCompanion Function({
  Value<int> id,
  Value<String> breed,
  Value<String?> eggColor,
  required DateTime hatchDate,
  Value<String> status,
  Value<String?> notes,
  Value<String?> photoPath,
});
typedef $$BirdsTableUpdateCompanionBuilder = BirdsCompanion Function({
  Value<int> id,
  Value<String> breed,
  Value<String?> eggColor,
  Value<DateTime> hatchDate,
  Value<String> status,
  Value<String?> notes,
  Value<String?> photoPath,
});

class $$BirdsTableFilterComposer extends Composer<_$AppDatabase, $BirdsTable> {
  $$BirdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eggColor => $composableBuilder(
      column: $table.eggColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get hatchDate => $composableBuilder(
      column: $table.hatchDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));
}

class $$BirdsTableOrderingComposer
    extends Composer<_$AppDatabase, $BirdsTable> {
  $$BirdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eggColor => $composableBuilder(
      column: $table.eggColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get hatchDate => $composableBuilder(
      column: $table.hatchDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));
}

class $$BirdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BirdsTable> {
  $$BirdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get eggColor =>
      $composableBuilder(column: $table.eggColor, builder: (column) => column);

  GeneratedColumn<DateTime> get hatchDate =>
      $composableBuilder(column: $table.hatchDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$BirdsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BirdsTable,
    Bird,
    $$BirdsTableFilterComposer,
    $$BirdsTableOrderingComposer,
    $$BirdsTableAnnotationComposer,
    $$BirdsTableCreateCompanionBuilder,
    $$BirdsTableUpdateCompanionBuilder,
    (Bird, BaseReferences<_$AppDatabase, $BirdsTable, Bird>),
    Bird,
    PrefetchHooks Function()> {
  $$BirdsTableTableManager(_$AppDatabase db, $BirdsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BirdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BirdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BirdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> breed = const Value.absent(),
            Value<String?> eggColor = const Value.absent(),
            Value<DateTime> hatchDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              BirdsCompanion(
            id: id,
            breed: breed,
            eggColor: eggColor,
            hatchDate: hatchDate,
            status: status,
            notes: notes,
            photoPath: photoPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> breed = const Value.absent(),
            Value<String?> eggColor = const Value.absent(),
            required DateTime hatchDate,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              BirdsCompanion.insert(
            id: id,
            breed: breed,
            eggColor: eggColor,
            hatchDate: hatchDate,
            status: status,
            notes: notes,
            photoPath: photoPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BirdsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BirdsTable,
    Bird,
    $$BirdsTableFilterComposer,
    $$BirdsTableOrderingComposer,
    $$BirdsTableAnnotationComposer,
    $$BirdsTableCreateCompanionBuilder,
    $$BirdsTableUpdateCompanionBuilder,
    (Bird, BaseReferences<_$AppDatabase, $BirdsTable, Bird>),
    Bird,
    PrefetchHooks Function()>;
typedef $$DailyLogsTableCreateCompanionBuilder = DailyLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<int> layingHens,
  Value<int> eggsBrown,
  Value<int> eggsColored,
  Value<int> eggsWhite,
  Value<String?> notes,
});
typedef $$DailyLogsTableUpdateCompanionBuilder = DailyLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> layingHens,
  Value<int> eggsBrown,
  Value<int> eggsColored,
  Value<int> eggsWhite,
  Value<String?> notes,
});

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get layingHens => $composableBuilder(
      column: $table.layingHens, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eggsBrown => $composableBuilder(
      column: $table.eggsBrown, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eggsColored => $composableBuilder(
      column: $table.eggsColored, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eggsWhite => $composableBuilder(
      column: $table.eggsWhite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get layingHens => $composableBuilder(
      column: $table.layingHens, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eggsBrown => $composableBuilder(
      column: $table.eggsBrown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eggsColored => $composableBuilder(
      column: $table.eggsColored, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eggsWhite => $composableBuilder(
      column: $table.eggsWhite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get layingHens => $composableBuilder(
      column: $table.layingHens, builder: (column) => column);

  GeneratedColumn<int> get eggsBrown =>
      $composableBuilder(column: $table.eggsBrown, builder: (column) => column);

  GeneratedColumn<int> get eggsColored => $composableBuilder(
      column: $table.eggsColored, builder: (column) => column);

  GeneratedColumn<int> get eggsWhite =>
      $composableBuilder(column: $table.eggsWhite, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$DailyLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyLogsTable,
    DailyLog,
    $$DailyLogsTableFilterComposer,
    $$DailyLogsTableOrderingComposer,
    $$DailyLogsTableAnnotationComposer,
    $$DailyLogsTableCreateCompanionBuilder,
    $$DailyLogsTableUpdateCompanionBuilder,
    (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
    DailyLog,
    PrefetchHooks Function()> {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> layingHens = const Value.absent(),
            Value<int> eggsBrown = const Value.absent(),
            Value<int> eggsColored = const Value.absent(),
            Value<int> eggsWhite = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              DailyLogsCompanion(
            id: id,
            date: date,
            layingHens: layingHens,
            eggsBrown: eggsBrown,
            eggsColored: eggsColored,
            eggsWhite: eggsWhite,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<int> layingHens = const Value.absent(),
            Value<int> eggsBrown = const Value.absent(),
            Value<int> eggsColored = const Value.absent(),
            Value<int> eggsWhite = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              DailyLogsCompanion.insert(
            id: id,
            date: date,
            layingHens: layingHens,
            eggsBrown: eggsBrown,
            eggsColored: eggsColored,
            eggsWhite: eggsWhite,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyLogsTable,
    DailyLog,
    $$DailyLogsTableFilterComposer,
    $$DailyLogsTableOrderingComposer,
    $$DailyLogsTableAnnotationComposer,
    $$DailyLogsTableCreateCompanionBuilder,
    $$DailyLogsTableUpdateCompanionBuilder,
    (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
    DailyLog,
    PrefetchHooks Function()>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  required DateTime date,
  required String type,
  required double quantity,
  Value<String> unit,
  required double amount,
  Value<String?> customerName,
  Value<bool> isPaid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> type,
  Value<double> quantity,
  Value<String> unit,
  Value<double> amount,
  Value<String?> customerName,
  Value<bool> isPaid,
});

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            unit: unit,
            amount: amount,
            customerName: customerName,
            isPaid: isPaid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String type,
            required double quantity,
            Value<String> unit = const Value.absent(),
            required double amount,
            Value<String?> customerName = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            unit: unit,
            amount: amount,
            customerName: customerName,
            isPaid: isPaid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required DateTime date,
  required String category,
  required double amount,
  Value<String?> description,
  Value<double?> pounds,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> category,
  Value<double> amount,
  Value<String?> description,
  Value<double?> pounds,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pounds => $composableBuilder(
      column: $table.pounds, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pounds => $composableBuilder(
      column: $table.pounds, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get pounds =>
      $composableBuilder(column: $table.pounds, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double?> pounds = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            date: date,
            category: category,
            amount: amount,
            description: description,
            pounds: pounds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String category,
            required double amount,
            Value<String?> description = const Value.absent(),
            Value<double?> pounds = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            date: date,
            category: category,
            amount: amount,
            description: description,
            pounds: pounds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$FlockPurchasesTableCreateCompanionBuilder = FlockPurchasesCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required String type,
  required int quantity,
  required double cost,
  Value<String?> supplier,
  Value<int?> hatchedCount,
});
typedef $$FlockPurchasesTableUpdateCompanionBuilder = FlockPurchasesCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> type,
  Value<int> quantity,
  Value<double> cost,
  Value<String?> supplier,
  Value<int?> hatchedCount,
});

class $$FlockPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $FlockPurchasesTable> {
  $$FlockPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hatchedCount => $composableBuilder(
      column: $table.hatchedCount, builder: (column) => ColumnFilters(column));
}

class $$FlockPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $FlockPurchasesTable> {
  $$FlockPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hatchedCount => $composableBuilder(
      column: $table.hatchedCount,
      builder: (column) => ColumnOrderings(column));
}

class $$FlockPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlockPurchasesTable> {
  $$FlockPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<int> get hatchedCount => $composableBuilder(
      column: $table.hatchedCount, builder: (column) => column);
}

class $$FlockPurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FlockPurchasesTable,
    FlockPurchase,
    $$FlockPurchasesTableFilterComposer,
    $$FlockPurchasesTableOrderingComposer,
    $$FlockPurchasesTableAnnotationComposer,
    $$FlockPurchasesTableCreateCompanionBuilder,
    $$FlockPurchasesTableUpdateCompanionBuilder,
    (
      FlockPurchase,
      BaseReferences<_$AppDatabase, $FlockPurchasesTable, FlockPurchase>
    ),
    FlockPurchase,
    PrefetchHooks Function()> {
  $$FlockPurchasesTableTableManager(
      _$AppDatabase db, $FlockPurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlockPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlockPurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlockPurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<String?> supplier = const Value.absent(),
            Value<int?> hatchedCount = const Value.absent(),
          }) =>
              FlockPurchasesCompanion(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            cost: cost,
            supplier: supplier,
            hatchedCount: hatchedCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String type,
            required int quantity,
            required double cost,
            Value<String?> supplier = const Value.absent(),
            Value<int?> hatchedCount = const Value.absent(),
          }) =>
              FlockPurchasesCompanion.insert(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            cost: cost,
            supplier: supplier,
            hatchedCount: hatchedCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FlockPurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FlockPurchasesTable,
    FlockPurchase,
    $$FlockPurchasesTableFilterComposer,
    $$FlockPurchasesTableOrderingComposer,
    $$FlockPurchasesTableAnnotationComposer,
    $$FlockPurchasesTableCreateCompanionBuilder,
    $$FlockPurchasesTableUpdateCompanionBuilder,
    (
      FlockPurchase,
      BaseReferences<_$AppDatabase, $FlockPurchasesTable, FlockPurchase>
    ),
    FlockPurchase,
    PrefetchHooks Function()>;
typedef $$FlockLossesTableCreateCompanionBuilder = FlockLossesCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required String type,
  required int quantity,
  Value<String?> predatorSubtype,
});
typedef $$FlockLossesTableUpdateCompanionBuilder = FlockLossesCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> type,
  Value<int> quantity,
  Value<String?> predatorSubtype,
});

class $$FlockLossesTableFilterComposer
    extends Composer<_$AppDatabase, $FlockLossesTable> {
  $$FlockLossesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predatorSubtype => $composableBuilder(
      column: $table.predatorSubtype,
      builder: (column) => ColumnFilters(column));
}

class $$FlockLossesTableOrderingComposer
    extends Composer<_$AppDatabase, $FlockLossesTable> {
  $$FlockLossesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predatorSubtype => $composableBuilder(
      column: $table.predatorSubtype,
      builder: (column) => ColumnOrderings(column));
}

class $$FlockLossesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlockLossesTable> {
  $$FlockLossesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get predatorSubtype => $composableBuilder(
      column: $table.predatorSubtype, builder: (column) => column);
}

class $$FlockLossesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FlockLossesTable,
    FlockLossesData,
    $$FlockLossesTableFilterComposer,
    $$FlockLossesTableOrderingComposer,
    $$FlockLossesTableAnnotationComposer,
    $$FlockLossesTableCreateCompanionBuilder,
    $$FlockLossesTableUpdateCompanionBuilder,
    (
      FlockLossesData,
      BaseReferences<_$AppDatabase, $FlockLossesTable, FlockLossesData>
    ),
    FlockLossesData,
    PrefetchHooks Function()> {
  $$FlockLossesTableTableManager(_$AppDatabase db, $FlockLossesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlockLossesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlockLossesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlockLossesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> predatorSubtype = const Value.absent(),
          }) =>
              FlockLossesCompanion(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            predatorSubtype: predatorSubtype,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String type,
            required int quantity,
            Value<String?> predatorSubtype = const Value.absent(),
          }) =>
              FlockLossesCompanion.insert(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            predatorSubtype: predatorSubtype,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FlockLossesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FlockLossesTable,
    FlockLossesData,
    $$FlockLossesTableFilterComposer,
    $$FlockLossesTableOrderingComposer,
    $$FlockLossesTableAnnotationComposer,
    $$FlockLossesTableCreateCompanionBuilder,
    $$FlockLossesTableUpdateCompanionBuilder,
    (
      FlockLossesData,
      BaseReferences<_$AppDatabase, $FlockLossesTable, FlockLossesData>
    ),
    FlockLossesData,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> currency,
  Value<String> weightUnit,
  Value<bool> darkMode,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> currency,
  Value<String> weightUnit,
  Value<bool> darkMode,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weightUnit => $composableBuilder(
      column: $table.weightUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get darkMode => $composableBuilder(
      column: $table.darkMode, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weightUnit => $composableBuilder(
      column: $table.weightUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get darkMode => $composableBuilder(
      column: $table.darkMode, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get weightUnit => $composableBuilder(
      column: $table.weightUnit, builder: (column) => column);

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> weightUnit = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            currency: currency,
            weightUnit: weightUnit,
            darkMode: darkMode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> weightUnit = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            id: id,
            currency: currency,
            weightUnit: weightUnit,
            darkMode: darkMode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required String type,
  required String title,
  Value<int> frequencyDays,
  required DateTime nextDueDate,
  Value<DateTime?> lastCompletedDate,
  Value<String?> notes,
  Value<bool> isActive,
  Value<bool> notifyOnAndroid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> title,
  Value<int> frequencyDays,
  Value<DateTime> nextDueDate,
  Value<DateTime?> lastCompletedDate,
  Value<String?> notes,
  Value<bool> isActive,
  Value<bool> notifyOnAndroid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCompletedDate => $composableBuilder(
      column: $table.lastCompletedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notifyOnAndroid => $composableBuilder(
      column: $table.notifyOnAndroid,
      builder: (column) => ColumnFilters(column));
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCompletedDate => $composableBuilder(
      column: $table.lastCompletedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notifyOnAndroid => $composableBuilder(
      column: $table.notifyOnAndroid,
      builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedDate => $composableBuilder(
      column: $table.lastCompletedDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get notifyOnAndroid => $composableBuilder(
      column: $table.notifyOnAndroid, builder: (column) => column);
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> frequencyDays = const Value.absent(),
            Value<DateTime> nextDueDate = const Value.absent(),
            Value<DateTime?> lastCompletedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> notifyOnAndroid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            type: type,
            title: title,
            frequencyDays: frequencyDays,
            nextDueDate: nextDueDate,
            lastCompletedDate: lastCompletedDate,
            notes: notes,
            isActive: isActive,
            notifyOnAndroid: notifyOnAndroid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String title,
            Value<int> frequencyDays = const Value.absent(),
            required DateTime nextDueDate,
            Value<DateTime?> lastCompletedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> notifyOnAndroid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            type: type,
            title: title,
            frequencyDays: frequencyDays,
            nextDueDate: nextDueDate,
            lastCompletedDate: lastCompletedDate,
            notes: notes,
            isActive: isActive,
            notifyOnAndroid: notifyOnAndroid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()>;
typedef $$SavedGuidesTableCreateCompanionBuilder = SavedGuidesCompanion
    Function({
  required String guideId,
  required DateTime savedAt,
  Value<int> rowid,
});
typedef $$SavedGuidesTableUpdateCompanionBuilder = SavedGuidesCompanion
    Function({
  Value<String> guideId,
  Value<DateTime> savedAt,
  Value<int> rowid,
});

class $$SavedGuidesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedGuidesTable> {
  $$SavedGuidesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get guideId => $composableBuilder(
      column: $table.guideId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$SavedGuidesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedGuidesTable> {
  $$SavedGuidesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get guideId => $composableBuilder(
      column: $table.guideId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$SavedGuidesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedGuidesTable> {
  $$SavedGuidesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get guideId =>
      $composableBuilder(column: $table.guideId, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$SavedGuidesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedGuidesTable,
    SavedGuide,
    $$SavedGuidesTableFilterComposer,
    $$SavedGuidesTableOrderingComposer,
    $$SavedGuidesTableAnnotationComposer,
    $$SavedGuidesTableCreateCompanionBuilder,
    $$SavedGuidesTableUpdateCompanionBuilder,
    (SavedGuide, BaseReferences<_$AppDatabase, $SavedGuidesTable, SavedGuide>),
    SavedGuide,
    PrefetchHooks Function()> {
  $$SavedGuidesTableTableManager(_$AppDatabase db, $SavedGuidesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedGuidesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedGuidesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedGuidesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> guideId = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedGuidesCompanion(
            guideId: guideId,
            savedAt: savedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String guideId,
            required DateTime savedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedGuidesCompanion.insert(
            guideId: guideId,
            savedAt: savedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedGuidesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedGuidesTable,
    SavedGuide,
    $$SavedGuidesTableFilterComposer,
    $$SavedGuidesTableOrderingComposer,
    $$SavedGuidesTableAnnotationComposer,
    $$SavedGuidesTableCreateCompanionBuilder,
    $$SavedGuidesTableUpdateCompanionBuilder,
    (SavedGuide, BaseReferences<_$AppDatabase, $SavedGuidesTable, SavedGuide>),
    SavedGuide,
    PrefetchHooks Function()>;
typedef $$ReadGuidesTableCreateCompanionBuilder = ReadGuidesCompanion Function({
  required String guideId,
  Value<int> progressPercent,
  Value<bool> completed,
  Value<DateTime?> lastReadAt,
  Value<int> rowid,
});
typedef $$ReadGuidesTableUpdateCompanionBuilder = ReadGuidesCompanion Function({
  Value<String> guideId,
  Value<int> progressPercent,
  Value<bool> completed,
  Value<DateTime?> lastReadAt,
  Value<int> rowid,
});

class $$ReadGuidesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadGuidesTable> {
  $$ReadGuidesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get guideId => $composableBuilder(
      column: $table.guideId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progressPercent => $composableBuilder(
      column: $table.progressPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnFilters(column));
}

class $$ReadGuidesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadGuidesTable> {
  $$ReadGuidesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get guideId => $composableBuilder(
      column: $table.guideId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progressPercent => $composableBuilder(
      column: $table.progressPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnOrderings(column));
}

class $$ReadGuidesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadGuidesTable> {
  $$ReadGuidesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get guideId =>
      $composableBuilder(column: $table.guideId, builder: (column) => column);

  GeneratedColumn<int> get progressPercent => $composableBuilder(
      column: $table.progressPercent, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => column);
}

class $$ReadGuidesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadGuidesTable,
    ReadGuide,
    $$ReadGuidesTableFilterComposer,
    $$ReadGuidesTableOrderingComposer,
    $$ReadGuidesTableAnnotationComposer,
    $$ReadGuidesTableCreateCompanionBuilder,
    $$ReadGuidesTableUpdateCompanionBuilder,
    (ReadGuide, BaseReferences<_$AppDatabase, $ReadGuidesTable, ReadGuide>),
    ReadGuide,
    PrefetchHooks Function()> {
  $$ReadGuidesTableTableManager(_$AppDatabase db, $ReadGuidesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadGuidesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadGuidesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadGuidesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> guideId = const Value.absent(),
            Value<int> progressPercent = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> lastReadAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadGuidesCompanion(
            guideId: guideId,
            progressPercent: progressPercent,
            completed: completed,
            lastReadAt: lastReadAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String guideId,
            Value<int> progressPercent = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> lastReadAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadGuidesCompanion.insert(
            guideId: guideId,
            progressPercent: progressPercent,
            completed: completed,
            lastReadAt: lastReadAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadGuidesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadGuidesTable,
    ReadGuide,
    $$ReadGuidesTableFilterComposer,
    $$ReadGuidesTableOrderingComposer,
    $$ReadGuidesTableAnnotationComposer,
    $$ReadGuidesTableCreateCompanionBuilder,
    $$ReadGuidesTableUpdateCompanionBuilder,
    (ReadGuide, BaseReferences<_$AppDatabase, $ReadGuidesTable, ReadGuide>),
    ReadGuide,
    PrefetchHooks Function()>;
typedef $$CareLogsTableCreateCompanionBuilder = CareLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<String> title,
  Value<String?> notes,
  required DateTime createdAt,
});
typedef $$CareLogsTableUpdateCompanionBuilder = CareLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> title,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$CareLogsTableReferences
    extends BaseReferences<_$AppDatabase, $CareLogsTable, CareLog> {
  $$CareLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CareLogPhotosTable, List<CareLogPhoto>>
      _careLogPhotosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.careLogPhotos,
              aliasName: $_aliasNameGenerator(
                  db.careLogs.id, db.careLogPhotos.careLogId));

  $$CareLogPhotosTableProcessedTableManager get careLogPhotosRefs {
    final manager = $$CareLogPhotosTableTableManager($_db, $_db.careLogPhotos)
        .filter((f) => f.careLogId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_careLogPhotosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CareLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> careLogPhotosRefs(
      Expression<bool> Function($$CareLogPhotosTableFilterComposer f) f) {
    final $$CareLogPhotosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.careLogPhotos,
        getReferencedColumn: (t) => t.careLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareLogPhotosTableFilterComposer(
              $db: $db,
              $table: $db.careLogPhotos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CareLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CareLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> careLogPhotosRefs<T extends Object>(
      Expression<T> Function($$CareLogPhotosTableAnnotationComposer a) f) {
    final $$CareLogPhotosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.careLogPhotos,
        getReferencedColumn: (t) => t.careLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareLogPhotosTableAnnotationComposer(
              $db: $db,
              $table: $db.careLogPhotos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CareLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CareLogsTable,
    CareLog,
    $$CareLogsTableFilterComposer,
    $$CareLogsTableOrderingComposer,
    $$CareLogsTableAnnotationComposer,
    $$CareLogsTableCreateCompanionBuilder,
    $$CareLogsTableUpdateCompanionBuilder,
    (CareLog, $$CareLogsTableReferences),
    CareLog,
    PrefetchHooks Function({bool careLogPhotosRefs})> {
  $$CareLogsTableTableManager(_$AppDatabase db, $CareLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CareLogsCompanion(
            id: id,
            date: date,
            title: title,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
          }) =>
              CareLogsCompanion.insert(
            id: id,
            date: date,
            title: title,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CareLogsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({careLogPhotosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (careLogPhotosRefs) db.careLogPhotos
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (careLogPhotosRefs)
                    await $_getPrefetchedData<CareLog, $CareLogsTable,
                            CareLogPhoto>(
                        currentTable: table,
                        referencedTable: $$CareLogsTableReferences
                            ._careLogPhotosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CareLogsTableReferences(db, table, p0)
                                .careLogPhotosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.careLogId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CareLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CareLogsTable,
    CareLog,
    $$CareLogsTableFilterComposer,
    $$CareLogsTableOrderingComposer,
    $$CareLogsTableAnnotationComposer,
    $$CareLogsTableCreateCompanionBuilder,
    $$CareLogsTableUpdateCompanionBuilder,
    (CareLog, $$CareLogsTableReferences),
    CareLog,
    PrefetchHooks Function({bool careLogPhotosRefs})>;
typedef $$CareLogPhotosTableCreateCompanionBuilder = CareLogPhotosCompanion
    Function({
  Value<int> id,
  required int careLogId,
  required String filePath,
  Value<String?> galleryUri,
  Value<String?> caption,
  required DateTime createdAt,
});
typedef $$CareLogPhotosTableUpdateCompanionBuilder = CareLogPhotosCompanion
    Function({
  Value<int> id,
  Value<int> careLogId,
  Value<String> filePath,
  Value<String?> galleryUri,
  Value<String?> caption,
  Value<DateTime> createdAt,
});

final class $$CareLogPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $CareLogPhotosTable, CareLogPhoto> {
  $$CareLogPhotosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CareLogsTable _careLogIdTable(_$AppDatabase db) =>
      db.careLogs.createAlias(
          $_aliasNameGenerator(db.careLogPhotos.careLogId, db.careLogs.id));

  $$CareLogsTableProcessedTableManager get careLogId {
    final $_column = $_itemColumn<int>('care_log_id')!;

    final manager = $$CareLogsTableTableManager($_db, $_db.careLogs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CareLogPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $CareLogPhotosTable> {
  $$CareLogPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get galleryUri => $composableBuilder(
      column: $table.galleryUri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CareLogsTableFilterComposer get careLogId {
    final $$CareLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careLogId,
        referencedTable: $db.careLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareLogsTableFilterComposer(
              $db: $db,
              $table: $db.careLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CareLogPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $CareLogPhotosTable> {
  $$CareLogPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get galleryUri => $composableBuilder(
      column: $table.galleryUri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CareLogsTableOrderingComposer get careLogId {
    final $$CareLogsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careLogId,
        referencedTable: $db.careLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareLogsTableOrderingComposer(
              $db: $db,
              $table: $db.careLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CareLogPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareLogPhotosTable> {
  $$CareLogPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get galleryUri => $composableBuilder(
      column: $table.galleryUri, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CareLogsTableAnnotationComposer get careLogId {
    final $$CareLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careLogId,
        referencedTable: $db.careLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CareLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.careLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CareLogPhotosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CareLogPhotosTable,
    CareLogPhoto,
    $$CareLogPhotosTableFilterComposer,
    $$CareLogPhotosTableOrderingComposer,
    $$CareLogPhotosTableAnnotationComposer,
    $$CareLogPhotosTableCreateCompanionBuilder,
    $$CareLogPhotosTableUpdateCompanionBuilder,
    (CareLogPhoto, $$CareLogPhotosTableReferences),
    CareLogPhoto,
    PrefetchHooks Function({bool careLogId})> {
  $$CareLogPhotosTableTableManager(_$AppDatabase db, $CareLogPhotosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareLogPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareLogPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareLogPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> careLogId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> galleryUri = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CareLogPhotosCompanion(
            id: id,
            careLogId: careLogId,
            filePath: filePath,
            galleryUri: galleryUri,
            caption: caption,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int careLogId,
            required String filePath,
            Value<String?> galleryUri = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            required DateTime createdAt,
          }) =>
              CareLogPhotosCompanion.insert(
            id: id,
            careLogId: careLogId,
            filePath: filePath,
            galleryUri: galleryUri,
            caption: caption,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CareLogPhotosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({careLogId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (careLogId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.careLogId,
                    referencedTable:
                        $$CareLogPhotosTableReferences._careLogIdTable(db),
                    referencedColumn:
                        $$CareLogPhotosTableReferences._careLogIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CareLogPhotosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CareLogPhotosTable,
    CareLogPhoto,
    $$CareLogPhotosTableFilterComposer,
    $$CareLogPhotosTableOrderingComposer,
    $$CareLogPhotosTableAnnotationComposer,
    $$CareLogPhotosTableCreateCompanionBuilder,
    $$CareLogPhotosTableUpdateCompanionBuilder,
    (CareLogPhoto, $$CareLogPhotosTableReferences),
    CareLogPhoto,
    PrefetchHooks Function({bool careLogId})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  required DateTime createdAt,
  Value<DateTime?> lastOrderDate,
  Value<double> totalSpent,
  Value<double> unpaidBalance,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> lastOrderDate,
  Value<double> totalSpent,
  Value<double> unpaidBalance,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.orders,
          aliasName:
              $_aliasNameGenerator(db.customers.id, db.orders.customerId));

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastOrderDate => $composableBuilder(
      column: $table.lastOrderDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unpaidBalance => $composableBuilder(
      column: $table.unpaidBalance, builder: (column) => ColumnFilters(column));

  Expression<bool> ordersRefs(
      Expression<bool> Function($$OrdersTableFilterComposer f) f) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastOrderDate => $composableBuilder(
      column: $table.lastOrderDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unpaidBalance => $composableBuilder(
      column: $table.unpaidBalance,
      builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOrderDate => $composableBuilder(
      column: $table.lastOrderDate, builder: (column) => column);

  GeneratedColumn<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => column);

  GeneratedColumn<double> get unpaidBalance => $composableBuilder(
      column: $table.unpaidBalance, builder: (column) => column);

  Expression<T> ordersRefs<T extends Object>(
      Expression<T> Function($$OrdersTableAnnotationComposer a) f) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool ordersRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastOrderDate = const Value.absent(),
            Value<double> totalSpent = const Value.absent(),
            Value<double> unpaidBalance = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            createdAt: createdAt,
            lastOrderDate: lastOrderDate,
            totalSpent: totalSpent,
            unpaidBalance: unpaidBalance,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> lastOrderDate = const Value.absent(),
            Value<double> totalSpent = const Value.absent(),
            Value<double> unpaidBalance = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            createdAt: createdAt,
            lastOrderDate: lastOrderDate,
            totalSpent: totalSpent,
            unpaidBalance: unpaidBalance,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable, Order>(
                        currentTable: table,
                        referencedTable:
                            $$CustomersTableReferences._ordersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .ordersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool ordersRefs})>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<int?> customerId,
  required DateTime orderDate,
  Value<DateTime?> deliveryDate,
  Value<String> status,
  Value<bool> isPaid,
  Value<bool> isDelivered,
  Value<String?> invoiceNumber,
  Value<String?> notes,
  Value<double> subtotal,
  Value<double> totalAmount,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<int?> customerId,
  Value<DateTime> orderDate,
  Value<DateTime?> deliveryDate,
  Value<String> status,
  Value<bool> isPaid,
  Value<bool> isDelivered,
  Value<String?> invoiceNumber,
  Value<String?> notes,
  Value<double> subtotal,
  Value<double> totalAmount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias($_aliasNameGenerator(db.orders.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get orderDate => $composableBuilder(
      column: $table.orderDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deliveryDate => $composableBuilder(
      column: $table.deliveryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDelivered => $composableBuilder(
      column: $table.isDelivered, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get orderDate => $composableBuilder(
      column: $table.orderDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deliveryDate => $composableBuilder(
      column: $table.deliveryDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDelivered => $composableBuilder(
      column: $table.isDelivered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get orderDate =>
      $composableBuilder(column: $table.orderDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveryDate => $composableBuilder(
      column: $table.deliveryDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<bool> get isDelivered => $composableBuilder(
      column: $table.isDelivered, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool customerId, bool orderItemsRefs})> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<DateTime> orderDate = const Value.absent(),
            Value<DateTime?> deliveryDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<bool> isDelivered = const Value.absent(),
            Value<String?> invoiceNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            customerId: customerId,
            orderDate: orderDate,
            deliveryDate: deliveryDate,
            status: status,
            isPaid: isPaid,
            isDelivered: isDelivered,
            invoiceNumber: invoiceNumber,
            notes: notes,
            subtotal: subtotal,
            totalAmount: totalAmount,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            required DateTime orderDate,
            Value<DateTime?> deliveryDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<bool> isDelivered = const Value.absent(),
            Value<String?> invoiceNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              OrdersCompanion.insert(
            id: id,
            customerId: customerId,
            orderDate: orderDate,
            deliveryDate: deliveryDate,
            status: status,
            isPaid: isPaid,
            isDelivered: isDelivered,
            invoiceNumber: invoiceNumber,
            notes: notes,
            subtotal: subtotal,
            totalAmount: totalAmount,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrdersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false, orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$OrdersTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$OrdersTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool customerId, bool orderItemsRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required String type,
  required String description,
  required double quantity,
  required String unit,
  required double unitPrice,
  required double lineTotal,
  Value<String?> notes,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<String> type,
  Value<String> description,
  Value<double> quantity,
  Value<String> unit,
  Value<double> unitPrice,
  Value<double> lineTotal,
  Value<String?> notes,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            type: type,
            description: description,
            quantity: quantity,
            unit: unit,
            unitPrice: unitPrice,
            lineTotal: lineTotal,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required String type,
            required String description,
            required double quantity,
            required String unit,
            required double unitPrice,
            required double lineTotal,
            Value<String?> notes = const Value.absent(),
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            type: type,
            description: description,
            quantity: quantity,
            unit: unit,
            unitPrice: unitPrice,
            lineTotal: lineTotal,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._orderIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BirdsTableTableManager get birds =>
      $$BirdsTableTableManager(_db, _db.birds);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$FlockPurchasesTableTableManager get flockPurchases =>
      $$FlockPurchasesTableTableManager(_db, _db.flockPurchases);
  $$FlockLossesTableTableManager get flockLosses =>
      $$FlockLossesTableTableManager(_db, _db.flockLosses);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$SavedGuidesTableTableManager get savedGuides =>
      $$SavedGuidesTableTableManager(_db, _db.savedGuides);
  $$ReadGuidesTableTableManager get readGuides =>
      $$ReadGuidesTableTableManager(_db, _db.readGuides);
  $$CareLogsTableTableManager get careLogs =>
      $$CareLogsTableTableManager(_db, _db.careLogs);
  $$CareLogPhotosTableTableManager get careLogPhotos =>
      $$CareLogPhotosTableTableManager(_db, _db.careLogPhotos);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
}
