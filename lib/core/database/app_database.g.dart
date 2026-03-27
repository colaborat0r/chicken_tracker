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
  @override
  List<GeneratedColumn> get $columns =>
      [id, breed, eggColor, hatchDate, status, notes];
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
  const Bird(
      {required this.id,
      required this.breed,
      this.eggColor,
      required this.hatchDate,
      required this.status,
      this.notes});
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
    };
  }

  Bird copyWith(
          {int? id,
          String? breed,
          Value<String?> eggColor = const Value.absent(),
          DateTime? hatchDate,
          String? status,
          Value<String?> notes = const Value.absent()}) =>
      Bird(
        id: id ?? this.id,
        breed: breed ?? this.breed,
        eggColor: eggColor.present ? eggColor.value : this.eggColor,
        hatchDate: hatchDate ?? this.hatchDate,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
      );
  Bird copyWithCompanion(BirdsCompanion data) {
    return Bird(
      id: data.id.present ? data.id.value : this.id,
      breed: data.breed.present ? data.breed.value : this.breed,
      eggColor: data.eggColor.present ? data.eggColor.value : this.eggColor,
      hatchDate: data.hatchDate.present ? data.hatchDate.value : this.hatchDate,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
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
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, breed, eggColor, hatchDate, status, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bird &&
          other.id == this.id &&
          other.breed == this.breed &&
          other.eggColor == this.eggColor &&
          other.hatchDate == this.hatchDate &&
          other.status == this.status &&
          other.notes == this.notes);
}

