// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MaschinenTable extends Maschinen
    with TableInfo<$MaschinenTable, MaschineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaschinenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _geraeteIdMeta = const VerificationMeta(
    'geraeteId',
  );
  @override
  late final GeneratedColumn<String> geraeteId = GeneratedColumn<String>(
    'geraete_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _standortMeta = const VerificationMeta(
    'standort',
  );
  @override
  late final GeneratedColumn<String> standort = GeneratedColumn<String>(
    'standort',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    $customConstraints:
        'NOT NULL CHECK (status IN (\'aktiv\', \'inaktiv\', \'stoerung\'))',
  );
  static const VerificationMeta _kundennummerMeta = const VerificationMeta(
    'kundennummer',
  );
  @override
  late final GeneratedColumn<String> kundennummer = GeneratedColumn<String>(
    'kundennummer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    geraeteId,
    standort,
    status,
    kundennummer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maschine';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaschineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('geraete_id')) {
      context.handle(
        _geraeteIdMeta,
        geraeteId.isAcceptableOrUnknown(data['geraete_id']!, _geraeteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_geraeteIdMeta);
    }
    if (data.containsKey('standort')) {
      context.handle(
        _standortMeta,
        standort.isAcceptableOrUnknown(data['standort']!, _standortMeta),
      );
    } else if (isInserting) {
      context.missing(_standortMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('kundennummer')) {
      context.handle(
        _kundennummerMeta,
        kundennummer.isAcceptableOrUnknown(
          data['kundennummer']!,
          _kundennummerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kundennummerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaschineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaschineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      geraeteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geraete_id'],
      )!,
      standort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}standort'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      kundennummer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kundennummer'],
      )!,
    );
  }

  @override
  $MaschinenTable createAlias(String alias) {
    return $MaschinenTable(attachedDatabase, alias);
  }
}

class MaschineRow extends DataClass implements Insertable<MaschineRow> {
  final int id;
  final String geraeteId;
  final String standort;
  final String status;
  final String kundennummer;
  const MaschineRow({
    required this.id,
    required this.geraeteId,
    required this.standort,
    required this.status,
    required this.kundennummer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['geraete_id'] = Variable<String>(geraeteId);
    map['standort'] = Variable<String>(standort);
    map['status'] = Variable<String>(status);
    map['kundennummer'] = Variable<String>(kundennummer);
    return map;
  }

  MaschinenCompanion toCompanion(bool nullToAbsent) {
    return MaschinenCompanion(
      id: Value(id),
      geraeteId: Value(geraeteId),
      standort: Value(standort),
      status: Value(status),
      kundennummer: Value(kundennummer),
    );
  }

  factory MaschineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaschineRow(
      id: serializer.fromJson<int>(json['id']),
      geraeteId: serializer.fromJson<String>(json['geraeteId']),
      standort: serializer.fromJson<String>(json['standort']),
      status: serializer.fromJson<String>(json['status']),
      kundennummer: serializer.fromJson<String>(json['kundennummer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'geraeteId': serializer.toJson<String>(geraeteId),
      'standort': serializer.toJson<String>(standort),
      'status': serializer.toJson<String>(status),
      'kundennummer': serializer.toJson<String>(kundennummer),
    };
  }

  MaschineRow copyWith({
    int? id,
    String? geraeteId,
    String? standort,
    String? status,
    String? kundennummer,
  }) => MaschineRow(
    id: id ?? this.id,
    geraeteId: geraeteId ?? this.geraeteId,
    standort: standort ?? this.standort,
    status: status ?? this.status,
    kundennummer: kundennummer ?? this.kundennummer,
  );
  MaschineRow copyWithCompanion(MaschinenCompanion data) {
    return MaschineRow(
      id: data.id.present ? data.id.value : this.id,
      geraeteId: data.geraeteId.present ? data.geraeteId.value : this.geraeteId,
      standort: data.standort.present ? data.standort.value : this.standort,
      status: data.status.present ? data.status.value : this.status,
      kundennummer: data.kundennummer.present
          ? data.kundennummer.value
          : this.kundennummer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaschineRow(')
          ..write('id: $id, ')
          ..write('geraeteId: $geraeteId, ')
          ..write('standort: $standort, ')
          ..write('status: $status, ')
          ..write('kundennummer: $kundennummer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, geraeteId, standort, status, kundennummer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaschineRow &&
          other.id == this.id &&
          other.geraeteId == this.geraeteId &&
          other.standort == this.standort &&
          other.status == this.status &&
          other.kundennummer == this.kundennummer);
}

class MaschinenCompanion extends UpdateCompanion<MaschineRow> {
  final Value<int> id;
  final Value<String> geraeteId;
  final Value<String> standort;
  final Value<String> status;
  final Value<String> kundennummer;
  const MaschinenCompanion({
    this.id = const Value.absent(),
    this.geraeteId = const Value.absent(),
    this.standort = const Value.absent(),
    this.status = const Value.absent(),
    this.kundennummer = const Value.absent(),
  });
  MaschinenCompanion.insert({
    this.id = const Value.absent(),
    required String geraeteId,
    required String standort,
    required String status,
    required String kundennummer,
  }) : geraeteId = Value(geraeteId),
       standort = Value(standort),
       status = Value(status),
       kundennummer = Value(kundennummer);
  static Insertable<MaschineRow> custom({
    Expression<int>? id,
    Expression<String>? geraeteId,
    Expression<String>? standort,
    Expression<String>? status,
    Expression<String>? kundennummer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (geraeteId != null) 'geraete_id': geraeteId,
      if (standort != null) 'standort': standort,
      if (status != null) 'status': status,
      if (kundennummer != null) 'kundennummer': kundennummer,
    });
  }

  MaschinenCompanion copyWith({
    Value<int>? id,
    Value<String>? geraeteId,
    Value<String>? standort,
    Value<String>? status,
    Value<String>? kundennummer,
  }) {
    return MaschinenCompanion(
      id: id ?? this.id,
      geraeteId: geraeteId ?? this.geraeteId,
      standort: standort ?? this.standort,
      status: status ?? this.status,
      kundennummer: kundennummer ?? this.kundennummer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (geraeteId.present) {
      map['geraete_id'] = Variable<String>(geraeteId.value);
    }
    if (standort.present) {
      map['standort'] = Variable<String>(standort.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (kundennummer.present) {
      map['kundennummer'] = Variable<String>(kundennummer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaschinenCompanion(')
          ..write('id: $id, ')
          ..write('geraeteId: $geraeteId, ')
          ..write('standort: $standort, ')
          ..write('status: $status, ')
          ..write('kundennummer: $kundennummer')
          ..write(')'))
        .toString();
  }
}

class $VerkaeufeTable extends Verkaeufe
    with TableInfo<$VerkaeufeTable, VerkaufRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerkaeufeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _maschineIdMeta = const VerificationMeta(
    'maschineId',
  );
  @override
  late final GeneratedColumn<int> maschineId = GeneratedColumn<int>(
    'maschine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES maschine (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parkdauerMinutenMeta = const VerificationMeta(
    'parkdauerMinuten',
  );
  @override
  late final GeneratedColumn<int> parkdauerMinuten = GeneratedColumn<int>(
    'parkdauer_minuten',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (parkdauer_minuten > 0)',
  );
  static const VerificationMeta _betragCentMeta = const VerificationMeta(
    'betragCent',
  );
  @override
  late final GeneratedColumn<int> betragCent = GeneratedColumn<int>(
    'betrag_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (betrag_cent >= 0)',
  );
  static const VerificationMeta _zahlungsartMeta = const VerificationMeta(
    'zahlungsart',
  );
  @override
  late final GeneratedColumn<String> zahlungsart = GeneratedColumn<String>(
    'zahlungsart',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (zahlungsart IN (\'bar\', \'karte\', \'paypal\', \'google_wallet\', \'google_pay\'))',
  );
  static const VerificationMeta _belegnummerMeta = const VerificationMeta(
    'belegnummer',
  );
  @override
  late final GeneratedColumn<int> belegnummer = GeneratedColumn<int>(
    'belegnummer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _kennzeichenMeta = const VerificationMeta(
    'kennzeichen',
  );
  @override
  late final GeneratedColumn<String> kennzeichen = GeneratedColumn<String>(
    'kennzeichen',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    maschineId,
    timestamp,
    parkdauerMinuten,
    betragCent,
    zahlungsart,
    belegnummer,
    kennzeichen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verkaeufe';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerkaufRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('maschine_id')) {
      context.handle(
        _maschineIdMeta,
        maschineId.isAcceptableOrUnknown(data['maschine_id']!, _maschineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_maschineIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('parkdauer_minuten')) {
      context.handle(
        _parkdauerMinutenMeta,
        parkdauerMinuten.isAcceptableOrUnknown(
          data['parkdauer_minuten']!,
          _parkdauerMinutenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parkdauerMinutenMeta);
    }
    if (data.containsKey('betrag_cent')) {
      context.handle(
        _betragCentMeta,
        betragCent.isAcceptableOrUnknown(data['betrag_cent']!, _betragCentMeta),
      );
    } else if (isInserting) {
      context.missing(_betragCentMeta);
    }
    if (data.containsKey('zahlungsart')) {
      context.handle(
        _zahlungsartMeta,
        zahlungsart.isAcceptableOrUnknown(
          data['zahlungsart']!,
          _zahlungsartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_zahlungsartMeta);
    }
    if (data.containsKey('belegnummer')) {
      context.handle(
        _belegnummerMeta,
        belegnummer.isAcceptableOrUnknown(
          data['belegnummer']!,
          _belegnummerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_belegnummerMeta);
    }
    if (data.containsKey('kennzeichen')) {
      context.handle(
        _kennzeichenMeta,
        kennzeichen.isAcceptableOrUnknown(
          data['kennzeichen']!,
          _kennzeichenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerkaufRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerkaufRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      maschineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maschine_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
      parkdauerMinuten: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parkdauer_minuten'],
      )!,
      betragCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}betrag_cent'],
      )!,
      zahlungsart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zahlungsart'],
      )!,
      belegnummer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}belegnummer'],
      )!,
      kennzeichen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kennzeichen'],
      ),
    );
  }

  @override
  $VerkaeufeTable createAlias(String alias) {
    return $VerkaeufeTable(attachedDatabase, alias);
  }
}

class VerkaufRow extends DataClass implements Insertable<VerkaufRow> {
  final int id;
  final int maschineId;
  final String timestamp;
  final int parkdauerMinuten;
  final int betragCent;
  final String zahlungsart;
  final int belegnummer;
  final String? kennzeichen;
  const VerkaufRow({
    required this.id,
    required this.maschineId,
    required this.timestamp,
    required this.parkdauerMinuten,
    required this.betragCent,
    required this.zahlungsart,
    required this.belegnummer,
    this.kennzeichen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['maschine_id'] = Variable<int>(maschineId);
    map['timestamp'] = Variable<String>(timestamp);
    map['parkdauer_minuten'] = Variable<int>(parkdauerMinuten);
    map['betrag_cent'] = Variable<int>(betragCent);
    map['zahlungsart'] = Variable<String>(zahlungsart);
    map['belegnummer'] = Variable<int>(belegnummer);
    if (!nullToAbsent || kennzeichen != null) {
      map['kennzeichen'] = Variable<String>(kennzeichen);
    }
    return map;
  }

  VerkaeufeCompanion toCompanion(bool nullToAbsent) {
    return VerkaeufeCompanion(
      id: Value(id),
      maschineId: Value(maschineId),
      timestamp: Value(timestamp),
      parkdauerMinuten: Value(parkdauerMinuten),
      betragCent: Value(betragCent),
      zahlungsart: Value(zahlungsart),
      belegnummer: Value(belegnummer),
      kennzeichen: kennzeichen == null && nullToAbsent
          ? const Value.absent()
          : Value(kennzeichen),
    );
  }

  factory VerkaufRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerkaufRow(
      id: serializer.fromJson<int>(json['id']),
      maschineId: serializer.fromJson<int>(json['maschineId']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      parkdauerMinuten: serializer.fromJson<int>(json['parkdauerMinuten']),
      betragCent: serializer.fromJson<int>(json['betragCent']),
      zahlungsart: serializer.fromJson<String>(json['zahlungsart']),
      belegnummer: serializer.fromJson<int>(json['belegnummer']),
      kennzeichen: serializer.fromJson<String?>(json['kennzeichen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maschineId': serializer.toJson<int>(maschineId),
      'timestamp': serializer.toJson<String>(timestamp),
      'parkdauerMinuten': serializer.toJson<int>(parkdauerMinuten),
      'betragCent': serializer.toJson<int>(betragCent),
      'zahlungsart': serializer.toJson<String>(zahlungsart),
      'belegnummer': serializer.toJson<int>(belegnummer),
      'kennzeichen': serializer.toJson<String?>(kennzeichen),
    };
  }

  VerkaufRow copyWith({
    int? id,
    int? maschineId,
    String? timestamp,
    int? parkdauerMinuten,
    int? betragCent,
    String? zahlungsart,
    int? belegnummer,
    Value<String?> kennzeichen = const Value.absent(),
  }) => VerkaufRow(
    id: id ?? this.id,
    maschineId: maschineId ?? this.maschineId,
    timestamp: timestamp ?? this.timestamp,
    parkdauerMinuten: parkdauerMinuten ?? this.parkdauerMinuten,
    betragCent: betragCent ?? this.betragCent,
    zahlungsart: zahlungsart ?? this.zahlungsart,
    belegnummer: belegnummer ?? this.belegnummer,
    kennzeichen: kennzeichen.present ? kennzeichen.value : this.kennzeichen,
  );
  VerkaufRow copyWithCompanion(VerkaeufeCompanion data) {
    return VerkaufRow(
      id: data.id.present ? data.id.value : this.id,
      maschineId: data.maschineId.present
          ? data.maschineId.value
          : this.maschineId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      parkdauerMinuten: data.parkdauerMinuten.present
          ? data.parkdauerMinuten.value
          : this.parkdauerMinuten,
      betragCent: data.betragCent.present
          ? data.betragCent.value
          : this.betragCent,
      zahlungsart: data.zahlungsart.present
          ? data.zahlungsart.value
          : this.zahlungsart,
      belegnummer: data.belegnummer.present
          ? data.belegnummer.value
          : this.belegnummer,
      kennzeichen: data.kennzeichen.present
          ? data.kennzeichen.value
          : this.kennzeichen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerkaufRow(')
          ..write('id: $id, ')
          ..write('maschineId: $maschineId, ')
          ..write('timestamp: $timestamp, ')
          ..write('parkdauerMinuten: $parkdauerMinuten, ')
          ..write('betragCent: $betragCent, ')
          ..write('zahlungsart: $zahlungsart, ')
          ..write('belegnummer: $belegnummer, ')
          ..write('kennzeichen: $kennzeichen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    maschineId,
    timestamp,
    parkdauerMinuten,
    betragCent,
    zahlungsart,
    belegnummer,
    kennzeichen,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerkaufRow &&
          other.id == this.id &&
          other.maschineId == this.maschineId &&
          other.timestamp == this.timestamp &&
          other.parkdauerMinuten == this.parkdauerMinuten &&
          other.betragCent == this.betragCent &&
          other.zahlungsart == this.zahlungsart &&
          other.belegnummer == this.belegnummer &&
          other.kennzeichen == this.kennzeichen);
}

class VerkaeufeCompanion extends UpdateCompanion<VerkaufRow> {
  final Value<int> id;
  final Value<int> maschineId;
  final Value<String> timestamp;
  final Value<int> parkdauerMinuten;
  final Value<int> betragCent;
  final Value<String> zahlungsart;
  final Value<int> belegnummer;
  final Value<String?> kennzeichen;
  const VerkaeufeCompanion({
    this.id = const Value.absent(),
    this.maschineId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.parkdauerMinuten = const Value.absent(),
    this.betragCent = const Value.absent(),
    this.zahlungsart = const Value.absent(),
    this.belegnummer = const Value.absent(),
    this.kennzeichen = const Value.absent(),
  });
  VerkaeufeCompanion.insert({
    this.id = const Value.absent(),
    required int maschineId,
    required String timestamp,
    required int parkdauerMinuten,
    required int betragCent,
    required String zahlungsart,
    required int belegnummer,
    this.kennzeichen = const Value.absent(),
  }) : maschineId = Value(maschineId),
       timestamp = Value(timestamp),
       parkdauerMinuten = Value(parkdauerMinuten),
       betragCent = Value(betragCent),
       zahlungsart = Value(zahlungsart),
       belegnummer = Value(belegnummer);
  static Insertable<VerkaufRow> custom({
    Expression<int>? id,
    Expression<int>? maschineId,
    Expression<String>? timestamp,
    Expression<int>? parkdauerMinuten,
    Expression<int>? betragCent,
    Expression<String>? zahlungsart,
    Expression<int>? belegnummer,
    Expression<String>? kennzeichen,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maschineId != null) 'maschine_id': maschineId,
      if (timestamp != null) 'timestamp': timestamp,
      if (parkdauerMinuten != null) 'parkdauer_minuten': parkdauerMinuten,
      if (betragCent != null) 'betrag_cent': betragCent,
      if (zahlungsart != null) 'zahlungsart': zahlungsart,
      if (belegnummer != null) 'belegnummer': belegnummer,
      if (kennzeichen != null) 'kennzeichen': kennzeichen,
    });
  }

  VerkaeufeCompanion copyWith({
    Value<int>? id,
    Value<int>? maschineId,
    Value<String>? timestamp,
    Value<int>? parkdauerMinuten,
    Value<int>? betragCent,
    Value<String>? zahlungsart,
    Value<int>? belegnummer,
    Value<String?>? kennzeichen,
  }) {
    return VerkaeufeCompanion(
      id: id ?? this.id,
      maschineId: maschineId ?? this.maschineId,
      timestamp: timestamp ?? this.timestamp,
      parkdauerMinuten: parkdauerMinuten ?? this.parkdauerMinuten,
      betragCent: betragCent ?? this.betragCent,
      zahlungsart: zahlungsart ?? this.zahlungsart,
      belegnummer: belegnummer ?? this.belegnummer,
      kennzeichen: kennzeichen ?? this.kennzeichen,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maschineId.present) {
      map['maschine_id'] = Variable<int>(maschineId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (parkdauerMinuten.present) {
      map['parkdauer_minuten'] = Variable<int>(parkdauerMinuten.value);
    }
    if (betragCent.present) {
      map['betrag_cent'] = Variable<int>(betragCent.value);
    }
    if (zahlungsart.present) {
      map['zahlungsart'] = Variable<String>(zahlungsart.value);
    }
    if (belegnummer.present) {
      map['belegnummer'] = Variable<int>(belegnummer.value);
    }
    if (kennzeichen.present) {
      map['kennzeichen'] = Variable<String>(kennzeichen.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerkaeufeCompanion(')
          ..write('id: $id, ')
          ..write('maschineId: $maschineId, ')
          ..write('timestamp: $timestamp, ')
          ..write('parkdauerMinuten: $parkdauerMinuten, ')
          ..write('betragCent: $betragCent, ')
          ..write('zahlungsart: $zahlungsart, ')
          ..write('belegnummer: $belegnummer, ')
          ..write('kennzeichen: $kennzeichen')
          ..write(')'))
        .toString();
  }
}

class $PreissettingsTable extends Preissettings
    with TableInfo<$PreissettingsTable, PreissettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreissettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taktMinutenMeta = const VerificationMeta(
    'taktMinuten',
  );
  @override
  late final GeneratedColumn<int> taktMinuten = GeneratedColumn<int>(
    'takt_minuten',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (takt_minuten > 0)',
  );
  static const VerificationMeta _preisProTaktCentMeta = const VerificationMeta(
    'preisProTaktCent',
  );
  @override
  late final GeneratedColumn<int> preisProTaktCent = GeneratedColumn<int>(
    'preis_pro_takt_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (preis_pro_takt_cent >= 0)',
  );
  static const VerificationMeta _waehrungMeta = const VerificationMeta(
    'waehrung',
  );
  @override
  late final GeneratedColumn<String> waehrung = GeneratedColumn<String>(
    'waehrung',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _gueltigVonMeta = const VerificationMeta(
    'gueltigVon',
  );
  @override
  late final GeneratedColumn<String> gueltigVon = GeneratedColumn<String>(
    'gueltig_von',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gueltigBisMeta = const VerificationMeta(
    'gueltigBis',
  );
  @override
  late final GeneratedColumn<String> gueltigBis = GeneratedColumn<String>(
    'gueltig_bis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taktMinuten,
    preisProTaktCent,
    waehrung,
    gueltigVon,
    gueltigBis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preissetting';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreissettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('takt_minuten')) {
      context.handle(
        _taktMinutenMeta,
        taktMinuten.isAcceptableOrUnknown(
          data['takt_minuten']!,
          _taktMinutenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taktMinutenMeta);
    }
    if (data.containsKey('preis_pro_takt_cent')) {
      context.handle(
        _preisProTaktCentMeta,
        preisProTaktCent.isAcceptableOrUnknown(
          data['preis_pro_takt_cent']!,
          _preisProTaktCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preisProTaktCentMeta);
    }
    if (data.containsKey('waehrung')) {
      context.handle(
        _waehrungMeta,
        waehrung.isAcceptableOrUnknown(data['waehrung']!, _waehrungMeta),
      );
    }
    if (data.containsKey('gueltig_von')) {
      context.handle(
        _gueltigVonMeta,
        gueltigVon.isAcceptableOrUnknown(data['gueltig_von']!, _gueltigVonMeta),
      );
    } else if (isInserting) {
      context.missing(_gueltigVonMeta);
    }
    if (data.containsKey('gueltig_bis')) {
      context.handle(
        _gueltigBisMeta,
        gueltigBis.isAcceptableOrUnknown(data['gueltig_bis']!, _gueltigBisMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreissettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreissettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taktMinuten: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}takt_minuten'],
      )!,
      preisProTaktCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preis_pro_takt_cent'],
      )!,
      waehrung: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}waehrung'],
      )!,
      gueltigVon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gueltig_von'],
      )!,
      gueltigBis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gueltig_bis'],
      ),
    );
  }

  @override
  $PreissettingsTable createAlias(String alias) {
    return $PreissettingsTable(attachedDatabase, alias);
  }
}

class PreissettingRow extends DataClass implements Insertable<PreissettingRow> {
  final int id;
  final int taktMinuten;
  final int preisProTaktCent;
  final String waehrung;
  final String gueltigVon;
  final String? gueltigBis;
  const PreissettingRow({
    required this.id,
    required this.taktMinuten,
    required this.preisProTaktCent,
    required this.waehrung,
    required this.gueltigVon,
    this.gueltigBis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['takt_minuten'] = Variable<int>(taktMinuten);
    map['preis_pro_takt_cent'] = Variable<int>(preisProTaktCent);
    map['waehrung'] = Variable<String>(waehrung);
    map['gueltig_von'] = Variable<String>(gueltigVon);
    if (!nullToAbsent || gueltigBis != null) {
      map['gueltig_bis'] = Variable<String>(gueltigBis);
    }
    return map;
  }

  PreissettingsCompanion toCompanion(bool nullToAbsent) {
    return PreissettingsCompanion(
      id: Value(id),
      taktMinuten: Value(taktMinuten),
      preisProTaktCent: Value(preisProTaktCent),
      waehrung: Value(waehrung),
      gueltigVon: Value(gueltigVon),
      gueltigBis: gueltigBis == null && nullToAbsent
          ? const Value.absent()
          : Value(gueltigBis),
    );
  }

  factory PreissettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreissettingRow(
      id: serializer.fromJson<int>(json['id']),
      taktMinuten: serializer.fromJson<int>(json['taktMinuten']),
      preisProTaktCent: serializer.fromJson<int>(json['preisProTaktCent']),
      waehrung: serializer.fromJson<String>(json['waehrung']),
      gueltigVon: serializer.fromJson<String>(json['gueltigVon']),
      gueltigBis: serializer.fromJson<String?>(json['gueltigBis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taktMinuten': serializer.toJson<int>(taktMinuten),
      'preisProTaktCent': serializer.toJson<int>(preisProTaktCent),
      'waehrung': serializer.toJson<String>(waehrung),
      'gueltigVon': serializer.toJson<String>(gueltigVon),
      'gueltigBis': serializer.toJson<String?>(gueltigBis),
    };
  }

  PreissettingRow copyWith({
    int? id,
    int? taktMinuten,
    int? preisProTaktCent,
    String? waehrung,
    String? gueltigVon,
    Value<String?> gueltigBis = const Value.absent(),
  }) => PreissettingRow(
    id: id ?? this.id,
    taktMinuten: taktMinuten ?? this.taktMinuten,
    preisProTaktCent: preisProTaktCent ?? this.preisProTaktCent,
    waehrung: waehrung ?? this.waehrung,
    gueltigVon: gueltigVon ?? this.gueltigVon,
    gueltigBis: gueltigBis.present ? gueltigBis.value : this.gueltigBis,
  );
  PreissettingRow copyWithCompanion(PreissettingsCompanion data) {
    return PreissettingRow(
      id: data.id.present ? data.id.value : this.id,
      taktMinuten: data.taktMinuten.present
          ? data.taktMinuten.value
          : this.taktMinuten,
      preisProTaktCent: data.preisProTaktCent.present
          ? data.preisProTaktCent.value
          : this.preisProTaktCent,
      waehrung: data.waehrung.present ? data.waehrung.value : this.waehrung,
      gueltigVon: data.gueltigVon.present
          ? data.gueltigVon.value
          : this.gueltigVon,
      gueltigBis: data.gueltigBis.present
          ? data.gueltigBis.value
          : this.gueltigBis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreissettingRow(')
          ..write('id: $id, ')
          ..write('taktMinuten: $taktMinuten, ')
          ..write('preisProTaktCent: $preisProTaktCent, ')
          ..write('waehrung: $waehrung, ')
          ..write('gueltigVon: $gueltigVon, ')
          ..write('gueltigBis: $gueltigBis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taktMinuten,
    preisProTaktCent,
    waehrung,
    gueltigVon,
    gueltigBis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreissettingRow &&
          other.id == this.id &&
          other.taktMinuten == this.taktMinuten &&
          other.preisProTaktCent == this.preisProTaktCent &&
          other.waehrung == this.waehrung &&
          other.gueltigVon == this.gueltigVon &&
          other.gueltigBis == this.gueltigBis);
}

class PreissettingsCompanion extends UpdateCompanion<PreissettingRow> {
  final Value<int> id;
  final Value<int> taktMinuten;
  final Value<int> preisProTaktCent;
  final Value<String> waehrung;
  final Value<String> gueltigVon;
  final Value<String?> gueltigBis;
  const PreissettingsCompanion({
    this.id = const Value.absent(),
    this.taktMinuten = const Value.absent(),
    this.preisProTaktCent = const Value.absent(),
    this.waehrung = const Value.absent(),
    this.gueltigVon = const Value.absent(),
    this.gueltigBis = const Value.absent(),
  });
  PreissettingsCompanion.insert({
    this.id = const Value.absent(),
    required int taktMinuten,
    required int preisProTaktCent,
    this.waehrung = const Value.absent(),
    required String gueltigVon,
    this.gueltigBis = const Value.absent(),
  }) : taktMinuten = Value(taktMinuten),
       preisProTaktCent = Value(preisProTaktCent),
       gueltigVon = Value(gueltigVon);
  static Insertable<PreissettingRow> custom({
    Expression<int>? id,
    Expression<int>? taktMinuten,
    Expression<int>? preisProTaktCent,
    Expression<String>? waehrung,
    Expression<String>? gueltigVon,
    Expression<String>? gueltigBis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taktMinuten != null) 'takt_minuten': taktMinuten,
      if (preisProTaktCent != null) 'preis_pro_takt_cent': preisProTaktCent,
      if (waehrung != null) 'waehrung': waehrung,
      if (gueltigVon != null) 'gueltig_von': gueltigVon,
      if (gueltigBis != null) 'gueltig_bis': gueltigBis,
    });
  }

  PreissettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? taktMinuten,
    Value<int>? preisProTaktCent,
    Value<String>? waehrung,
    Value<String>? gueltigVon,
    Value<String?>? gueltigBis,
  }) {
    return PreissettingsCompanion(
      id: id ?? this.id,
      taktMinuten: taktMinuten ?? this.taktMinuten,
      preisProTaktCent: preisProTaktCent ?? this.preisProTaktCent,
      waehrung: waehrung ?? this.waehrung,
      gueltigVon: gueltigVon ?? this.gueltigVon,
      gueltigBis: gueltigBis ?? this.gueltigBis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taktMinuten.present) {
      map['takt_minuten'] = Variable<int>(taktMinuten.value);
    }
    if (preisProTaktCent.present) {
      map['preis_pro_takt_cent'] = Variable<int>(preisProTaktCent.value);
    }
    if (waehrung.present) {
      map['waehrung'] = Variable<String>(waehrung.value);
    }
    if (gueltigVon.present) {
      map['gueltig_von'] = Variable<String>(gueltigVon.value);
    }
    if (gueltigBis.present) {
      map['gueltig_bis'] = Variable<String>(gueltigBis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreissettingsCompanion(')
          ..write('id: $id, ')
          ..write('taktMinuten: $taktMinuten, ')
          ..write('preisProTaktCent: $preisProTaktCent, ')
          ..write('waehrung: $waehrung, ')
          ..write('gueltigVon: $gueltigVon, ')
          ..write('gueltigBis: $gueltigBis')
          ..write(')'))
        .toString();
  }
}

class $VerkaufszeitenTable extends Verkaufszeiten
    with TableInfo<$VerkaufszeitenTable, VerkaufszeitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerkaufszeitenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wochentagMeta = const VerificationMeta(
    'wochentag',
  );
  @override
  late final GeneratedColumn<int> wochentag = GeneratedColumn<int>(
    'wochentag',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (wochentag BETWEEN 1 AND 7)',
  );
  static const VerificationMeta _beginnMeta = const VerificationMeta('beginn');
  @override
  late final GeneratedColumn<String> beginn = GeneratedColumn<String>(
    'beginn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (beginn GLOB \'[0-2][0-9]:[0-5][0-9]\' AND beginn < \'24:00\' OR beginn = \'24:00\')',
  );
  static const VerificationMeta _endeMeta = const VerificationMeta('ende');
  @override
  late final GeneratedColumn<String> ende = GeneratedColumn<String>(
    'ende',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (ende GLOB \'[0-2][0-9]:[0-5][0-9]\' AND ende < \'24:00\' OR ende = \'24:00\')',
  );
  static const VerificationMeta _gueltigVonMeta = const VerificationMeta(
    'gueltigVon',
  );
  @override
  late final GeneratedColumn<String> gueltigVon = GeneratedColumn<String>(
    'gueltig_von',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gueltigBisMeta = const VerificationMeta(
    'gueltigBis',
  );
  @override
  late final GeneratedColumn<String> gueltigBis = GeneratedColumn<String>(
    'gueltig_bis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wochentag,
    beginn,
    ende,
    gueltigVon,
    gueltigBis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verkaufszeit';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerkaufszeitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wochentag')) {
      context.handle(
        _wochentagMeta,
        wochentag.isAcceptableOrUnknown(data['wochentag']!, _wochentagMeta),
      );
    } else if (isInserting) {
      context.missing(_wochentagMeta);
    }
    if (data.containsKey('beginn')) {
      context.handle(
        _beginnMeta,
        beginn.isAcceptableOrUnknown(data['beginn']!, _beginnMeta),
      );
    } else if (isInserting) {
      context.missing(_beginnMeta);
    }
    if (data.containsKey('ende')) {
      context.handle(
        _endeMeta,
        ende.isAcceptableOrUnknown(data['ende']!, _endeMeta),
      );
    } else if (isInserting) {
      context.missing(_endeMeta);
    }
    if (data.containsKey('gueltig_von')) {
      context.handle(
        _gueltigVonMeta,
        gueltigVon.isAcceptableOrUnknown(data['gueltig_von']!, _gueltigVonMeta),
      );
    }
    if (data.containsKey('gueltig_bis')) {
      context.handle(
        _gueltigBisMeta,
        gueltigBis.isAcceptableOrUnknown(data['gueltig_bis']!, _gueltigBisMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerkaufszeitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerkaufszeitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wochentag: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wochentag'],
      )!,
      beginn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beginn'],
      )!,
      ende: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ende'],
      )!,
      gueltigVon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gueltig_von'],
      ),
      gueltigBis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gueltig_bis'],
      ),
    );
  }

  @override
  $VerkaufszeitenTable createAlias(String alias) {
    return $VerkaufszeitenTable(attachedDatabase, alias);
  }
}

class VerkaufszeitRow extends DataClass implements Insertable<VerkaufszeitRow> {
  final int id;
  final int wochentag;
  final String beginn;
  final String ende;
  final String? gueltigVon;
  final String? gueltigBis;
  const VerkaufszeitRow({
    required this.id,
    required this.wochentag,
    required this.beginn,
    required this.ende,
    this.gueltigVon,
    this.gueltigBis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wochentag'] = Variable<int>(wochentag);
    map['beginn'] = Variable<String>(beginn);
    map['ende'] = Variable<String>(ende);
    if (!nullToAbsent || gueltigVon != null) {
      map['gueltig_von'] = Variable<String>(gueltigVon);
    }
    if (!nullToAbsent || gueltigBis != null) {
      map['gueltig_bis'] = Variable<String>(gueltigBis);
    }
    return map;
  }

  VerkaufszeitenCompanion toCompanion(bool nullToAbsent) {
    return VerkaufszeitenCompanion(
      id: Value(id),
      wochentag: Value(wochentag),
      beginn: Value(beginn),
      ende: Value(ende),
      gueltigVon: gueltigVon == null && nullToAbsent
          ? const Value.absent()
          : Value(gueltigVon),
      gueltigBis: gueltigBis == null && nullToAbsent
          ? const Value.absent()
          : Value(gueltigBis),
    );
  }

  factory VerkaufszeitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerkaufszeitRow(
      id: serializer.fromJson<int>(json['id']),
      wochentag: serializer.fromJson<int>(json['wochentag']),
      beginn: serializer.fromJson<String>(json['beginn']),
      ende: serializer.fromJson<String>(json['ende']),
      gueltigVon: serializer.fromJson<String?>(json['gueltigVon']),
      gueltigBis: serializer.fromJson<String?>(json['gueltigBis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wochentag': serializer.toJson<int>(wochentag),
      'beginn': serializer.toJson<String>(beginn),
      'ende': serializer.toJson<String>(ende),
      'gueltigVon': serializer.toJson<String?>(gueltigVon),
      'gueltigBis': serializer.toJson<String?>(gueltigBis),
    };
  }

  VerkaufszeitRow copyWith({
    int? id,
    int? wochentag,
    String? beginn,
    String? ende,
    Value<String?> gueltigVon = const Value.absent(),
    Value<String?> gueltigBis = const Value.absent(),
  }) => VerkaufszeitRow(
    id: id ?? this.id,
    wochentag: wochentag ?? this.wochentag,
    beginn: beginn ?? this.beginn,
    ende: ende ?? this.ende,
    gueltigVon: gueltigVon.present ? gueltigVon.value : this.gueltigVon,
    gueltigBis: gueltigBis.present ? gueltigBis.value : this.gueltigBis,
  );
  VerkaufszeitRow copyWithCompanion(VerkaufszeitenCompanion data) {
    return VerkaufszeitRow(
      id: data.id.present ? data.id.value : this.id,
      wochentag: data.wochentag.present ? data.wochentag.value : this.wochentag,
      beginn: data.beginn.present ? data.beginn.value : this.beginn,
      ende: data.ende.present ? data.ende.value : this.ende,
      gueltigVon: data.gueltigVon.present
          ? data.gueltigVon.value
          : this.gueltigVon,
      gueltigBis: data.gueltigBis.present
          ? data.gueltigBis.value
          : this.gueltigBis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerkaufszeitRow(')
          ..write('id: $id, ')
          ..write('wochentag: $wochentag, ')
          ..write('beginn: $beginn, ')
          ..write('ende: $ende, ')
          ..write('gueltigVon: $gueltigVon, ')
          ..write('gueltigBis: $gueltigBis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, wochentag, beginn, ende, gueltigVon, gueltigBis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerkaufszeitRow &&
          other.id == this.id &&
          other.wochentag == this.wochentag &&
          other.beginn == this.beginn &&
          other.ende == this.ende &&
          other.gueltigVon == this.gueltigVon &&
          other.gueltigBis == this.gueltigBis);
}

class VerkaufszeitenCompanion extends UpdateCompanion<VerkaufszeitRow> {
  final Value<int> id;
  final Value<int> wochentag;
  final Value<String> beginn;
  final Value<String> ende;
  final Value<String?> gueltigVon;
  final Value<String?> gueltigBis;
  const VerkaufszeitenCompanion({
    this.id = const Value.absent(),
    this.wochentag = const Value.absent(),
    this.beginn = const Value.absent(),
    this.ende = const Value.absent(),
    this.gueltigVon = const Value.absent(),
    this.gueltigBis = const Value.absent(),
  });
  VerkaufszeitenCompanion.insert({
    this.id = const Value.absent(),
    required int wochentag,
    required String beginn,
    required String ende,
    this.gueltigVon = const Value.absent(),
    this.gueltigBis = const Value.absent(),
  }) : wochentag = Value(wochentag),
       beginn = Value(beginn),
       ende = Value(ende);
  static Insertable<VerkaufszeitRow> custom({
    Expression<int>? id,
    Expression<int>? wochentag,
    Expression<String>? beginn,
    Expression<String>? ende,
    Expression<String>? gueltigVon,
    Expression<String>? gueltigBis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wochentag != null) 'wochentag': wochentag,
      if (beginn != null) 'beginn': beginn,
      if (ende != null) 'ende': ende,
      if (gueltigVon != null) 'gueltig_von': gueltigVon,
      if (gueltigBis != null) 'gueltig_bis': gueltigBis,
    });
  }

  VerkaufszeitenCompanion copyWith({
    Value<int>? id,
    Value<int>? wochentag,
    Value<String>? beginn,
    Value<String>? ende,
    Value<String?>? gueltigVon,
    Value<String?>? gueltigBis,
  }) {
    return VerkaufszeitenCompanion(
      id: id ?? this.id,
      wochentag: wochentag ?? this.wochentag,
      beginn: beginn ?? this.beginn,
      ende: ende ?? this.ende,
      gueltigVon: gueltigVon ?? this.gueltigVon,
      gueltigBis: gueltigBis ?? this.gueltigBis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wochentag.present) {
      map['wochentag'] = Variable<int>(wochentag.value);
    }
    if (beginn.present) {
      map['beginn'] = Variable<String>(beginn.value);
    }
    if (ende.present) {
      map['ende'] = Variable<String>(ende.value);
    }
    if (gueltigVon.present) {
      map['gueltig_von'] = Variable<String>(gueltigVon.value);
    }
    if (gueltigBis.present) {
      map['gueltig_bis'] = Variable<String>(gueltigBis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerkaufszeitenCompanion(')
          ..write('id: $id, ')
          ..write('wochentag: $wochentag, ')
          ..write('beginn: $beginn, ')
          ..write('ende: $ende, ')
          ..write('gueltigVon: $gueltigVon, ')
          ..write('gueltigBis: $gueltigBis')
          ..write(')'))
        .toString();
  }
}

class $ParkzonenTable extends Parkzonen
    with TableInfo<$ParkzonenTable, ParkzoneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParkzonenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parkzonen';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParkzoneRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParkzoneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParkzoneRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ParkzonenTable createAlias(String alias) {
    return $ParkzonenTable(attachedDatabase, alias);
  }
}

class ParkzoneRow extends DataClass implements Insertable<ParkzoneRow> {
  final int id;
  final String name;
  const ParkzoneRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ParkzonenCompanion toCompanion(bool nullToAbsent) {
    return ParkzonenCompanion(id: Value(id), name: Value(name));
  }

  factory ParkzoneRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParkzoneRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ParkzoneRow copyWith({int? id, String? name}) =>
      ParkzoneRow(id: id ?? this.id, name: name ?? this.name);
  ParkzoneRow copyWithCompanion(ParkzonenCompanion data) {
    return ParkzoneRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParkzoneRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParkzoneRow && other.id == this.id && other.name == this.name);
}

class ParkzonenCompanion extends UpdateCompanion<ParkzoneRow> {
  final Value<int> id;
  final Value<String> name;
  const ParkzonenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ParkzonenCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ParkzoneRow> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ParkzonenCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ParkzonenCompanion(id: id ?? this.id, name: name ?? this.name);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParkzonenCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $TelemetrienTable extends Telemetrien
    with TableInfo<$TelemetrienTable, TelemetrieRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelemetrienTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _maschineIdMeta = const VerificationMeta(
    'maschineId',
  );
  @override
  late final GeneratedColumn<int> maschineId = GeneratedColumn<int>(
    'maschine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES maschine (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stromverbrauchWattMeta =
      const VerificationMeta('stromverbrauchWatt');
  @override
  late final GeneratedColumn<int> stromverbrauchWatt = GeneratedColumn<int>(
    'stromverbrauch_watt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (stromverbrauch_watt >= 0)',
  );
  static const VerificationMeta _batteriestandProzentMeta =
      const VerificationMeta('batteriestandProzent');
  @override
  late final GeneratedColumn<int> batteriestandProzent = GeneratedColumn<int>(
    'batteriestand_prozent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (batteriestand_prozent BETWEEN 0 AND 100)',
  );
  static const VerificationMeta _signalStaerkeDbmMeta = const VerificationMeta(
    'signalStaerkeDbm',
  );
  @override
  late final GeneratedColumn<int> signalStaerkeDbm = GeneratedColumn<int>(
    'signal_staerke_dbm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (signal_staerke_dbm <= 0)',
  );
  static const VerificationMeta _packetlossProzentMeta = const VerificationMeta(
    'packetlossProzent',
  );
  @override
  late final GeneratedColumn<int> packetlossProzent = GeneratedColumn<int>(
    'packetloss_prozent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (packetloss_prozent BETWEEN 0 AND 100)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    maschineId,
    timestamp,
    stromverbrauchWatt,
    batteriestandProzent,
    signalStaerkeDbm,
    packetlossProzent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telemetrie';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelemetrieRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('maschine_id')) {
      context.handle(
        _maschineIdMeta,
        maschineId.isAcceptableOrUnknown(data['maschine_id']!, _maschineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_maschineIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('stromverbrauch_watt')) {
      context.handle(
        _stromverbrauchWattMeta,
        stromverbrauchWatt.isAcceptableOrUnknown(
          data['stromverbrauch_watt']!,
          _stromverbrauchWattMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stromverbrauchWattMeta);
    }
    if (data.containsKey('batteriestand_prozent')) {
      context.handle(
        _batteriestandProzentMeta,
        batteriestandProzent.isAcceptableOrUnknown(
          data['batteriestand_prozent']!,
          _batteriestandProzentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batteriestandProzentMeta);
    }
    if (data.containsKey('signal_staerke_dbm')) {
      context.handle(
        _signalStaerkeDbmMeta,
        signalStaerkeDbm.isAcceptableOrUnknown(
          data['signal_staerke_dbm']!,
          _signalStaerkeDbmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signalStaerkeDbmMeta);
    }
    if (data.containsKey('packetloss_prozent')) {
      context.handle(
        _packetlossProzentMeta,
        packetlossProzent.isAcceptableOrUnknown(
          data['packetloss_prozent']!,
          _packetlossProzentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packetlossProzentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelemetrieRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelemetrieRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      maschineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maschine_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
      stromverbrauchWatt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stromverbrauch_watt'],
      )!,
      batteriestandProzent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batteriestand_prozent'],
      )!,
      signalStaerkeDbm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}signal_staerke_dbm'],
      )!,
      packetlossProzent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}packetloss_prozent'],
      )!,
    );
  }

  @override
  $TelemetrienTable createAlias(String alias) {
    return $TelemetrienTable(attachedDatabase, alias);
  }
}

class TelemetrieRow extends DataClass implements Insertable<TelemetrieRow> {
  final int id;
  final int maschineId;
  final String timestamp;
  final int stromverbrauchWatt;
  final int batteriestandProzent;
  final int signalStaerkeDbm;
  final int packetlossProzent;
  const TelemetrieRow({
    required this.id,
    required this.maschineId,
    required this.timestamp,
    required this.stromverbrauchWatt,
    required this.batteriestandProzent,
    required this.signalStaerkeDbm,
    required this.packetlossProzent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['maschine_id'] = Variable<int>(maschineId);
    map['timestamp'] = Variable<String>(timestamp);
    map['stromverbrauch_watt'] = Variable<int>(stromverbrauchWatt);
    map['batteriestand_prozent'] = Variable<int>(batteriestandProzent);
    map['signal_staerke_dbm'] = Variable<int>(signalStaerkeDbm);
    map['packetloss_prozent'] = Variable<int>(packetlossProzent);
    return map;
  }

  TelemetrienCompanion toCompanion(bool nullToAbsent) {
    return TelemetrienCompanion(
      id: Value(id),
      maschineId: Value(maschineId),
      timestamp: Value(timestamp),
      stromverbrauchWatt: Value(stromverbrauchWatt),
      batteriestandProzent: Value(batteriestandProzent),
      signalStaerkeDbm: Value(signalStaerkeDbm),
      packetlossProzent: Value(packetlossProzent),
    );
  }

  factory TelemetrieRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelemetrieRow(
      id: serializer.fromJson<int>(json['id']),
      maschineId: serializer.fromJson<int>(json['maschineId']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      stromverbrauchWatt: serializer.fromJson<int>(json['stromverbrauchWatt']),
      batteriestandProzent: serializer.fromJson<int>(
        json['batteriestandProzent'],
      ),
      signalStaerkeDbm: serializer.fromJson<int>(json['signalStaerkeDbm']),
      packetlossProzent: serializer.fromJson<int>(json['packetlossProzent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maschineId': serializer.toJson<int>(maschineId),
      'timestamp': serializer.toJson<String>(timestamp),
      'stromverbrauchWatt': serializer.toJson<int>(stromverbrauchWatt),
      'batteriestandProzent': serializer.toJson<int>(batteriestandProzent),
      'signalStaerkeDbm': serializer.toJson<int>(signalStaerkeDbm),
      'packetlossProzent': serializer.toJson<int>(packetlossProzent),
    };
  }

  TelemetrieRow copyWith({
    int? id,
    int? maschineId,
    String? timestamp,
    int? stromverbrauchWatt,
    int? batteriestandProzent,
    int? signalStaerkeDbm,
    int? packetlossProzent,
  }) => TelemetrieRow(
    id: id ?? this.id,
    maschineId: maschineId ?? this.maschineId,
    timestamp: timestamp ?? this.timestamp,
    stromverbrauchWatt: stromverbrauchWatt ?? this.stromverbrauchWatt,
    batteriestandProzent: batteriestandProzent ?? this.batteriestandProzent,
    signalStaerkeDbm: signalStaerkeDbm ?? this.signalStaerkeDbm,
    packetlossProzent: packetlossProzent ?? this.packetlossProzent,
  );
  TelemetrieRow copyWithCompanion(TelemetrienCompanion data) {
    return TelemetrieRow(
      id: data.id.present ? data.id.value : this.id,
      maschineId: data.maschineId.present
          ? data.maschineId.value
          : this.maschineId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      stromverbrauchWatt: data.stromverbrauchWatt.present
          ? data.stromverbrauchWatt.value
          : this.stromverbrauchWatt,
      batteriestandProzent: data.batteriestandProzent.present
          ? data.batteriestandProzent.value
          : this.batteriestandProzent,
      signalStaerkeDbm: data.signalStaerkeDbm.present
          ? data.signalStaerkeDbm.value
          : this.signalStaerkeDbm,
      packetlossProzent: data.packetlossProzent.present
          ? data.packetlossProzent.value
          : this.packetlossProzent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelemetrieRow(')
          ..write('id: $id, ')
          ..write('maschineId: $maschineId, ')
          ..write('timestamp: $timestamp, ')
          ..write('stromverbrauchWatt: $stromverbrauchWatt, ')
          ..write('batteriestandProzent: $batteriestandProzent, ')
          ..write('signalStaerkeDbm: $signalStaerkeDbm, ')
          ..write('packetlossProzent: $packetlossProzent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    maschineId,
    timestamp,
    stromverbrauchWatt,
    batteriestandProzent,
    signalStaerkeDbm,
    packetlossProzent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelemetrieRow &&
          other.id == this.id &&
          other.maschineId == this.maschineId &&
          other.timestamp == this.timestamp &&
          other.stromverbrauchWatt == this.stromverbrauchWatt &&
          other.batteriestandProzent == this.batteriestandProzent &&
          other.signalStaerkeDbm == this.signalStaerkeDbm &&
          other.packetlossProzent == this.packetlossProzent);
}

class TelemetrienCompanion extends UpdateCompanion<TelemetrieRow> {
  final Value<int> id;
  final Value<int> maschineId;
  final Value<String> timestamp;
  final Value<int> stromverbrauchWatt;
  final Value<int> batteriestandProzent;
  final Value<int> signalStaerkeDbm;
  final Value<int> packetlossProzent;
  const TelemetrienCompanion({
    this.id = const Value.absent(),
    this.maschineId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.stromverbrauchWatt = const Value.absent(),
    this.batteriestandProzent = const Value.absent(),
    this.signalStaerkeDbm = const Value.absent(),
    this.packetlossProzent = const Value.absent(),
  });
  TelemetrienCompanion.insert({
    this.id = const Value.absent(),
    required int maschineId,
    required String timestamp,
    required int stromverbrauchWatt,
    required int batteriestandProzent,
    required int signalStaerkeDbm,
    required int packetlossProzent,
  }) : maschineId = Value(maschineId),
       timestamp = Value(timestamp),
       stromverbrauchWatt = Value(stromverbrauchWatt),
       batteriestandProzent = Value(batteriestandProzent),
       signalStaerkeDbm = Value(signalStaerkeDbm),
       packetlossProzent = Value(packetlossProzent);
  static Insertable<TelemetrieRow> custom({
    Expression<int>? id,
    Expression<int>? maschineId,
    Expression<String>? timestamp,
    Expression<int>? stromverbrauchWatt,
    Expression<int>? batteriestandProzent,
    Expression<int>? signalStaerkeDbm,
    Expression<int>? packetlossProzent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maschineId != null) 'maschine_id': maschineId,
      if (timestamp != null) 'timestamp': timestamp,
      if (stromverbrauchWatt != null) 'stromverbrauch_watt': stromverbrauchWatt,
      if (batteriestandProzent != null)
        'batteriestand_prozent': batteriestandProzent,
      if (signalStaerkeDbm != null) 'signal_staerke_dbm': signalStaerkeDbm,
      if (packetlossProzent != null) 'packetloss_prozent': packetlossProzent,
    });
  }

  TelemetrienCompanion copyWith({
    Value<int>? id,
    Value<int>? maschineId,
    Value<String>? timestamp,
    Value<int>? stromverbrauchWatt,
    Value<int>? batteriestandProzent,
    Value<int>? signalStaerkeDbm,
    Value<int>? packetlossProzent,
  }) {
    return TelemetrienCompanion(
      id: id ?? this.id,
      maschineId: maschineId ?? this.maschineId,
      timestamp: timestamp ?? this.timestamp,
      stromverbrauchWatt: stromverbrauchWatt ?? this.stromverbrauchWatt,
      batteriestandProzent: batteriestandProzent ?? this.batteriestandProzent,
      signalStaerkeDbm: signalStaerkeDbm ?? this.signalStaerkeDbm,
      packetlossProzent: packetlossProzent ?? this.packetlossProzent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maschineId.present) {
      map['maschine_id'] = Variable<int>(maschineId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (stromverbrauchWatt.present) {
      map['stromverbrauch_watt'] = Variable<int>(stromverbrauchWatt.value);
    }
    if (batteriestandProzent.present) {
      map['batteriestand_prozent'] = Variable<int>(batteriestandProzent.value);
    }
    if (signalStaerkeDbm.present) {
      map['signal_staerke_dbm'] = Variable<int>(signalStaerkeDbm.value);
    }
    if (packetlossProzent.present) {
      map['packetloss_prozent'] = Variable<int>(packetlossProzent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelemetrienCompanion(')
          ..write('id: $id, ')
          ..write('maschineId: $maschineId, ')
          ..write('timestamp: $timestamp, ')
          ..write('stromverbrauchWatt: $stromverbrauchWatt, ')
          ..write('batteriestandProzent: $batteriestandProzent, ')
          ..write('signalStaerkeDbm: $signalStaerkeDbm, ')
          ..write('packetlossProzent: $packetlossProzent')
          ..write(')'))
        .toString();
  }
}

class $SchemaVersionenTable extends SchemaVersionen
    with TableInfo<$SchemaVersionenTable, SchemaVersionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchemaVersionenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<String> appliedAt = GeneratedColumn<String>(
    'applied_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [version, name, appliedAt, checksum];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schema_version';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchemaVersionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_appliedAtMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {version};
  @override
  SchemaVersionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchemaVersionRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applied_at'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      )!,
    );
  }

  @override
  $SchemaVersionenTable createAlias(String alias) {
    return $SchemaVersionenTable(attachedDatabase, alias);
  }
}

class SchemaVersionRow extends DataClass
    implements Insertable<SchemaVersionRow> {
  final int version;
  final String name;
  final String appliedAt;
  final String checksum;
  const SchemaVersionRow({
    required this.version,
    required this.name,
    required this.appliedAt,
    required this.checksum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['name'] = Variable<String>(name);
    map['applied_at'] = Variable<String>(appliedAt);
    map['checksum'] = Variable<String>(checksum);
    return map;
  }

  SchemaVersionenCompanion toCompanion(bool nullToAbsent) {
    return SchemaVersionenCompanion(
      version: Value(version),
      name: Value(name),
      appliedAt: Value(appliedAt),
      checksum: Value(checksum),
    );
  }

  factory SchemaVersionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchemaVersionRow(
      version: serializer.fromJson<int>(json['version']),
      name: serializer.fromJson<String>(json['name']),
      appliedAt: serializer.fromJson<String>(json['appliedAt']),
      checksum: serializer.fromJson<String>(json['checksum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'name': serializer.toJson<String>(name),
      'appliedAt': serializer.toJson<String>(appliedAt),
      'checksum': serializer.toJson<String>(checksum),
    };
  }

  SchemaVersionRow copyWith({
    int? version,
    String? name,
    String? appliedAt,
    String? checksum,
  }) => SchemaVersionRow(
    version: version ?? this.version,
    name: name ?? this.name,
    appliedAt: appliedAt ?? this.appliedAt,
    checksum: checksum ?? this.checksum,
  );
  SchemaVersionRow copyWithCompanion(SchemaVersionenCompanion data) {
    return SchemaVersionRow(
      version: data.version.present ? data.version.value : this.version,
      name: data.name.present ? data.name.value : this.name,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchemaVersionRow(')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('checksum: $checksum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(version, name, appliedAt, checksum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchemaVersionRow &&
          other.version == this.version &&
          other.name == this.name &&
          other.appliedAt == this.appliedAt &&
          other.checksum == this.checksum);
}

class SchemaVersionenCompanion extends UpdateCompanion<SchemaVersionRow> {
  final Value<int> version;
  final Value<String> name;
  final Value<String> appliedAt;
  final Value<String> checksum;
  const SchemaVersionenCompanion({
    this.version = const Value.absent(),
    this.name = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.checksum = const Value.absent(),
  });
  SchemaVersionenCompanion.insert({
    this.version = const Value.absent(),
    required String name,
    required String appliedAt,
    required String checksum,
  }) : name = Value(name),
       appliedAt = Value(appliedAt),
       checksum = Value(checksum);
  static Insertable<SchemaVersionRow> custom({
    Expression<int>? version,
    Expression<String>? name,
    Expression<String>? appliedAt,
    Expression<String>? checksum,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (name != null) 'name': name,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (checksum != null) 'checksum': checksum,
    });
  }

  SchemaVersionenCompanion copyWith({
    Value<int>? version,
    Value<String>? name,
    Value<String>? appliedAt,
    Value<String>? checksum,
  }) {
    return SchemaVersionenCompanion(
      version: version ?? this.version,
      name: name ?? this.name,
      appliedAt: appliedAt ?? this.appliedAt,
      checksum: checksum ?? this.checksum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<String>(appliedAt.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchemaVersionenCompanion(')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('checksum: $checksum')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MaschinenTable maschinen = $MaschinenTable(this);
  late final $VerkaeufeTable verkaeufe = $VerkaeufeTable(this);
  late final $PreissettingsTable preissettings = $PreissettingsTable(this);
  late final $VerkaufszeitenTable verkaufszeiten = $VerkaufszeitenTable(this);
  late final $ParkzonenTable parkzonen = $ParkzonenTable(this);
  late final $TelemetrienTable telemetrien = $TelemetrienTable(this);
  late final $SchemaVersionenTable schemaVersionen = $SchemaVersionenTable(
    this,
  );
  late final Index idxVerkaeufeMaschineZeit = Index(
    'idx_verkaeufe_maschine_zeit',
    'CREATE INDEX idx_verkaeufe_maschine_zeit ON verkaeufe (maschine_id, timestamp)',
  );
  late final Index idxTelemetrieMaschineZeit = Index(
    'idx_telemetrie_maschine_zeit',
    'CREATE INDEX idx_telemetrie_maschine_zeit ON telemetrie (maschine_id, timestamp)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    maschinen,
    verkaeufe,
    preissettings,
    verkaufszeiten,
    parkzonen,
    telemetrien,
    schemaVersionen,
    idxVerkaeufeMaschineZeit,
    idxTelemetrieMaschineZeit,
  ];
}

typedef $$MaschinenTableCreateCompanionBuilder =
    MaschinenCompanion Function({
      Value<int> id,
      required String geraeteId,
      required String standort,
      required String status,
      required String kundennummer,
    });
typedef $$MaschinenTableUpdateCompanionBuilder =
    MaschinenCompanion Function({
      Value<int> id,
      Value<String> geraeteId,
      Value<String> standort,
      Value<String> status,
      Value<String> kundennummer,
    });

final class $$MaschinenTableReferences
    extends BaseReferences<_$AppDatabase, $MaschinenTable, MaschineRow> {
  $$MaschinenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VerkaeufeTable, List<VerkaufRow>>
  _verkaeufeRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.verkaeufe,
    aliasName: 'maschine__id__verkaeufe__maschine_id',
  );

  $$VerkaeufeTableProcessedTableManager get verkaeufeRefs {
    final manager = $$VerkaeufeTableTableManager(
      $_db,
      $_db.verkaeufe,
    ).filter((f) => f.maschineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verkaeufeRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TelemetrienTable, List<TelemetrieRow>>
  _telemetrienRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.telemetrien,
    aliasName: 'maschine__id__telemetrie__maschine_id',
  );

  $$TelemetrienTableProcessedTableManager get telemetrienRefs {
    final manager = $$TelemetrienTableTableManager(
      $_db,
      $_db.telemetrien,
    ).filter((f) => f.maschineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_telemetrienRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MaschinenTableFilterComposer
    extends Composer<_$AppDatabase, $MaschinenTable> {
  $$MaschinenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geraeteId => $composableBuilder(
    column: $table.geraeteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get standort => $composableBuilder(
    column: $table.standort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kundennummer => $composableBuilder(
    column: $table.kundennummer,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> verkaeufeRefs(
    Expression<bool> Function($$VerkaeufeTableFilterComposer f) f,
  ) {
    final $$VerkaeufeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verkaeufe,
      getReferencedColumn: (t) => t.maschineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerkaeufeTableFilterComposer(
            $db: $db,
            $table: $db.verkaeufe,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> telemetrienRefs(
    Expression<bool> Function($$TelemetrienTableFilterComposer f) f,
  ) {
    final $$TelemetrienTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.telemetrien,
      getReferencedColumn: (t) => t.maschineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelemetrienTableFilterComposer(
            $db: $db,
            $table: $db.telemetrien,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaschinenTableOrderingComposer
    extends Composer<_$AppDatabase, $MaschinenTable> {
  $$MaschinenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geraeteId => $composableBuilder(
    column: $table.geraeteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get standort => $composableBuilder(
    column: $table.standort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kundennummer => $composableBuilder(
    column: $table.kundennummer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaschinenTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaschinenTable> {
  $$MaschinenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get geraeteId =>
      $composableBuilder(column: $table.geraeteId, builder: (column) => column);

  GeneratedColumn<String> get standort =>
      $composableBuilder(column: $table.standort, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get kundennummer => $composableBuilder(
    column: $table.kundennummer,
    builder: (column) => column,
  );

  Expression<T> verkaeufeRefs<T extends Object>(
    Expression<T> Function($$VerkaeufeTableAnnotationComposer a) f,
  ) {
    final $$VerkaeufeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verkaeufe,
      getReferencedColumn: (t) => t.maschineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerkaeufeTableAnnotationComposer(
            $db: $db,
            $table: $db.verkaeufe,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> telemetrienRefs<T extends Object>(
    Expression<T> Function($$TelemetrienTableAnnotationComposer a) f,
  ) {
    final $$TelemetrienTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.telemetrien,
      getReferencedColumn: (t) => t.maschineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelemetrienTableAnnotationComposer(
            $db: $db,
            $table: $db.telemetrien,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaschinenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaschinenTable,
          MaschineRow,
          $$MaschinenTableFilterComposer,
          $$MaschinenTableOrderingComposer,
          $$MaschinenTableAnnotationComposer,
          $$MaschinenTableCreateCompanionBuilder,
          $$MaschinenTableUpdateCompanionBuilder,
          (MaschineRow, $$MaschinenTableReferences),
          MaschineRow,
          PrefetchHooks Function({bool verkaeufeRefs, bool telemetrienRefs})
        > {
  $$MaschinenTableTableManager(_$AppDatabase db, $MaschinenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaschinenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaschinenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaschinenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> geraeteId = const Value.absent(),
                Value<String> standort = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> kundennummer = const Value.absent(),
              }) => MaschinenCompanion(
                id: id,
                geraeteId: geraeteId,
                standort: standort,
                status: status,
                kundennummer: kundennummer,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String geraeteId,
                required String standort,
                required String status,
                required String kundennummer,
              }) => MaschinenCompanion.insert(
                id: id,
                geraeteId: geraeteId,
                standort: standort,
                status: status,
                kundennummer: kundennummer,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MaschinenTable, MaschineRow>(table),
                  $$MaschinenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({verkaeufeRefs = false, telemetrienRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (verkaeufeRefs) db.verkaeufe,
                    if (telemetrienRefs) db.telemetrien,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (verkaeufeRefs)
                        await $_getPrefetchedData<
                          MaschineRow,
                          $MaschinenTable,
                          VerkaufRow
                        >(
                          currentTable: table,
                          referencedTable: $$MaschinenTableReferences
                              ._verkaeufeRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaschinenTableReferences(
                                db,
                                table,
                                p0,
                              ).verkaeufeRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.maschineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (telemetrienRefs)
                        await $_getPrefetchedData<
                          MaschineRow,
                          $MaschinenTable,
                          TelemetrieRow
                        >(
                          currentTable: table,
                          referencedTable: $$MaschinenTableReferences
                              ._telemetrienRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaschinenTableReferences(
                                db,
                                table,
                                p0,
                              ).telemetrienRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.maschineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MaschinenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaschinenTable,
      MaschineRow,
      $$MaschinenTableFilterComposer,
      $$MaschinenTableOrderingComposer,
      $$MaschinenTableAnnotationComposer,
      $$MaschinenTableCreateCompanionBuilder,
      $$MaschinenTableUpdateCompanionBuilder,
      (MaschineRow, $$MaschinenTableReferences),
      MaschineRow,
      PrefetchHooks Function({bool verkaeufeRefs, bool telemetrienRefs})
    >;
typedef $$VerkaeufeTableCreateCompanionBuilder =
    VerkaeufeCompanion Function({
      Value<int> id,
      required int maschineId,
      required String timestamp,
      required int parkdauerMinuten,
      required int betragCent,
      required String zahlungsart,
      required int belegnummer,
      Value<String?> kennzeichen,
    });
typedef $$VerkaeufeTableUpdateCompanionBuilder =
    VerkaeufeCompanion Function({
      Value<int> id,
      Value<int> maschineId,
      Value<String> timestamp,
      Value<int> parkdauerMinuten,
      Value<int> betragCent,
      Value<String> zahlungsart,
      Value<int> belegnummer,
      Value<String?> kennzeichen,
    });

final class $$VerkaeufeTableReferences
    extends BaseReferences<_$AppDatabase, $VerkaeufeTable, VerkaufRow> {
  $$VerkaeufeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MaschinenTable _maschineIdTable(_$AppDatabase db) =>
      db.maschinen.createAlias('verkaeufe__maschine_id__maschine__id');

  $$MaschinenTableProcessedTableManager get maschineId {
    final $_column = $_itemColumn<int>('maschine_id')!;

    final manager = $$MaschinenTableTableManager(
      $_db,
      $_db.maschinen,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_maschineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VerkaeufeTableFilterComposer
    extends Composer<_$AppDatabase, $VerkaeufeTable> {
  $$VerkaeufeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parkdauerMinuten => $composableBuilder(
    column: $table.parkdauerMinuten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get betragCent => $composableBuilder(
    column: $table.betragCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zahlungsart => $composableBuilder(
    column: $table.zahlungsart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get belegnummer => $composableBuilder(
    column: $table.belegnummer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kennzeichen => $composableBuilder(
    column: $table.kennzeichen,
    builder: (column) => ColumnFilters(column),
  );

  $$MaschinenTableFilterComposer get maschineId {
    final $$MaschinenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maschineId,
      referencedTable: $db.maschinen,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaschinenTableFilterComposer(
            $db: $db,
            $table: $db.maschinen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerkaeufeTableOrderingComposer
    extends Composer<_$AppDatabase, $VerkaeufeTable> {
  $$VerkaeufeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parkdauerMinuten => $composableBuilder(
    column: $table.parkdauerMinuten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get betragCent => $composableBuilder(
    column: $table.betragCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zahlungsart => $composableBuilder(
    column: $table.zahlungsart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get belegnummer => $composableBuilder(
    column: $table.belegnummer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kennzeichen => $composableBuilder(
    column: $table.kennzeichen,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaschinenTableOrderingComposer get maschineId {
    final $$MaschinenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maschineId,
      referencedTable: $db.maschinen,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaschinenTableOrderingComposer(
            $db: $db,
            $table: $db.maschinen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerkaeufeTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerkaeufeTable> {
  $$VerkaeufeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get parkdauerMinuten => $composableBuilder(
    column: $table.parkdauerMinuten,
    builder: (column) => column,
  );

  GeneratedColumn<int> get betragCent => $composableBuilder(
    column: $table.betragCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get zahlungsart => $composableBuilder(
    column: $table.zahlungsart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get belegnummer => $composableBuilder(
    column: $table.belegnummer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kennzeichen => $composableBuilder(
    column: $table.kennzeichen,
    builder: (column) => column,
  );

  $$MaschinenTableAnnotationComposer get maschineId {
    final $$MaschinenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maschineId,
      referencedTable: $db.maschinen,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaschinenTableAnnotationComposer(
            $db: $db,
            $table: $db.maschinen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerkaeufeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerkaeufeTable,
          VerkaufRow,
          $$VerkaeufeTableFilterComposer,
          $$VerkaeufeTableOrderingComposer,
          $$VerkaeufeTableAnnotationComposer,
          $$VerkaeufeTableCreateCompanionBuilder,
          $$VerkaeufeTableUpdateCompanionBuilder,
          (VerkaufRow, $$VerkaeufeTableReferences),
          VerkaufRow,
          PrefetchHooks Function({bool maschineId})
        > {
  $$VerkaeufeTableTableManager(_$AppDatabase db, $VerkaeufeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerkaeufeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerkaeufeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerkaeufeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> maschineId = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
                Value<int> parkdauerMinuten = const Value.absent(),
                Value<int> betragCent = const Value.absent(),
                Value<String> zahlungsart = const Value.absent(),
                Value<int> belegnummer = const Value.absent(),
                Value<String?> kennzeichen = const Value.absent(),
              }) => VerkaeufeCompanion(
                id: id,
                maschineId: maschineId,
                timestamp: timestamp,
                parkdauerMinuten: parkdauerMinuten,
                betragCent: betragCent,
                zahlungsart: zahlungsart,
                belegnummer: belegnummer,
                kennzeichen: kennzeichen,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int maschineId,
                required String timestamp,
                required int parkdauerMinuten,
                required int betragCent,
                required String zahlungsart,
                required int belegnummer,
                Value<String?> kennzeichen = const Value.absent(),
              }) => VerkaeufeCompanion.insert(
                id: id,
                maschineId: maschineId,
                timestamp: timestamp,
                parkdauerMinuten: parkdauerMinuten,
                betragCent: betragCent,
                zahlungsart: zahlungsart,
                belegnummer: belegnummer,
                kennzeichen: kennzeichen,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VerkaeufeTable, VerkaufRow>(table),
                  $$VerkaeufeTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({maschineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (maschineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.maschineId,
                                referencedTable: $$VerkaeufeTableReferences
                                    ._maschineIdTable(db),
                                referencedColumn: $$VerkaeufeTableReferences
                                    ._maschineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VerkaeufeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerkaeufeTable,
      VerkaufRow,
      $$VerkaeufeTableFilterComposer,
      $$VerkaeufeTableOrderingComposer,
      $$VerkaeufeTableAnnotationComposer,
      $$VerkaeufeTableCreateCompanionBuilder,
      $$VerkaeufeTableUpdateCompanionBuilder,
      (VerkaufRow, $$VerkaeufeTableReferences),
      VerkaufRow,
      PrefetchHooks Function({bool maschineId})
    >;
typedef $$PreissettingsTableCreateCompanionBuilder =
    PreissettingsCompanion Function({
      Value<int> id,
      required int taktMinuten,
      required int preisProTaktCent,
      Value<String> waehrung,
      required String gueltigVon,
      Value<String?> gueltigBis,
    });
typedef $$PreissettingsTableUpdateCompanionBuilder =
    PreissettingsCompanion Function({
      Value<int> id,
      Value<int> taktMinuten,
      Value<int> preisProTaktCent,
      Value<String> waehrung,
      Value<String> gueltigVon,
      Value<String?> gueltigBis,
    });

class $$PreissettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PreissettingsTable> {
  $$PreissettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taktMinuten => $composableBuilder(
    column: $table.taktMinuten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preisProTaktCent => $composableBuilder(
    column: $table.preisProTaktCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waehrung => $composableBuilder(
    column: $table.waehrung,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gueltigVon => $composableBuilder(
    column: $table.gueltigVon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gueltigBis => $composableBuilder(
    column: $table.gueltigBis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreissettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreissettingsTable> {
  $$PreissettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taktMinuten => $composableBuilder(
    column: $table.taktMinuten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preisProTaktCent => $composableBuilder(
    column: $table.preisProTaktCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waehrung => $composableBuilder(
    column: $table.waehrung,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gueltigVon => $composableBuilder(
    column: $table.gueltigVon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gueltigBis => $composableBuilder(
    column: $table.gueltigBis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreissettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreissettingsTable> {
  $$PreissettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get taktMinuten => $composableBuilder(
    column: $table.taktMinuten,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preisProTaktCent => $composableBuilder(
    column: $table.preisProTaktCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waehrung =>
      $composableBuilder(column: $table.waehrung, builder: (column) => column);

  GeneratedColumn<String> get gueltigVon => $composableBuilder(
    column: $table.gueltigVon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gueltigBis => $composableBuilder(
    column: $table.gueltigBis,
    builder: (column) => column,
  );
}

class $$PreissettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreissettingsTable,
          PreissettingRow,
          $$PreissettingsTableFilterComposer,
          $$PreissettingsTableOrderingComposer,
          $$PreissettingsTableAnnotationComposer,
          $$PreissettingsTableCreateCompanionBuilder,
          $$PreissettingsTableUpdateCompanionBuilder,
          (
            PreissettingRow,
            BaseReferences<_$AppDatabase, $PreissettingsTable, PreissettingRow>,
          ),
          PreissettingRow,
          PrefetchHooks Function()
        > {
  $$PreissettingsTableTableManager(_$AppDatabase db, $PreissettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreissettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreissettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreissettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taktMinuten = const Value.absent(),
                Value<int> preisProTaktCent = const Value.absent(),
                Value<String> waehrung = const Value.absent(),
                Value<String> gueltigVon = const Value.absent(),
                Value<String?> gueltigBis = const Value.absent(),
              }) => PreissettingsCompanion(
                id: id,
                taktMinuten: taktMinuten,
                preisProTaktCent: preisProTaktCent,
                waehrung: waehrung,
                gueltigVon: gueltigVon,
                gueltigBis: gueltigBis,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taktMinuten,
                required int preisProTaktCent,
                Value<String> waehrung = const Value.absent(),
                required String gueltigVon,
                Value<String?> gueltigBis = const Value.absent(),
              }) => PreissettingsCompanion.insert(
                id: id,
                taktMinuten: taktMinuten,
                preisProTaktCent: preisProTaktCent,
                waehrung: waehrung,
                gueltigVon: gueltigVon,
                gueltigBis: gueltigBis,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreissettingsTable, PreissettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PreissettingsTable,
                    PreissettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreissettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreissettingsTable,
      PreissettingRow,
      $$PreissettingsTableFilterComposer,
      $$PreissettingsTableOrderingComposer,
      $$PreissettingsTableAnnotationComposer,
      $$PreissettingsTableCreateCompanionBuilder,
      $$PreissettingsTableUpdateCompanionBuilder,
      (
        PreissettingRow,
        BaseReferences<_$AppDatabase, $PreissettingsTable, PreissettingRow>,
      ),
      PreissettingRow,
      PrefetchHooks Function()
    >;
typedef $$VerkaufszeitenTableCreateCompanionBuilder =
    VerkaufszeitenCompanion Function({
      Value<int> id,
      required int wochentag,
      required String beginn,
      required String ende,
      Value<String?> gueltigVon,
      Value<String?> gueltigBis,
    });
typedef $$VerkaufszeitenTableUpdateCompanionBuilder =
    VerkaufszeitenCompanion Function({
      Value<int> id,
      Value<int> wochentag,
      Value<String> beginn,
      Value<String> ende,
      Value<String?> gueltigVon,
      Value<String?> gueltigBis,
    });

class $$VerkaufszeitenTableFilterComposer
    extends Composer<_$AppDatabase, $VerkaufszeitenTable> {
  $$VerkaufszeitenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wochentag => $composableBuilder(
    column: $table.wochentag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beginn => $composableBuilder(
    column: $table.beginn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ende => $composableBuilder(
    column: $table.ende,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gueltigVon => $composableBuilder(
    column: $table.gueltigVon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gueltigBis => $composableBuilder(
    column: $table.gueltigBis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VerkaufszeitenTableOrderingComposer
    extends Composer<_$AppDatabase, $VerkaufszeitenTable> {
  $$VerkaufszeitenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wochentag => $composableBuilder(
    column: $table.wochentag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beginn => $composableBuilder(
    column: $table.beginn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ende => $composableBuilder(
    column: $table.ende,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gueltigVon => $composableBuilder(
    column: $table.gueltigVon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gueltigBis => $composableBuilder(
    column: $table.gueltigBis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VerkaufszeitenTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerkaufszeitenTable> {
  $$VerkaufszeitenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wochentag =>
      $composableBuilder(column: $table.wochentag, builder: (column) => column);

  GeneratedColumn<String> get beginn =>
      $composableBuilder(column: $table.beginn, builder: (column) => column);

  GeneratedColumn<String> get ende =>
      $composableBuilder(column: $table.ende, builder: (column) => column);

  GeneratedColumn<String> get gueltigVon => $composableBuilder(
    column: $table.gueltigVon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gueltigBis => $composableBuilder(
    column: $table.gueltigBis,
    builder: (column) => column,
  );
}

class $$VerkaufszeitenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerkaufszeitenTable,
          VerkaufszeitRow,
          $$VerkaufszeitenTableFilterComposer,
          $$VerkaufszeitenTableOrderingComposer,
          $$VerkaufszeitenTableAnnotationComposer,
          $$VerkaufszeitenTableCreateCompanionBuilder,
          $$VerkaufszeitenTableUpdateCompanionBuilder,
          (
            VerkaufszeitRow,
            BaseReferences<
              _$AppDatabase,
              $VerkaufszeitenTable,
              VerkaufszeitRow
            >,
          ),
          VerkaufszeitRow,
          PrefetchHooks Function()
        > {
  $$VerkaufszeitenTableTableManager(
    _$AppDatabase db,
    $VerkaufszeitenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerkaufszeitenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerkaufszeitenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerkaufszeitenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wochentag = const Value.absent(),
                Value<String> beginn = const Value.absent(),
                Value<String> ende = const Value.absent(),
                Value<String?> gueltigVon = const Value.absent(),
                Value<String?> gueltigBis = const Value.absent(),
              }) => VerkaufszeitenCompanion(
                id: id,
                wochentag: wochentag,
                beginn: beginn,
                ende: ende,
                gueltigVon: gueltigVon,
                gueltigBis: gueltigBis,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wochentag,
                required String beginn,
                required String ende,
                Value<String?> gueltigVon = const Value.absent(),
                Value<String?> gueltigBis = const Value.absent(),
              }) => VerkaufszeitenCompanion.insert(
                id: id,
                wochentag: wochentag,
                beginn: beginn,
                ende: ende,
                gueltigVon: gueltigVon,
                gueltigBis: gueltigBis,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VerkaufszeitenTable, VerkaufszeitRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $VerkaufszeitenTable,
                    VerkaufszeitRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VerkaufszeitenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerkaufszeitenTable,
      VerkaufszeitRow,
      $$VerkaufszeitenTableFilterComposer,
      $$VerkaufszeitenTableOrderingComposer,
      $$VerkaufszeitenTableAnnotationComposer,
      $$VerkaufszeitenTableCreateCompanionBuilder,
      $$VerkaufszeitenTableUpdateCompanionBuilder,
      (
        VerkaufszeitRow,
        BaseReferences<_$AppDatabase, $VerkaufszeitenTable, VerkaufszeitRow>,
      ),
      VerkaufszeitRow,
      PrefetchHooks Function()
    >;
typedef $$ParkzonenTableCreateCompanionBuilder =
    ParkzonenCompanion Function({Value<int> id, required String name});
typedef $$ParkzonenTableUpdateCompanionBuilder =
    ParkzonenCompanion Function({Value<int> id, Value<String> name});

class $$ParkzonenTableFilterComposer
    extends Composer<_$AppDatabase, $ParkzonenTable> {
  $$ParkzonenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParkzonenTableOrderingComposer
    extends Composer<_$AppDatabase, $ParkzonenTable> {
  $$ParkzonenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParkzonenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParkzonenTable> {
  $$ParkzonenTableAnnotationComposer({
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
}

class $$ParkzonenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParkzonenTable,
          ParkzoneRow,
          $$ParkzonenTableFilterComposer,
          $$ParkzonenTableOrderingComposer,
          $$ParkzonenTableAnnotationComposer,
          $$ParkzonenTableCreateCompanionBuilder,
          $$ParkzonenTableUpdateCompanionBuilder,
          (
            ParkzoneRow,
            BaseReferences<_$AppDatabase, $ParkzonenTable, ParkzoneRow>,
          ),
          ParkzoneRow,
          PrefetchHooks Function()
        > {
  $$ParkzonenTableTableManager(_$AppDatabase db, $ParkzonenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParkzonenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParkzonenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParkzonenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ParkzonenCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  ParkzonenCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ParkzonenTable, ParkzoneRow>(table),
                  BaseReferences<_$AppDatabase, $ParkzonenTable, ParkzoneRow>(
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

typedef $$ParkzonenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParkzonenTable,
      ParkzoneRow,
      $$ParkzonenTableFilterComposer,
      $$ParkzonenTableOrderingComposer,
      $$ParkzonenTableAnnotationComposer,
      $$ParkzonenTableCreateCompanionBuilder,
      $$ParkzonenTableUpdateCompanionBuilder,
      (
        ParkzoneRow,
        BaseReferences<_$AppDatabase, $ParkzonenTable, ParkzoneRow>,
      ),
      ParkzoneRow,
      PrefetchHooks Function()
    >;
typedef $$TelemetrienTableCreateCompanionBuilder =
    TelemetrienCompanion Function({
      Value<int> id,
      required int maschineId,
      required String timestamp,
      required int stromverbrauchWatt,
      required int batteriestandProzent,
      required int signalStaerkeDbm,
      required int packetlossProzent,
    });
typedef $$TelemetrienTableUpdateCompanionBuilder =
    TelemetrienCompanion Function({
      Value<int> id,
      Value<int> maschineId,
      Value<String> timestamp,
      Value<int> stromverbrauchWatt,
      Value<int> batteriestandProzent,
      Value<int> signalStaerkeDbm,
      Value<int> packetlossProzent,
    });

final class $$TelemetrienTableReferences
    extends BaseReferences<_$AppDatabase, $TelemetrienTable, TelemetrieRow> {
  $$TelemetrienTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MaschinenTable _maschineIdTable(_$AppDatabase db) =>
      db.maschinen.createAlias('telemetrie__maschine_id__maschine__id');

  $$MaschinenTableProcessedTableManager get maschineId {
    final $_column = $_itemColumn<int>('maschine_id')!;

    final manager = $$MaschinenTableTableManager(
      $_db,
      $_db.maschinen,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_maschineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TelemetrienTableFilterComposer
    extends Composer<_$AppDatabase, $TelemetrienTable> {
  $$TelemetrienTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stromverbrauchWatt => $composableBuilder(
    column: $table.stromverbrauchWatt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batteriestandProzent => $composableBuilder(
    column: $table.batteriestandProzent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get signalStaerkeDbm => $composableBuilder(
    column: $table.signalStaerkeDbm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packetlossProzent => $composableBuilder(
    column: $table.packetlossProzent,
    builder: (column) => ColumnFilters(column),
  );

  $$MaschinenTableFilterComposer get maschineId {
    final $$MaschinenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maschineId,
      referencedTable: $db.maschinen,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaschinenTableFilterComposer(
            $db: $db,
            $table: $db.maschinen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelemetrienTableOrderingComposer
    extends Composer<_$AppDatabase, $TelemetrienTable> {
  $$TelemetrienTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stromverbrauchWatt => $composableBuilder(
    column: $table.stromverbrauchWatt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batteriestandProzent => $composableBuilder(
    column: $table.batteriestandProzent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get signalStaerkeDbm => $composableBuilder(
    column: $table.signalStaerkeDbm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packetlossProzent => $composableBuilder(
    column: $table.packetlossProzent,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaschinenTableOrderingComposer get maschineId {
    final $$MaschinenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maschineId,
      referencedTable: $db.maschinen,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaschinenTableOrderingComposer(
            $db: $db,
            $table: $db.maschinen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelemetrienTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelemetrienTable> {
  $$TelemetrienTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get stromverbrauchWatt => $composableBuilder(
    column: $table.stromverbrauchWatt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get batteriestandProzent => $composableBuilder(
    column: $table.batteriestandProzent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get signalStaerkeDbm => $composableBuilder(
    column: $table.signalStaerkeDbm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get packetlossProzent => $composableBuilder(
    column: $table.packetlossProzent,
    builder: (column) => column,
  );

  $$MaschinenTableAnnotationComposer get maschineId {
    final $$MaschinenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maschineId,
      referencedTable: $db.maschinen,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaschinenTableAnnotationComposer(
            $db: $db,
            $table: $db.maschinen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelemetrienTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelemetrienTable,
          TelemetrieRow,
          $$TelemetrienTableFilterComposer,
          $$TelemetrienTableOrderingComposer,
          $$TelemetrienTableAnnotationComposer,
          $$TelemetrienTableCreateCompanionBuilder,
          $$TelemetrienTableUpdateCompanionBuilder,
          (TelemetrieRow, $$TelemetrienTableReferences),
          TelemetrieRow,
          PrefetchHooks Function({bool maschineId})
        > {
  $$TelemetrienTableTableManager(_$AppDatabase db, $TelemetrienTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelemetrienTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelemetrienTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelemetrienTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> maschineId = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
                Value<int> stromverbrauchWatt = const Value.absent(),
                Value<int> batteriestandProzent = const Value.absent(),
                Value<int> signalStaerkeDbm = const Value.absent(),
                Value<int> packetlossProzent = const Value.absent(),
              }) => TelemetrienCompanion(
                id: id,
                maschineId: maschineId,
                timestamp: timestamp,
                stromverbrauchWatt: stromverbrauchWatt,
                batteriestandProzent: batteriestandProzent,
                signalStaerkeDbm: signalStaerkeDbm,
                packetlossProzent: packetlossProzent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int maschineId,
                required String timestamp,
                required int stromverbrauchWatt,
                required int batteriestandProzent,
                required int signalStaerkeDbm,
                required int packetlossProzent,
              }) => TelemetrienCompanion.insert(
                id: id,
                maschineId: maschineId,
                timestamp: timestamp,
                stromverbrauchWatt: stromverbrauchWatt,
                batteriestandProzent: batteriestandProzent,
                signalStaerkeDbm: signalStaerkeDbm,
                packetlossProzent: packetlossProzent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TelemetrienTable, TelemetrieRow>(table),
                  $$TelemetrienTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({maschineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (maschineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.maschineId,
                                referencedTable: $$TelemetrienTableReferences
                                    ._maschineIdTable(db),
                                referencedColumn: $$TelemetrienTableReferences
                                    ._maschineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TelemetrienTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelemetrienTable,
      TelemetrieRow,
      $$TelemetrienTableFilterComposer,
      $$TelemetrienTableOrderingComposer,
      $$TelemetrienTableAnnotationComposer,
      $$TelemetrienTableCreateCompanionBuilder,
      $$TelemetrienTableUpdateCompanionBuilder,
      (TelemetrieRow, $$TelemetrienTableReferences),
      TelemetrieRow,
      PrefetchHooks Function({bool maschineId})
    >;
typedef $$SchemaVersionenTableCreateCompanionBuilder =
    SchemaVersionenCompanion Function({
      Value<int> version,
      required String name,
      required String appliedAt,
      required String checksum,
    });
typedef $$SchemaVersionenTableUpdateCompanionBuilder =
    SchemaVersionenCompanion Function({
      Value<int> version,
      Value<String> name,
      Value<String> appliedAt,
      Value<String> checksum,
    });

class $$SchemaVersionenTableFilterComposer
    extends Composer<_$AppDatabase, $SchemaVersionenTable> {
  $$SchemaVersionenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchemaVersionenTableOrderingComposer
    extends Composer<_$AppDatabase, $SchemaVersionenTable> {
  $$SchemaVersionenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchemaVersionenTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchemaVersionenTable> {
  $$SchemaVersionenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);
}

class $$SchemaVersionenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchemaVersionenTable,
          SchemaVersionRow,
          $$SchemaVersionenTableFilterComposer,
          $$SchemaVersionenTableOrderingComposer,
          $$SchemaVersionenTableAnnotationComposer,
          $$SchemaVersionenTableCreateCompanionBuilder,
          $$SchemaVersionenTableUpdateCompanionBuilder,
          (
            SchemaVersionRow,
            BaseReferences<
              _$AppDatabase,
              $SchemaVersionenTable,
              SchemaVersionRow
            >,
          ),
          SchemaVersionRow,
          PrefetchHooks Function()
        > {
  $$SchemaVersionenTableTableManager(
    _$AppDatabase db,
    $SchemaVersionenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchemaVersionenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchemaVersionenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchemaVersionenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> appliedAt = const Value.absent(),
                Value<String> checksum = const Value.absent(),
              }) => SchemaVersionenCompanion(
                version: version,
                name: name,
                appliedAt: appliedAt,
                checksum: checksum,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required String name,
                required String appliedAt,
                required String checksum,
              }) => SchemaVersionenCompanion.insert(
                version: version,
                name: name,
                appliedAt: appliedAt,
                checksum: checksum,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SchemaVersionenTable, SchemaVersionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SchemaVersionenTable,
                    SchemaVersionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchemaVersionenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchemaVersionenTable,
      SchemaVersionRow,
      $$SchemaVersionenTableFilterComposer,
      $$SchemaVersionenTableOrderingComposer,
      $$SchemaVersionenTableAnnotationComposer,
      $$SchemaVersionenTableCreateCompanionBuilder,
      $$SchemaVersionenTableUpdateCompanionBuilder,
      (
        SchemaVersionRow,
        BaseReferences<_$AppDatabase, $SchemaVersionenTable, SchemaVersionRow>,
      ),
      SchemaVersionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MaschinenTableTableManager get maschinen =>
      $$MaschinenTableTableManager(_db, _db.maschinen);
  $$VerkaeufeTableTableManager get verkaeufe =>
      $$VerkaeufeTableTableManager(_db, _db.verkaeufe);
  $$PreissettingsTableTableManager get preissettings =>
      $$PreissettingsTableTableManager(_db, _db.preissettings);
  $$VerkaufszeitenTableTableManager get verkaufszeiten =>
      $$VerkaufszeitenTableTableManager(_db, _db.verkaufszeiten);
  $$ParkzonenTableTableManager get parkzonen =>
      $$ParkzonenTableTableManager(_db, _db.parkzonen);
  $$TelemetrienTableTableManager get telemetrien =>
      $$TelemetrienTableTableManager(_db, _db.telemetrien);
  $$SchemaVersionenTableTableManager get schemaVersionen =>
      $$SchemaVersionenTableTableManager(_db, _db.schemaVersionen);
}