class BirdsCompanion extends UpdateCompanion<Bird> {
  final Value<int> id;
  final Value<String> breed;
  final Value<String?> eggColor;
  final Value<DateTime> hatchDate;
  final Value<String> status;
  final Value<String?> notes;
  const BirdsCompanion({
    this.id = const Value.absent(),
    this.breed = const Value.absent(),
    this.eggColor = const Value.absent(),
    this.hatchDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
  });
  BirdsCompanion.insert({
    this.id = const Value.absent(),
    this.breed = const Value.absent(),
    this.eggColor = const Value.absent(),
    required DateTime hatchDate,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
  }) : hatchDate = Value(hatchDate);
  static Insertable<Bird> custom({
    Expression<int>? id,
    Expression<String>? breed,
    Expression<String>? eggColor,
    Expression<DateTime>? hatchDate,
    Expression<String>? status,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (breed != null) 'breed': breed,
      if (eggColor != null) 'egg_color': eggColor,
      if (hatchDate != null) 'hatch_date': hatchDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
    });
  }

  BirdsCompanion copyWith(
      {Value<int>? id,
      Value<String>? breed,
      Value<String?>? eggColor,
      Value<DateTime>? hatchDate,
      Value<String>? status,
      Value<String?>? notes}) {
    return BirdsCompanion(
      id: id ?? this.id,
      breed: breed ?? this.breed,
      eggColor: eggColor ?? this.eggColor,
      hatchDate: hatchDate ?? this.hatchDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
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
          ..write('notes: $notes')
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
      [date, layingHens, eggsBrown, eggsColored, eggsWhite, notes];
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
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {date},
      ];
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
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
  final DateTime date;
  final int layingHens;
  final int eggsBrown;
  final int eggsColored;
  final int eggsWhite;
  final String? notes;
  const DailyLog(
      {required this.date,
      required this.layingHens,
      required this.eggsBrown,
      required this.eggsColored,
      required this.eggsWhite,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
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
      'date': serializer.toJson<DateTime>(date),
      'layingHens': serializer.toJson<int>(layingHens),
      'eggsBrown': serializer.toJson<int>(eggsBrown),
      'eggsColored': serializer.toJson<int>(eggsColored),
      'eggsWhite': serializer.toJson<int>(eggsWhite),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DailyLog copyWith(
          {DateTime? date,
          int? layingHens,
          int? eggsBrown,
          int? eggsColored,
          int? eggsWhite,
          Value<String?> notes = const Value.absent()}) =>
      DailyLog(
        date: date ?? this.date,
        layingHens: layingHens ?? this.layingHens,
        eggsBrown: eggsBrown ?? this.eggsBrown,
        eggsColored: eggsColored ?? this.eggsColored,
        eggsWhite: eggsWhite ?? this.eggsWhite,
        notes: notes.present ? notes.value : this.notes,
      );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
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
  int get hashCode =>
      Object.hash(date, layingHens, eggsBrown, eggsColored, eggsWhite, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.date == this.date &&
          other.layingHens == this.layingHens &&
          other.eggsBrown == this.eggsBrown &&
          other.eggsColored == this.eggsColored &&
          other.eggsWhite == this.eggsWhite &&
          other.notes == this.notes);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<DateTime> date;
  final Value<int> layingHens;
  final Value<int> eggsBrown;
  final Value<int> eggsColored;
  final Value<int> eggsWhite;
  final Value<String?> notes;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.date = const Value.absent(),
    this.layingHens = const Value.absent(),
    this.eggsBrown = const Value.absent(),
    this.eggsColored = const Value.absent(),
    this.eggsWhite = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required DateTime date,
    this.layingHens = const Value.absent(),
    this.eggsBrown = const Value.absent(),
    this.eggsColored = const Value.absent(),
    this.eggsWhite = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyLog> custom({
    Expression<DateTime>? date,
    Expression<int>? layingHens,
    Expression<int>? eggsBrown,
    Expression<int>? eggsColored,
    Expression<int>? eggsWhite,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (layingHens != null) 'laying_hens': layingHens,
      if (eggsBrown != null) 'eggs_brown': eggsBrown,
      if (eggsColored != null) 'eggs_colored': eggsColored,
      if (eggsWhite != null) 'eggs_white': eggsWhite,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith(
      {Value<DateTime>? date,
      Value<int>? layingHens,
      Value<int>? eggsBrown,
      Value<int>? eggsColored,
      Value<int>? eggsWhite,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return DailyLogsCompanion(
      date: date ?? this.date,
      layingHens: layingHens ?? this.layingHens,
      eggsBrown: eggsBrown ?? this.eggsBrown,
      eggsColored: eggsColored ?? this.eggsColored,
      eggsWhite: eggsWhite ?? this.eggsWhite,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('date: $date, ')
          ..write('layingHens: $layingHens, ')
          ..write('eggsBrown: $eggsBrown, ')
          ..write('eggsColored: $eggsColored, ')
          ..write('eggsWhite: $eggsWhite, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, type, quantity, amount, customerName];
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
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
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
  final int quantity;
  final double amount;
  final String? customerName;
  const Sale(
      {required this.id,
      required this.date,
      required this.type,
      required this.quantity,
      required this.amount,
      this.customerName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['quantity'] = Variable<int>(quantity);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      quantity: Value(quantity),
      amount: Value(amount),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      quantity: serializer.fromJson<int>(json['quantity']),
      amount: serializer.fromJson<double>(json['amount']),
      customerName: serializer.fromJson<String?>(json['customerName']),
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
      'amount': serializer.toJson<double>(amount),
      'customerName': serializer.toJson<String?>(customerName),
    };
  }

  Sale copyWith(
          {int? id,
          DateTime? date,
          String? type,
          int? quantity,
          double? amount,
          Value<String?> customerName = const Value.absent()}) =>
      Sale(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        quantity: quantity ?? this.quantity,
        amount: amount ?? this.amount,
        customerName:
            customerName.present ? customerName.value : this.customerName,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      amount: data.amount.present ? data.amount.value : this.amount,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('customerName: $customerName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, type, quantity, amount, customerName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.amount == this.amount &&
          other.customerName == this.customerName);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<int> quantity;
  final Value<double> amount;
  final Value<String?> customerName;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.amount = const Value.absent(),
    this.customerName = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    required int quantity,
    required double amount,
    this.customerName = const Value.absent(),
  })  : date = Value(date),
        type = Value(type),
        quantity = Value(quantity),
        amount = Value(amount);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? quantity,
    Expression<double>? amount,
    Expression<String>? customerName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (amount != null) 'amount': amount,
      if (customerName != null) 'customer_name': customerName,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? type,
      Value<int>? quantity,
      Value<double>? amount,
      Value<String?>? customerName}) {
    return SalesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      customerName: customerName ?? this.customerName,
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
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
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
          ..write('amount: $amount, ')
          ..write('customerName: $customerName')
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
        settings
      ];
}

typedef $$BirdsTableCreateCompanionBuilder = BirdsCompanion Function({
  Value<int> id,
  Value<String> breed,
  Value<String?> eggColor,
  required DateTime hatchDate,
  Value<String> status,
  Value<String?> notes,
});
typedef $$BirdsTableUpdateCompanionBuilder = BirdsCompanion Function({
  Value<int> id,
  Value<String> breed,
  Value<String?> eggColor,
  Value<DateTime> hatchDate,
  Value<String> status,
  Value<String?> notes,
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
          }) =>
              BirdsCompanion(
            id: id,
            breed: breed,
            eggColor: eggColor,
            hatchDate: hatchDate,
            status: status,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> breed = const Value.absent(),
            Value<String?> eggColor = const Value.absent(),
            required DateTime hatchDate,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              BirdsCompanion.insert(
            id: id,
            breed: breed,
            eggColor: eggColor,
            hatchDate: hatchDate,
            status: status,
            notes: notes,
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
  required DateTime date,
  Value<int> layingHens,
  Value<int> eggsBrown,
  Value<int> eggsColored,
  Value<int> eggsWhite,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$DailyLogsTableUpdateCompanionBuilder = DailyLogsCompanion Function({
  Value<DateTime> date,
  Value<int> layingHens,
  Value<int> eggsBrown,
  Value<int> eggsColored,
  Value<int> eggsWhite,
  Value<String?> notes,
  Value<int> rowid,
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
            Value<DateTime> date = const Value.absent(),
            Value<int> layingHens = const Value.absent(),
            Value<int> eggsBrown = const Value.absent(),
            Value<int> eggsColored = const Value.absent(),
            Value<int> eggsWhite = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyLogsCompanion(
            date: date,
            layingHens: layingHens,
            eggsBrown: eggsBrown,
            eggsColored: eggsColored,
            eggsWhite: eggsWhite,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime date,
            Value<int> layingHens = const Value.absent(),
            Value<int> eggsBrown = const Value.absent(),
            Value<int> eggsColored = const Value.absent(),
            Value<int> eggsWhite = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyLogsCompanion.insert(
            date: date,
            layingHens: layingHens,
            eggsBrown: eggsBrown,
            eggsColored: eggsColored,
            eggsWhite: eggsWhite,
            notes: notes,
            rowid: rowid,
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
  required int quantity,
  required double amount,
  Value<String?> customerName,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> type,
  Value<int> quantity,
  Value<double> amount,
  Value<String?> customerName,
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

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);
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
            Value<int> quantity = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            amount: amount,
            customerName: customerName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String type,
            required int quantity,
            required double amount,
            Value<String?> customerName = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            date: date,
            type: type,
            quantity: quantity,
            amount: amount,
            customerName: customerName,
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
}
