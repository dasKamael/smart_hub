// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FloorPlansTableTable extends FloorPlansTable with TableInfo<$FloorPlansTableTable, FloorPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FloorPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'floor_plans';
  @override
  VerificationContext validateIntegrity(Insertable<FloorPlanRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('json')) {
      context.handle(_jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FloorPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FloorPlanRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      json: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}json'])!,
    );
  }

  @override
  $FloorPlansTableTable createAlias(String alias) {
    return $FloorPlansTableTable(attachedDatabase, alias);
  }
}

class FloorPlanRow extends DataClass implements Insertable<FloorPlanRow> {
  final int id;
  final String json;
  const FloorPlanRow({required this.id, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['json'] = Variable<String>(json);
    return map;
  }

  FloorPlansTableCompanion toCompanion(bool nullToAbsent) {
    return FloorPlansTableCompanion(id: Value(id), json: Value(json));
  }

  factory FloorPlanRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FloorPlanRow(id: serializer.fromJson<int>(json['id']), json: serializer.fromJson<String>(json['json']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<int>(id), 'json': serializer.toJson<String>(json)};
  }

  FloorPlanRow copyWith({int? id, String? json}) => FloorPlanRow(id: id ?? this.id, json: json ?? this.json);
  FloorPlanRow copyWithCompanion(FloorPlansTableCompanion data) {
    return FloorPlanRow(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FloorPlanRow(')
          ..write('id: $id, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FloorPlanRow && other.id == this.id && other.json == this.json);
}

class FloorPlansTableCompanion extends UpdateCompanion<FloorPlanRow> {
  final Value<int> id;
  final Value<String> json;
  const FloorPlansTableCompanion({this.id = const Value.absent(), this.json = const Value.absent()});
  FloorPlansTableCompanion.insert({this.id = const Value.absent(), required String json}) : json = Value(json);
  static Insertable<FloorPlanRow> custom({Expression<int>? id, Expression<String>? json}) {
    return RawValuesInsertable({if (id != null) 'id': id, if (json != null) 'json': json});
  }

  FloorPlansTableCompanion copyWith({Value<int>? id, Value<String>? json}) {
    return FloorPlansTableCompanion(id: id ?? this.id, json: json ?? this.json);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FloorPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }
}

class $PlacementsTableTable extends PlacementsTable with TableInfo<$PlacementsTableTable, PlacementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DeviceKind, String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<DeviceKind>($PlacementsTableTable.$converterkind);
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, kind, x, y];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'placements';
  @override
  VerificationContext validateIntegrity(Insertable<PlacementRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta, deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  PlacementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlacementRow(
      deviceId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      kind: $PlacementsTableTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      ),
      x: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}x'])!,
      y: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}y'])!,
    );
  }

  @override
  $PlacementsTableTable createAlias(String alias) {
    return $PlacementsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DeviceKind, String, String> $converterkind = const EnumNameConverter<DeviceKind>(
    DeviceKind.values,
  );
}

class PlacementRow extends DataClass implements Insertable<PlacementRow> {
  final String deviceId;
  final DeviceKind kind;
  final double x;
  final double y;
  const PlacementRow({required this.deviceId, required this.kind, required this.x, required this.y});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    {
      map['kind'] = Variable<String>($PlacementsTableTable.$converterkind.toSql(kind));
    }
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    return map;
  }

  PlacementsTableCompanion toCompanion(bool nullToAbsent) {
    return PlacementsTableCompanion(deviceId: Value(deviceId), kind: Value(kind), x: Value(x), y: Value(y));
  }

  factory PlacementRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlacementRow(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      kind: $PlacementsTableTable.$converterkind.fromJson(serializer.fromJson<String>(json['kind'])),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'kind': serializer.toJson<String>($PlacementsTableTable.$converterkind.toJson(kind)),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
    };
  }

  PlacementRow copyWith({String? deviceId, DeviceKind? kind, double? x, double? y}) =>
      PlacementRow(deviceId: deviceId ?? this.deviceId, kind: kind ?? this.kind, x: x ?? this.x, y: y ?? this.y);
  PlacementRow copyWithCompanion(PlacementsTableCompanion data) {
    return PlacementRow(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      kind: data.kind.present ? data.kind.value : this.kind,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlacementRow(')
          ..write('deviceId: $deviceId, ')
          ..write('kind: $kind, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, kind, x, y);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacementRow &&
          other.deviceId == this.deviceId &&
          other.kind == this.kind &&
          other.x == this.x &&
          other.y == this.y);
}

class PlacementsTableCompanion extends UpdateCompanion<PlacementRow> {
  final Value<String> deviceId;
  final Value<DeviceKind> kind;
  final Value<double> x;
  final Value<double> y;
  final Value<int> rowid;
  const PlacementsTableCompanion({
    this.deviceId = const Value.absent(),
    this.kind = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacementsTableCompanion.insert({
    required String deviceId,
    required DeviceKind kind,
    required double x,
    required double y,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       kind = Value(kind),
       x = Value(x),
       y = Value(y);
  static Insertable<PlacementRow> custom({
    Expression<String>? deviceId,
    Expression<String>? kind,
    Expression<double>? x,
    Expression<double>? y,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (kind != null) 'kind': kind,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacementsTableCompanion copyWith({
    Value<String>? deviceId,
    Value<DeviceKind>? kind,
    Value<double>? x,
    Value<double>? y,
    Value<int>? rowid,
  }) {
    return PlacementsTableCompanion(
      deviceId: deviceId ?? this.deviceId,
      kind: kind ?? this.kind,
      x: x ?? this.x,
      y: y ?? this.y,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>($PlacementsTableTable.$converterkind.toSql(kind.value));
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacementsTableCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('kind: $kind, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlantsTableTable extends PlantsTable with TableInfo<$PlantsTableTable, PlantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _everyDaysMeta = const VerificationMeta('everyDays');
  @override
  late final GeneratedColumn<int> everyDays = GeneratedColumn<int>(
    'every_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastWateredMeta = const VerificationMeta('lastWatered');
  @override
  late final GeneratedColumn<DateTime> lastWatered = GeneratedColumn<DateTime>(
    'last_watered',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousWateredMeta = const VerificationMeta('previousWatered');
  @override
  late final GeneratedColumn<DateTime> previousWatered = GeneratedColumn<DateTime>(
    'previous_watered',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fertilizeEveryWeeksMeta = const VerificationMeta('fertilizeEveryWeeks');
  @override
  late final GeneratedColumn<int> fertilizeEveryWeeks = GeneratedColumn<int>(
    'fertilize_every_weeks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFertilizedMeta = const VerificationMeta('lastFertilized');
  @override
  late final GeneratedColumn<DateTime> lastFertilized = GeneratedColumn<DateTime>(
    'last_fertilized',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    everyDays,
    lastWatered,
    previousWatered,
    photoPath,
    fertilizeEveryWeeks,
    lastFertilized,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(Insertable<PlantRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('every_days')) {
      context.handle(_everyDaysMeta, everyDays.isAcceptableOrUnknown(data['every_days']!, _everyDaysMeta));
    } else if (isInserting) {
      context.missing(_everyDaysMeta);
    }
    if (data.containsKey('last_watered')) {
      context.handle(_lastWateredMeta, lastWatered.isAcceptableOrUnknown(data['last_watered']!, _lastWateredMeta));
    } else if (isInserting) {
      context.missing(_lastWateredMeta);
    }
    if (data.containsKey('previous_watered')) {
      context.handle(
        _previousWateredMeta,
        previousWatered.isAcceptableOrUnknown(data['previous_watered']!, _previousWateredMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta, photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('fertilize_every_weeks')) {
      context.handle(
        _fertilizeEveryWeeksMeta,
        fertilizeEveryWeeks.isAcceptableOrUnknown(data['fertilize_every_weeks']!, _fertilizeEveryWeeksMeta),
      );
    }
    if (data.containsKey('last_fertilized')) {
      context.handle(
        _lastFertilizedMeta,
        lastFertilized.isAcceptableOrUnknown(data['last_fertilized']!, _lastFertilizedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      everyDays: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}every_days'])!,
      lastWatered: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}last_watered'])!,
      previousWatered: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}previous_watered'],
      ),
      photoPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      fertilizeEveryWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fertilize_every_weeks'],
      ),
      lastFertilized: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fertilized'],
      ),
    );
  }

  @override
  $PlantsTableTable createAlias(String alias) {
    return $PlantsTableTable(attachedDatabase, alias);
  }
}

class PlantRow extends DataClass implements Insertable<PlantRow> {
  final String id;
  final String name;
  final int everyDays;
  final DateTime lastWatered;
  final DateTime? previousWatered;
  final String? photoPath;

  /// Weeks between fertilizing in the growing season; `null` = not fertilized.
  final int? fertilizeEveryWeeks;
  final DateTime? lastFertilized;
  const PlantRow({
    required this.id,
    required this.name,
    required this.everyDays,
    required this.lastWatered,
    this.previousWatered,
    this.photoPath,
    this.fertilizeEveryWeeks,
    this.lastFertilized,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['every_days'] = Variable<int>(everyDays);
    map['last_watered'] = Variable<DateTime>(lastWatered);
    if (!nullToAbsent || previousWatered != null) {
      map['previous_watered'] = Variable<DateTime>(previousWatered);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || fertilizeEveryWeeks != null) {
      map['fertilize_every_weeks'] = Variable<int>(fertilizeEveryWeeks);
    }
    if (!nullToAbsent || lastFertilized != null) {
      map['last_fertilized'] = Variable<DateTime>(lastFertilized);
    }
    return map;
  }

  PlantsTableCompanion toCompanion(bool nullToAbsent) {
    return PlantsTableCompanion(
      id: Value(id),
      name: Value(name),
      everyDays: Value(everyDays),
      lastWatered: Value(lastWatered),
      previousWatered: previousWatered == null && nullToAbsent ? const Value.absent() : Value(previousWatered),
      photoPath: photoPath == null && nullToAbsent ? const Value.absent() : Value(photoPath),
      fertilizeEveryWeeks: fertilizeEveryWeeks == null && nullToAbsent
          ? const Value.absent()
          : Value(fertilizeEveryWeeks),
      lastFertilized: lastFertilized == null && nullToAbsent ? const Value.absent() : Value(lastFertilized),
    );
  }

  factory PlantRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      everyDays: serializer.fromJson<int>(json['everyDays']),
      lastWatered: serializer.fromJson<DateTime>(json['lastWatered']),
      previousWatered: serializer.fromJson<DateTime?>(json['previousWatered']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      fertilizeEveryWeeks: serializer.fromJson<int?>(json['fertilizeEveryWeeks']),
      lastFertilized: serializer.fromJson<DateTime?>(json['lastFertilized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'everyDays': serializer.toJson<int>(everyDays),
      'lastWatered': serializer.toJson<DateTime>(lastWatered),
      'previousWatered': serializer.toJson<DateTime?>(previousWatered),
      'photoPath': serializer.toJson<String?>(photoPath),
      'fertilizeEveryWeeks': serializer.toJson<int?>(fertilizeEveryWeeks),
      'lastFertilized': serializer.toJson<DateTime?>(lastFertilized),
    };
  }

  PlantRow copyWith({
    String? id,
    String? name,
    int? everyDays,
    DateTime? lastWatered,
    Value<DateTime?> previousWatered = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<int?> fertilizeEveryWeeks = const Value.absent(),
    Value<DateTime?> lastFertilized = const Value.absent(),
  }) => PlantRow(
    id: id ?? this.id,
    name: name ?? this.name,
    everyDays: everyDays ?? this.everyDays,
    lastWatered: lastWatered ?? this.lastWatered,
    previousWatered: previousWatered.present ? previousWatered.value : this.previousWatered,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    fertilizeEveryWeeks: fertilizeEveryWeeks.present ? fertilizeEveryWeeks.value : this.fertilizeEveryWeeks,
    lastFertilized: lastFertilized.present ? lastFertilized.value : this.lastFertilized,
  );
  PlantRow copyWithCompanion(PlantsTableCompanion data) {
    return PlantRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      everyDays: data.everyDays.present ? data.everyDays.value : this.everyDays,
      lastWatered: data.lastWatered.present ? data.lastWatered.value : this.lastWatered,
      previousWatered: data.previousWatered.present ? data.previousWatered.value : this.previousWatered,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      fertilizeEveryWeeks: data.fertilizeEveryWeeks.present ? data.fertilizeEveryWeeks.value : this.fertilizeEveryWeeks,
      lastFertilized: data.lastFertilized.present ? data.lastFertilized.value : this.lastFertilized,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('everyDays: $everyDays, ')
          ..write('lastWatered: $lastWatered, ')
          ..write('previousWatered: $previousWatered, ')
          ..write('photoPath: $photoPath, ')
          ..write('fertilizeEveryWeeks: $fertilizeEveryWeeks, ')
          ..write('lastFertilized: $lastFertilized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, everyDays, lastWatered, previousWatered, photoPath, fertilizeEveryWeeks, lastFertilized);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.everyDays == this.everyDays &&
          other.lastWatered == this.lastWatered &&
          other.previousWatered == this.previousWatered &&
          other.photoPath == this.photoPath &&
          other.fertilizeEveryWeeks == this.fertilizeEveryWeeks &&
          other.lastFertilized == this.lastFertilized);
}

class PlantsTableCompanion extends UpdateCompanion<PlantRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> everyDays;
  final Value<DateTime> lastWatered;
  final Value<DateTime?> previousWatered;
  final Value<String?> photoPath;
  final Value<int?> fertilizeEveryWeeks;
  final Value<DateTime?> lastFertilized;
  final Value<int> rowid;
  const PlantsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.everyDays = const Value.absent(),
    this.lastWatered = const Value.absent(),
    this.previousWatered = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.fertilizeEveryWeeks = const Value.absent(),
    this.lastFertilized = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlantsTableCompanion.insert({
    required String id,
    required String name,
    required int everyDays,
    required DateTime lastWatered,
    this.previousWatered = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.fertilizeEveryWeeks = const Value.absent(),
    this.lastFertilized = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       everyDays = Value(everyDays),
       lastWatered = Value(lastWatered);
  static Insertable<PlantRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? everyDays,
    Expression<DateTime>? lastWatered,
    Expression<DateTime>? previousWatered,
    Expression<String>? photoPath,
    Expression<int>? fertilizeEveryWeeks,
    Expression<DateTime>? lastFertilized,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (everyDays != null) 'every_days': everyDays,
      if (lastWatered != null) 'last_watered': lastWatered,
      if (previousWatered != null) 'previous_watered': previousWatered,
      if (photoPath != null) 'photo_path': photoPath,
      if (fertilizeEveryWeeks != null) 'fertilize_every_weeks': fertilizeEveryWeeks,
      if (lastFertilized != null) 'last_fertilized': lastFertilized,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlantsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? everyDays,
    Value<DateTime>? lastWatered,
    Value<DateTime?>? previousWatered,
    Value<String?>? photoPath,
    Value<int?>? fertilizeEveryWeeks,
    Value<DateTime?>? lastFertilized,
    Value<int>? rowid,
  }) {
    return PlantsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      everyDays: everyDays ?? this.everyDays,
      lastWatered: lastWatered ?? this.lastWatered,
      previousWatered: previousWatered ?? this.previousWatered,
      photoPath: photoPath ?? this.photoPath,
      fertilizeEveryWeeks: fertilizeEveryWeeks ?? this.fertilizeEveryWeeks,
      lastFertilized: lastFertilized ?? this.lastFertilized,
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
    if (everyDays.present) {
      map['every_days'] = Variable<int>(everyDays.value);
    }
    if (lastWatered.present) {
      map['last_watered'] = Variable<DateTime>(lastWatered.value);
    }
    if (previousWatered.present) {
      map['previous_watered'] = Variable<DateTime>(previousWatered.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (fertilizeEveryWeeks.present) {
      map['fertilize_every_weeks'] = Variable<int>(fertilizeEveryWeeks.value);
    }
    if (lastFertilized.present) {
      map['last_fertilized'] = Variable<DateTime>(lastFertilized.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('everyDays: $everyDays, ')
          ..write('lastWatered: $lastWatered, ')
          ..write('previousWatered: $previousWatered, ')
          ..write('photoPath: $photoPath, ')
          ..write('fertilizeEveryWeeks: $fertilizeEveryWeeks, ')
          ..write('lastFertilized: $lastFertilized, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeakerSettingsTableTable extends SpeakerSettingsTable
    with TableInfo<$SpeakerSettingsTableTable, SpeakerSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeakerSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, displayName, hidden, isDefault];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speaker_settings';
  @override
  VerificationContext validateIntegrity(Insertable<SpeakerSettingRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta, hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta, isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeakerSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeakerSettingRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      hidden: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
      isDefault: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
    );
  }

  @override
  $SpeakerSettingsTableTable createAlias(String alias) {
    return $SpeakerSettingsTableTable(attachedDatabase, alias);
  }
}

class SpeakerSettingRow extends DataClass implements Insertable<SpeakerSettingRow> {
  final String id;

  /// Shown instead of the name the device reports.
  final String? displayName;
  final bool hidden;

  /// Plays "Jump back in" when nothing is playing.
  final bool isDefault;
  const SpeakerSettingRow({required this.id, this.displayName, required this.hidden, required this.isDefault});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['hidden'] = Variable<bool>(hidden);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  SpeakerSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SpeakerSettingsTableCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent ? const Value.absent() : Value(displayName),
      hidden: Value(hidden),
      isDefault: Value(isDefault),
    );
  }

  factory SpeakerSettingRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeakerSettingRow(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      hidden: serializer.fromJson<bool>(json['hidden']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'hidden': serializer.toJson<bool>(hidden),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  SpeakerSettingRow copyWith({
    String? id,
    Value<String?> displayName = const Value.absent(),
    bool? hidden,
    bool? isDefault,
  }) => SpeakerSettingRow(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    hidden: hidden ?? this.hidden,
    isDefault: isDefault ?? this.isDefault,
  );
  SpeakerSettingRow copyWithCompanion(SpeakerSettingsTableCompanion data) {
    return SpeakerSettingRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present ? data.displayName.value : this.displayName,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeakerSettingRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('hidden: $hidden, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, hidden, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeakerSettingRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.hidden == this.hidden &&
          other.isDefault == this.isDefault);
}

class SpeakerSettingsTableCompanion extends UpdateCompanion<SpeakerSettingRow> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<bool> hidden;
  final Value<bool> isDefault;
  final Value<int> rowid;
  const SpeakerSettingsTableCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.hidden = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeakerSettingsTableCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.hidden = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<SpeakerSettingRow> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<bool>? hidden,
    Expression<bool>? isDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (hidden != null) 'hidden': hidden,
      if (isDefault != null) 'is_default': isDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeakerSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<bool>? hidden,
    Value<bool>? isDefault,
    Value<int>? rowid,
  }) {
    return SpeakerSettingsTableCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      hidden: hidden ?? this.hidden,
      isDefault: isDefault ?? this.isDefault,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeakerSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('hidden: $hidden, ')
          ..write('isDefault: $isDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZenSettingsTableTable extends ZenSettingsTable with TableInfo<$ZenSettingsTableTable, ZenSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZenSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idleMinutesMeta = const VerificationMeta('idleMinutes');
  @override
  late final GeneratedColumn<int> idleMinutes = GeneratedColumn<int>(
    'idle_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  @override
  List<GeneratedColumn> get $columns => [id, idleMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zen_settings';
  @override
  VerificationContext validateIntegrity(Insertable<ZenSettingsRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idle_minutes')) {
      context.handle(_idleMinutesMeta, idleMinutes.isAcceptableOrUnknown(data['idle_minutes']!, _idleMinutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZenSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZenSettingsRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idleMinutes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}idle_minutes'])!,
    );
  }

  @override
  $ZenSettingsTableTable createAlias(String alias) {
    return $ZenSettingsTableTable(attachedDatabase, alias);
  }
}

class ZenSettingsRow extends DataClass implements Insertable<ZenSettingsRow> {
  final int id;

  /// Minutes without a touch until the zen mode starts; 0 = only by hand.
  final int idleMinutes;
  const ZenSettingsRow({required this.id, required this.idleMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idle_minutes'] = Variable<int>(idleMinutes);
    return map;
  }

  ZenSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return ZenSettingsTableCompanion(id: Value(id), idleMinutes: Value(idleMinutes));
  }

  factory ZenSettingsRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZenSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      idleMinutes: serializer.fromJson<int>(json['idleMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<int>(id), 'idleMinutes': serializer.toJson<int>(idleMinutes)};
  }

  ZenSettingsRow copyWith({int? id, int? idleMinutes}) =>
      ZenSettingsRow(id: id ?? this.id, idleMinutes: idleMinutes ?? this.idleMinutes);
  ZenSettingsRow copyWithCompanion(ZenSettingsTableCompanion data) {
    return ZenSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      idleMinutes: data.idleMinutes.present ? data.idleMinutes.value : this.idleMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZenSettingsRow(')
          ..write('id: $id, ')
          ..write('idleMinutes: $idleMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idleMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZenSettingsRow && other.id == this.id && other.idleMinutes == this.idleMinutes);
}

class ZenSettingsTableCompanion extends UpdateCompanion<ZenSettingsRow> {
  final Value<int> id;
  final Value<int> idleMinutes;
  const ZenSettingsTableCompanion({this.id = const Value.absent(), this.idleMinutes = const Value.absent()});
  ZenSettingsTableCompanion.insert({this.id = const Value.absent(), this.idleMinutes = const Value.absent()});
  static Insertable<ZenSettingsRow> custom({Expression<int>? id, Expression<int>? idleMinutes}) {
    return RawValuesInsertable({if (id != null) 'id': id, if (idleMinutes != null) 'idle_minutes': idleMinutes});
  }

  ZenSettingsTableCompanion copyWith({Value<int>? id, Value<int>? idleMinutes}) {
    return ZenSettingsTableCompanion(id: id ?? this.id, idleMinutes: idleMinutes ?? this.idleMinutes);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idleMinutes.present) {
      map['idle_minutes'] = Variable<int>(idleMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZenSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('idleMinutes: $idleMinutes')
          ..write(')'))
        .toString();
  }
}

class $PlantProfilesTableTable extends PlantProfilesTable with TableInfo<$PlantProfilesTableTable, PlantProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _plantIdMeta = const VerificationMeta('plantId');
  @override
  late final GeneratedColumn<String> plantId = GeneratedColumn<String>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta('speciesId');
  @override
  late final GeneratedColumn<int> speciesId = GeneratedColumn<int>(
    'species_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('perenual'),
  );
  static const VerificationMeta _commonNameMeta = const VerificationMeta('commonName');
  @override
  late final GeneratedColumn<String> commonName = GeneratedColumn<String>(
    'common_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scientificNameMeta = const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
    'scientific_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateringMeta = const VerificationMeta('watering');
  @override
  late final GeneratedColumn<String> watering = GeneratedColumn<String>(
    'watering',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateringMinDaysMeta = const VerificationMeta('wateringMinDays');
  @override
  late final GeneratedColumn<int> wateringMinDays = GeneratedColumn<int>(
    'watering_min_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateringMaxDaysMeta = const VerificationMeta('wateringMaxDays');
  @override
  late final GeneratedColumn<int> wateringMaxDays = GeneratedColumn<int>(
    'watering_max_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateringWinterMinDaysMeta = const VerificationMeta('wateringWinterMinDays');
  @override
  late final GeneratedColumn<int> wateringWinterMinDays = GeneratedColumn<int>(
    'watering_winter_min_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateringWinterMaxDaysMeta = const VerificationMeta('wateringWinterMaxDays');
  @override
  late final GeneratedColumn<int> wateringWinterMaxDays = GeneratedColumn<int>(
    'watering_winter_max_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fertilizeEveryWeeksMeta = const VerificationMeta('fertilizeEveryWeeks');
  @override
  late final GeneratedColumn<int> fertilizeEveryWeeks = GeneratedColumn<int>(
    'fertilize_every_weeks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sunlightMeta = const VerificationMeta('sunlight');
  @override
  late final GeneratedColumn<String> sunlight = GeneratedColumn<String>(
    'sunlight',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _careLevelMeta = const VerificationMeta('careLevel');
  @override
  late final GeneratedColumn<String> careLevel = GeneratedColumn<String>(
    'care_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _indoorMeta = const VerificationMeta('indoor');
  @override
  late final GeneratedColumn<bool> indoor = GeneratedColumn<bool>(
    'indoor',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("indoor" IN (0, 1))'),
  );
  static const VerificationMeta _poisonousToPetsMeta = const VerificationMeta('poisonousToPets');
  @override
  late final GeneratedColumn<bool> poisonousToPets = GeneratedColumn<bool>(
    'poisonous_to_pets',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("poisonous_to_pets" IN (0, 1))'),
  );
  static const VerificationMeta _pruningMonthsMeta = const VerificationMeta('pruningMonths');
  @override
  late final GeneratedColumn<String> pruningMonths = GeneratedColumn<String>(
    'pruning_months',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _wateringGuideMeta = const VerificationMeta('wateringGuide');
  @override
  late final GeneratedColumn<String> wateringGuide = GeneratedColumn<String>(
    'watering_guide',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sunlightGuideMeta = const VerificationMeta('sunlightGuide');
  @override
  late final GeneratedColumn<String> sunlightGuide = GeneratedColumn<String>(
    'sunlight_guide',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pruningGuideMeta = const VerificationMeta('pruningGuide');
  @override
  late final GeneratedColumn<String> pruningGuide = GeneratedColumn<String>(
    'pruning_guide',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    plantId,
    speciesId,
    source,
    commonName,
    scientificName,
    imageUrl,
    watering,
    wateringMinDays,
    wateringMaxDays,
    wateringWinterMinDays,
    wateringWinterMaxDays,
    fertilizeEveryWeeks,
    sunlight,
    careLevel,
    indoor,
    poisonousToPets,
    pruningMonths,
    wateringGuide,
    sunlightGuide,
    pruningGuide,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plant_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<PlantProfileRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plant_id')) {
      context.handle(_plantIdMeta, plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta));
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(_speciesIdMeta, speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('common_name')) {
      context.handle(_commonNameMeta, commonName.isAcceptableOrUnknown(data['common_name']!, _commonNameMeta));
    } else if (isInserting) {
      context.missing(_commonNameMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
        _scientificNameMeta,
        scientificName.isAcceptableOrUnknown(data['scientific_name']!, _scientificNameMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta, imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('watering')) {
      context.handle(_wateringMeta, watering.isAcceptableOrUnknown(data['watering']!, _wateringMeta));
    }
    if (data.containsKey('watering_min_days')) {
      context.handle(
        _wateringMinDaysMeta,
        wateringMinDays.isAcceptableOrUnknown(data['watering_min_days']!, _wateringMinDaysMeta),
      );
    }
    if (data.containsKey('watering_max_days')) {
      context.handle(
        _wateringMaxDaysMeta,
        wateringMaxDays.isAcceptableOrUnknown(data['watering_max_days']!, _wateringMaxDaysMeta),
      );
    }
    if (data.containsKey('watering_winter_min_days')) {
      context.handle(
        _wateringWinterMinDaysMeta,
        wateringWinterMinDays.isAcceptableOrUnknown(data['watering_winter_min_days']!, _wateringWinterMinDaysMeta),
      );
    }
    if (data.containsKey('watering_winter_max_days')) {
      context.handle(
        _wateringWinterMaxDaysMeta,
        wateringWinterMaxDays.isAcceptableOrUnknown(data['watering_winter_max_days']!, _wateringWinterMaxDaysMeta),
      );
    }
    if (data.containsKey('fertilize_every_weeks')) {
      context.handle(
        _fertilizeEveryWeeksMeta,
        fertilizeEveryWeeks.isAcceptableOrUnknown(data['fertilize_every_weeks']!, _fertilizeEveryWeeksMeta),
      );
    }
    if (data.containsKey('sunlight')) {
      context.handle(_sunlightMeta, sunlight.isAcceptableOrUnknown(data['sunlight']!, _sunlightMeta));
    }
    if (data.containsKey('care_level')) {
      context.handle(_careLevelMeta, careLevel.isAcceptableOrUnknown(data['care_level']!, _careLevelMeta));
    }
    if (data.containsKey('indoor')) {
      context.handle(_indoorMeta, indoor.isAcceptableOrUnknown(data['indoor']!, _indoorMeta));
    }
    if (data.containsKey('poisonous_to_pets')) {
      context.handle(
        _poisonousToPetsMeta,
        poisonousToPets.isAcceptableOrUnknown(data['poisonous_to_pets']!, _poisonousToPetsMeta),
      );
    }
    if (data.containsKey('pruning_months')) {
      context.handle(
        _pruningMonthsMeta,
        pruningMonths.isAcceptableOrUnknown(data['pruning_months']!, _pruningMonthsMeta),
      );
    }
    if (data.containsKey('watering_guide')) {
      context.handle(
        _wateringGuideMeta,
        wateringGuide.isAcceptableOrUnknown(data['watering_guide']!, _wateringGuideMeta),
      );
    }
    if (data.containsKey('sunlight_guide')) {
      context.handle(
        _sunlightGuideMeta,
        sunlightGuide.isAcceptableOrUnknown(data['sunlight_guide']!, _sunlightGuideMeta),
      );
    }
    if (data.containsKey('pruning_guide')) {
      context.handle(_pruningGuideMeta, pruningGuide.isAcceptableOrUnknown(data['pruning_guide']!, _pruningGuideMeta));
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta, fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {plantId};
  @override
  PlantProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantProfileRow(
      plantId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}plant_id'])!,
      speciesId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}species_id']),
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      commonName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}common_name'])!,
      scientificName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}scientific_name']),
      imageUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      watering: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}watering']),
      wateringMinDays: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}watering_min_days']),
      wateringMaxDays: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}watering_max_days']),
      wateringWinterMinDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}watering_winter_min_days'],
      ),
      wateringWinterMaxDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}watering_winter_max_days'],
      ),
      fertilizeEveryWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fertilize_every_weeks'],
      ),
      sunlight: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sunlight'])!,
      careLevel: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}care_level']),
      indoor: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}indoor']),
      poisonousToPets: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}poisonous_to_pets'],
      ),
      pruningMonths: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pruning_months'])!,
      wateringGuide: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}watering_guide']),
      sunlightGuide: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sunlight_guide']),
      pruningGuide: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pruning_guide']),
      fetchedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $PlantProfilesTableTable createAlias(String alias) {
    return $PlantProfilesTableTable(attachedDatabase, alias);
  }
}

class PlantProfileRow extends DataClass implements Insertable<PlantProfileRow> {
  final String plantId;

  /// `null` for imported profiles.
  final int? speciesId;

  /// `PlantProfileSource` name.
  final String source;
  final String commonName;
  final String? scientificName;
  final String? imageUrl;
  final String? watering;
  final int? wateringMinDays;
  final int? wateringMaxDays;
  final int? wateringWinterMinDays;
  final int? wateringWinterMaxDays;
  final int? fertilizeEveryWeeks;
  final String sunlight;
  final String? careLevel;
  final bool? indoor;
  final bool? poisonousToPets;
  final String pruningMonths;
  final String? wateringGuide;
  final String? sunlightGuide;
  final String? pruningGuide;
  final DateTime fetchedAt;
  const PlantProfileRow({
    required this.plantId,
    this.speciesId,
    required this.source,
    required this.commonName,
    this.scientificName,
    this.imageUrl,
    this.watering,
    this.wateringMinDays,
    this.wateringMaxDays,
    this.wateringWinterMinDays,
    this.wateringWinterMaxDays,
    this.fertilizeEveryWeeks,
    required this.sunlight,
    this.careLevel,
    this.indoor,
    this.poisonousToPets,
    required this.pruningMonths,
    this.wateringGuide,
    this.sunlightGuide,
    this.pruningGuide,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plant_id'] = Variable<String>(plantId);
    if (!nullToAbsent || speciesId != null) {
      map['species_id'] = Variable<int>(speciesId);
    }
    map['source'] = Variable<String>(source);
    map['common_name'] = Variable<String>(commonName);
    if (!nullToAbsent || scientificName != null) {
      map['scientific_name'] = Variable<String>(scientificName);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || watering != null) {
      map['watering'] = Variable<String>(watering);
    }
    if (!nullToAbsent || wateringMinDays != null) {
      map['watering_min_days'] = Variable<int>(wateringMinDays);
    }
    if (!nullToAbsent || wateringMaxDays != null) {
      map['watering_max_days'] = Variable<int>(wateringMaxDays);
    }
    if (!nullToAbsent || wateringWinterMinDays != null) {
      map['watering_winter_min_days'] = Variable<int>(wateringWinterMinDays);
    }
    if (!nullToAbsent || wateringWinterMaxDays != null) {
      map['watering_winter_max_days'] = Variable<int>(wateringWinterMaxDays);
    }
    if (!nullToAbsent || fertilizeEveryWeeks != null) {
      map['fertilize_every_weeks'] = Variable<int>(fertilizeEveryWeeks);
    }
    map['sunlight'] = Variable<String>(sunlight);
    if (!nullToAbsent || careLevel != null) {
      map['care_level'] = Variable<String>(careLevel);
    }
    if (!nullToAbsent || indoor != null) {
      map['indoor'] = Variable<bool>(indoor);
    }
    if (!nullToAbsent || poisonousToPets != null) {
      map['poisonous_to_pets'] = Variable<bool>(poisonousToPets);
    }
    map['pruning_months'] = Variable<String>(pruningMonths);
    if (!nullToAbsent || wateringGuide != null) {
      map['watering_guide'] = Variable<String>(wateringGuide);
    }
    if (!nullToAbsent || sunlightGuide != null) {
      map['sunlight_guide'] = Variable<String>(sunlightGuide);
    }
    if (!nullToAbsent || pruningGuide != null) {
      map['pruning_guide'] = Variable<String>(pruningGuide);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  PlantProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return PlantProfilesTableCompanion(
      plantId: Value(plantId),
      speciesId: speciesId == null && nullToAbsent ? const Value.absent() : Value(speciesId),
      source: Value(source),
      commonName: Value(commonName),
      scientificName: scientificName == null && nullToAbsent ? const Value.absent() : Value(scientificName),
      imageUrl: imageUrl == null && nullToAbsent ? const Value.absent() : Value(imageUrl),
      watering: watering == null && nullToAbsent ? const Value.absent() : Value(watering),
      wateringMinDays: wateringMinDays == null && nullToAbsent ? const Value.absent() : Value(wateringMinDays),
      wateringMaxDays: wateringMaxDays == null && nullToAbsent ? const Value.absent() : Value(wateringMaxDays),
      wateringWinterMinDays: wateringWinterMinDays == null && nullToAbsent
          ? const Value.absent()
          : Value(wateringWinterMinDays),
      wateringWinterMaxDays: wateringWinterMaxDays == null && nullToAbsent
          ? const Value.absent()
          : Value(wateringWinterMaxDays),
      fertilizeEveryWeeks: fertilizeEveryWeeks == null && nullToAbsent
          ? const Value.absent()
          : Value(fertilizeEveryWeeks),
      sunlight: Value(sunlight),
      careLevel: careLevel == null && nullToAbsent ? const Value.absent() : Value(careLevel),
      indoor: indoor == null && nullToAbsent ? const Value.absent() : Value(indoor),
      poisonousToPets: poisonousToPets == null && nullToAbsent ? const Value.absent() : Value(poisonousToPets),
      pruningMonths: Value(pruningMonths),
      wateringGuide: wateringGuide == null && nullToAbsent ? const Value.absent() : Value(wateringGuide),
      sunlightGuide: sunlightGuide == null && nullToAbsent ? const Value.absent() : Value(sunlightGuide),
      pruningGuide: pruningGuide == null && nullToAbsent ? const Value.absent() : Value(pruningGuide),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory PlantProfileRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantProfileRow(
      plantId: serializer.fromJson<String>(json['plantId']),
      speciesId: serializer.fromJson<int?>(json['speciesId']),
      source: serializer.fromJson<String>(json['source']),
      commonName: serializer.fromJson<String>(json['commonName']),
      scientificName: serializer.fromJson<String?>(json['scientificName']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      watering: serializer.fromJson<String?>(json['watering']),
      wateringMinDays: serializer.fromJson<int?>(json['wateringMinDays']),
      wateringMaxDays: serializer.fromJson<int?>(json['wateringMaxDays']),
      wateringWinterMinDays: serializer.fromJson<int?>(json['wateringWinterMinDays']),
      wateringWinterMaxDays: serializer.fromJson<int?>(json['wateringWinterMaxDays']),
      fertilizeEveryWeeks: serializer.fromJson<int?>(json['fertilizeEveryWeeks']),
      sunlight: serializer.fromJson<String>(json['sunlight']),
      careLevel: serializer.fromJson<String?>(json['careLevel']),
      indoor: serializer.fromJson<bool?>(json['indoor']),
      poisonousToPets: serializer.fromJson<bool?>(json['poisonousToPets']),
      pruningMonths: serializer.fromJson<String>(json['pruningMonths']),
      wateringGuide: serializer.fromJson<String?>(json['wateringGuide']),
      sunlightGuide: serializer.fromJson<String?>(json['sunlightGuide']),
      pruningGuide: serializer.fromJson<String?>(json['pruningGuide']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'plantId': serializer.toJson<String>(plantId),
      'speciesId': serializer.toJson<int?>(speciesId),
      'source': serializer.toJson<String>(source),
      'commonName': serializer.toJson<String>(commonName),
      'scientificName': serializer.toJson<String?>(scientificName),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'watering': serializer.toJson<String?>(watering),
      'wateringMinDays': serializer.toJson<int?>(wateringMinDays),
      'wateringMaxDays': serializer.toJson<int?>(wateringMaxDays),
      'wateringWinterMinDays': serializer.toJson<int?>(wateringWinterMinDays),
      'wateringWinterMaxDays': serializer.toJson<int?>(wateringWinterMaxDays),
      'fertilizeEveryWeeks': serializer.toJson<int?>(fertilizeEveryWeeks),
      'sunlight': serializer.toJson<String>(sunlight),
      'careLevel': serializer.toJson<String?>(careLevel),
      'indoor': serializer.toJson<bool?>(indoor),
      'poisonousToPets': serializer.toJson<bool?>(poisonousToPets),
      'pruningMonths': serializer.toJson<String>(pruningMonths),
      'wateringGuide': serializer.toJson<String?>(wateringGuide),
      'sunlightGuide': serializer.toJson<String?>(sunlightGuide),
      'pruningGuide': serializer.toJson<String?>(pruningGuide),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  PlantProfileRow copyWith({
    String? plantId,
    Value<int?> speciesId = const Value.absent(),
    String? source,
    String? commonName,
    Value<String?> scientificName = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> watering = const Value.absent(),
    Value<int?> wateringMinDays = const Value.absent(),
    Value<int?> wateringMaxDays = const Value.absent(),
    Value<int?> wateringWinterMinDays = const Value.absent(),
    Value<int?> wateringWinterMaxDays = const Value.absent(),
    Value<int?> fertilizeEveryWeeks = const Value.absent(),
    String? sunlight,
    Value<String?> careLevel = const Value.absent(),
    Value<bool?> indoor = const Value.absent(),
    Value<bool?> poisonousToPets = const Value.absent(),
    String? pruningMonths,
    Value<String?> wateringGuide = const Value.absent(),
    Value<String?> sunlightGuide = const Value.absent(),
    Value<String?> pruningGuide = const Value.absent(),
    DateTime? fetchedAt,
  }) => PlantProfileRow(
    plantId: plantId ?? this.plantId,
    speciesId: speciesId.present ? speciesId.value : this.speciesId,
    source: source ?? this.source,
    commonName: commonName ?? this.commonName,
    scientificName: scientificName.present ? scientificName.value : this.scientificName,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    watering: watering.present ? watering.value : this.watering,
    wateringMinDays: wateringMinDays.present ? wateringMinDays.value : this.wateringMinDays,
    wateringMaxDays: wateringMaxDays.present ? wateringMaxDays.value : this.wateringMaxDays,
    wateringWinterMinDays: wateringWinterMinDays.present ? wateringWinterMinDays.value : this.wateringWinterMinDays,
    wateringWinterMaxDays: wateringWinterMaxDays.present ? wateringWinterMaxDays.value : this.wateringWinterMaxDays,
    fertilizeEveryWeeks: fertilizeEveryWeeks.present ? fertilizeEveryWeeks.value : this.fertilizeEveryWeeks,
    sunlight: sunlight ?? this.sunlight,
    careLevel: careLevel.present ? careLevel.value : this.careLevel,
    indoor: indoor.present ? indoor.value : this.indoor,
    poisonousToPets: poisonousToPets.present ? poisonousToPets.value : this.poisonousToPets,
    pruningMonths: pruningMonths ?? this.pruningMonths,
    wateringGuide: wateringGuide.present ? wateringGuide.value : this.wateringGuide,
    sunlightGuide: sunlightGuide.present ? sunlightGuide.value : this.sunlightGuide,
    pruningGuide: pruningGuide.present ? pruningGuide.value : this.pruningGuide,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  PlantProfileRow copyWithCompanion(PlantProfilesTableCompanion data) {
    return PlantProfileRow(
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      source: data.source.present ? data.source.value : this.source,
      commonName: data.commonName.present ? data.commonName.value : this.commonName,
      scientificName: data.scientificName.present ? data.scientificName.value : this.scientificName,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      watering: data.watering.present ? data.watering.value : this.watering,
      wateringMinDays: data.wateringMinDays.present ? data.wateringMinDays.value : this.wateringMinDays,
      wateringMaxDays: data.wateringMaxDays.present ? data.wateringMaxDays.value : this.wateringMaxDays,
      wateringWinterMinDays: data.wateringWinterMinDays.present
          ? data.wateringWinterMinDays.value
          : this.wateringWinterMinDays,
      wateringWinterMaxDays: data.wateringWinterMaxDays.present
          ? data.wateringWinterMaxDays.value
          : this.wateringWinterMaxDays,
      fertilizeEveryWeeks: data.fertilizeEveryWeeks.present ? data.fertilizeEveryWeeks.value : this.fertilizeEveryWeeks,
      sunlight: data.sunlight.present ? data.sunlight.value : this.sunlight,
      careLevel: data.careLevel.present ? data.careLevel.value : this.careLevel,
      indoor: data.indoor.present ? data.indoor.value : this.indoor,
      poisonousToPets: data.poisonousToPets.present ? data.poisonousToPets.value : this.poisonousToPets,
      pruningMonths: data.pruningMonths.present ? data.pruningMonths.value : this.pruningMonths,
      wateringGuide: data.wateringGuide.present ? data.wateringGuide.value : this.wateringGuide,
      sunlightGuide: data.sunlightGuide.present ? data.sunlightGuide.value : this.sunlightGuide,
      pruningGuide: data.pruningGuide.present ? data.pruningGuide.value : this.pruningGuide,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantProfileRow(')
          ..write('plantId: $plantId, ')
          ..write('speciesId: $speciesId, ')
          ..write('source: $source, ')
          ..write('commonName: $commonName, ')
          ..write('scientificName: $scientificName, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('watering: $watering, ')
          ..write('wateringMinDays: $wateringMinDays, ')
          ..write('wateringMaxDays: $wateringMaxDays, ')
          ..write('wateringWinterMinDays: $wateringWinterMinDays, ')
          ..write('wateringWinterMaxDays: $wateringWinterMaxDays, ')
          ..write('fertilizeEveryWeeks: $fertilizeEveryWeeks, ')
          ..write('sunlight: $sunlight, ')
          ..write('careLevel: $careLevel, ')
          ..write('indoor: $indoor, ')
          ..write('poisonousToPets: $poisonousToPets, ')
          ..write('pruningMonths: $pruningMonths, ')
          ..write('wateringGuide: $wateringGuide, ')
          ..write('sunlightGuide: $sunlightGuide, ')
          ..write('pruningGuide: $pruningGuide, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    plantId,
    speciesId,
    source,
    commonName,
    scientificName,
    imageUrl,
    watering,
    wateringMinDays,
    wateringMaxDays,
    wateringWinterMinDays,
    wateringWinterMaxDays,
    fertilizeEveryWeeks,
    sunlight,
    careLevel,
    indoor,
    poisonousToPets,
    pruningMonths,
    wateringGuide,
    sunlightGuide,
    pruningGuide,
    fetchedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantProfileRow &&
          other.plantId == this.plantId &&
          other.speciesId == this.speciesId &&
          other.source == this.source &&
          other.commonName == this.commonName &&
          other.scientificName == this.scientificName &&
          other.imageUrl == this.imageUrl &&
          other.watering == this.watering &&
          other.wateringMinDays == this.wateringMinDays &&
          other.wateringMaxDays == this.wateringMaxDays &&
          other.wateringWinterMinDays == this.wateringWinterMinDays &&
          other.wateringWinterMaxDays == this.wateringWinterMaxDays &&
          other.fertilizeEveryWeeks == this.fertilizeEveryWeeks &&
          other.sunlight == this.sunlight &&
          other.careLevel == this.careLevel &&
          other.indoor == this.indoor &&
          other.poisonousToPets == this.poisonousToPets &&
          other.pruningMonths == this.pruningMonths &&
          other.wateringGuide == this.wateringGuide &&
          other.sunlightGuide == this.sunlightGuide &&
          other.pruningGuide == this.pruningGuide &&
          other.fetchedAt == this.fetchedAt);
}

class PlantProfilesTableCompanion extends UpdateCompanion<PlantProfileRow> {
  final Value<String> plantId;
  final Value<int?> speciesId;
  final Value<String> source;
  final Value<String> commonName;
  final Value<String?> scientificName;
  final Value<String?> imageUrl;
  final Value<String?> watering;
  final Value<int?> wateringMinDays;
  final Value<int?> wateringMaxDays;
  final Value<int?> wateringWinterMinDays;
  final Value<int?> wateringWinterMaxDays;
  final Value<int?> fertilizeEveryWeeks;
  final Value<String> sunlight;
  final Value<String?> careLevel;
  final Value<bool?> indoor;
  final Value<bool?> poisonousToPets;
  final Value<String> pruningMonths;
  final Value<String?> wateringGuide;
  final Value<String?> sunlightGuide;
  final Value<String?> pruningGuide;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const PlantProfilesTableCompanion({
    this.plantId = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.source = const Value.absent(),
    this.commonName = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.watering = const Value.absent(),
    this.wateringMinDays = const Value.absent(),
    this.wateringMaxDays = const Value.absent(),
    this.wateringWinterMinDays = const Value.absent(),
    this.wateringWinterMaxDays = const Value.absent(),
    this.fertilizeEveryWeeks = const Value.absent(),
    this.sunlight = const Value.absent(),
    this.careLevel = const Value.absent(),
    this.indoor = const Value.absent(),
    this.poisonousToPets = const Value.absent(),
    this.pruningMonths = const Value.absent(),
    this.wateringGuide = const Value.absent(),
    this.sunlightGuide = const Value.absent(),
    this.pruningGuide = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlantProfilesTableCompanion.insert({
    required String plantId,
    this.speciesId = const Value.absent(),
    this.source = const Value.absent(),
    required String commonName,
    this.scientificName = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.watering = const Value.absent(),
    this.wateringMinDays = const Value.absent(),
    this.wateringMaxDays = const Value.absent(),
    this.wateringWinterMinDays = const Value.absent(),
    this.wateringWinterMaxDays = const Value.absent(),
    this.fertilizeEveryWeeks = const Value.absent(),
    this.sunlight = const Value.absent(),
    this.careLevel = const Value.absent(),
    this.indoor = const Value.absent(),
    this.poisonousToPets = const Value.absent(),
    this.pruningMonths = const Value.absent(),
    this.wateringGuide = const Value.absent(),
    this.sunlightGuide = const Value.absent(),
    this.pruningGuide = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : plantId = Value(plantId),
       commonName = Value(commonName),
       fetchedAt = Value(fetchedAt);
  static Insertable<PlantProfileRow> custom({
    Expression<String>? plantId,
    Expression<int>? speciesId,
    Expression<String>? source,
    Expression<String>? commonName,
    Expression<String>? scientificName,
    Expression<String>? imageUrl,
    Expression<String>? watering,
    Expression<int>? wateringMinDays,
    Expression<int>? wateringMaxDays,
    Expression<int>? wateringWinterMinDays,
    Expression<int>? wateringWinterMaxDays,
    Expression<int>? fertilizeEveryWeeks,
    Expression<String>? sunlight,
    Expression<String>? careLevel,
    Expression<bool>? indoor,
    Expression<bool>? poisonousToPets,
    Expression<String>? pruningMonths,
    Expression<String>? wateringGuide,
    Expression<String>? sunlightGuide,
    Expression<String>? pruningGuide,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (plantId != null) 'plant_id': plantId,
      if (speciesId != null) 'species_id': speciesId,
      if (source != null) 'source': source,
      if (commonName != null) 'common_name': commonName,
      if (scientificName != null) 'scientific_name': scientificName,
      if (imageUrl != null) 'image_url': imageUrl,
      if (watering != null) 'watering': watering,
      if (wateringMinDays != null) 'watering_min_days': wateringMinDays,
      if (wateringMaxDays != null) 'watering_max_days': wateringMaxDays,
      if (wateringWinterMinDays != null) 'watering_winter_min_days': wateringWinterMinDays,
      if (wateringWinterMaxDays != null) 'watering_winter_max_days': wateringWinterMaxDays,
      if (fertilizeEveryWeeks != null) 'fertilize_every_weeks': fertilizeEveryWeeks,
      if (sunlight != null) 'sunlight': sunlight,
      if (careLevel != null) 'care_level': careLevel,
      if (indoor != null) 'indoor': indoor,
      if (poisonousToPets != null) 'poisonous_to_pets': poisonousToPets,
      if (pruningMonths != null) 'pruning_months': pruningMonths,
      if (wateringGuide != null) 'watering_guide': wateringGuide,
      if (sunlightGuide != null) 'sunlight_guide': sunlightGuide,
      if (pruningGuide != null) 'pruning_guide': pruningGuide,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlantProfilesTableCompanion copyWith({
    Value<String>? plantId,
    Value<int?>? speciesId,
    Value<String>? source,
    Value<String>? commonName,
    Value<String?>? scientificName,
    Value<String?>? imageUrl,
    Value<String?>? watering,
    Value<int?>? wateringMinDays,
    Value<int?>? wateringMaxDays,
    Value<int?>? wateringWinterMinDays,
    Value<int?>? wateringWinterMaxDays,
    Value<int?>? fertilizeEveryWeeks,
    Value<String>? sunlight,
    Value<String?>? careLevel,
    Value<bool?>? indoor,
    Value<bool?>? poisonousToPets,
    Value<String>? pruningMonths,
    Value<String?>? wateringGuide,
    Value<String?>? sunlightGuide,
    Value<String?>? pruningGuide,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return PlantProfilesTableCompanion(
      plantId: plantId ?? this.plantId,
      speciesId: speciesId ?? this.speciesId,
      source: source ?? this.source,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      imageUrl: imageUrl ?? this.imageUrl,
      watering: watering ?? this.watering,
      wateringMinDays: wateringMinDays ?? this.wateringMinDays,
      wateringMaxDays: wateringMaxDays ?? this.wateringMaxDays,
      wateringWinterMinDays: wateringWinterMinDays ?? this.wateringWinterMinDays,
      wateringWinterMaxDays: wateringWinterMaxDays ?? this.wateringWinterMaxDays,
      fertilizeEveryWeeks: fertilizeEveryWeeks ?? this.fertilizeEveryWeeks,
      sunlight: sunlight ?? this.sunlight,
      careLevel: careLevel ?? this.careLevel,
      indoor: indoor ?? this.indoor,
      poisonousToPets: poisonousToPets ?? this.poisonousToPets,
      pruningMonths: pruningMonths ?? this.pruningMonths,
      wateringGuide: wateringGuide ?? this.wateringGuide,
      sunlightGuide: sunlightGuide ?? this.sunlightGuide,
      pruningGuide: pruningGuide ?? this.pruningGuide,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (plantId.present) {
      map['plant_id'] = Variable<String>(plantId.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<int>(speciesId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (commonName.present) {
      map['common_name'] = Variable<String>(commonName.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (watering.present) {
      map['watering'] = Variable<String>(watering.value);
    }
    if (wateringMinDays.present) {
      map['watering_min_days'] = Variable<int>(wateringMinDays.value);
    }
    if (wateringMaxDays.present) {
      map['watering_max_days'] = Variable<int>(wateringMaxDays.value);
    }
    if (wateringWinterMinDays.present) {
      map['watering_winter_min_days'] = Variable<int>(wateringWinterMinDays.value);
    }
    if (wateringWinterMaxDays.present) {
      map['watering_winter_max_days'] = Variable<int>(wateringWinterMaxDays.value);
    }
    if (fertilizeEveryWeeks.present) {
      map['fertilize_every_weeks'] = Variable<int>(fertilizeEveryWeeks.value);
    }
    if (sunlight.present) {
      map['sunlight'] = Variable<String>(sunlight.value);
    }
    if (careLevel.present) {
      map['care_level'] = Variable<String>(careLevel.value);
    }
    if (indoor.present) {
      map['indoor'] = Variable<bool>(indoor.value);
    }
    if (poisonousToPets.present) {
      map['poisonous_to_pets'] = Variable<bool>(poisonousToPets.value);
    }
    if (pruningMonths.present) {
      map['pruning_months'] = Variable<String>(pruningMonths.value);
    }
    if (wateringGuide.present) {
      map['watering_guide'] = Variable<String>(wateringGuide.value);
    }
    if (sunlightGuide.present) {
      map['sunlight_guide'] = Variable<String>(sunlightGuide.value);
    }
    if (pruningGuide.present) {
      map['pruning_guide'] = Variable<String>(pruningGuide.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantProfilesTableCompanion(')
          ..write('plantId: $plantId, ')
          ..write('speciesId: $speciesId, ')
          ..write('source: $source, ')
          ..write('commonName: $commonName, ')
          ..write('scientificName: $scientificName, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('watering: $watering, ')
          ..write('wateringMinDays: $wateringMinDays, ')
          ..write('wateringMaxDays: $wateringMaxDays, ')
          ..write('wateringWinterMinDays: $wateringWinterMinDays, ')
          ..write('wateringWinterMaxDays: $wateringWinterMaxDays, ')
          ..write('fertilizeEveryWeeks: $fertilizeEveryWeeks, ')
          ..write('sunlight: $sunlight, ')
          ..write('careLevel: $careLevel, ')
          ..write('indoor: $indoor, ')
          ..write('poisonousToPets: $poisonousToPets, ')
          ..write('pruningMonths: $pruningMonths, ')
          ..write('wateringGuide: $wateringGuide, ')
          ..write('sunlightGuide: $sunlightGuide, ')
          ..write('pruningGuide: $pruningGuide, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeatherSettingsTableTable extends WeatherSettingsTable
    with TableInfo<$WeatherSettingsTableTable, WeatherSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeLatitudeMeta = const VerificationMeta('placeLatitude');
  @override
  late final GeneratedColumn<double> placeLatitude = GeneratedColumn<double>(
    'place_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeLongitudeMeta = const VerificationMeta('placeLongitude');
  @override
  late final GeneratedColumn<double> placeLongitude = GeneratedColumn<double>(
    'place_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta('placeName');
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeRegionMeta = const VerificationMeta('placeRegion');
  @override
  late final GeneratedColumn<String> placeRegion = GeneratedColumn<String>(
    'place_region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedJsonMeta = const VerificationMeta('cachedJson');
  @override
  late final GeneratedColumn<String> cachedJson = GeneratedColumn<String>(
    'cached_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedLatitudeMeta = const VerificationMeta('cachedLatitude');
  @override
  late final GeneratedColumn<double> cachedLatitude = GeneratedColumn<double>(
    'cached_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedLongitudeMeta = const VerificationMeta('cachedLongitude');
  @override
  late final GeneratedColumn<double> cachedLongitude = GeneratedColumn<double>(
    'cached_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedPlaceNameMeta = const VerificationMeta('cachedPlaceName');
  @override
  late final GeneratedColumn<String> cachedPlaceName = GeneratedColumn<String>(
    'cached_place_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placeLatitude,
    placeLongitude,
    placeName,
    placeRegion,
    cachedJson,
    cachedLatitude,
    cachedLongitude,
    cachedPlaceName,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_settings';
  @override
  VerificationContext validateIntegrity(Insertable<WeatherSettingsRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('place_latitude')) {
      context.handle(
        _placeLatitudeMeta,
        placeLatitude.isAcceptableOrUnknown(data['place_latitude']!, _placeLatitudeMeta),
      );
    }
    if (data.containsKey('place_longitude')) {
      context.handle(
        _placeLongitudeMeta,
        placeLongitude.isAcceptableOrUnknown(data['place_longitude']!, _placeLongitudeMeta),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(_placeNameMeta, placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta));
    }
    if (data.containsKey('place_region')) {
      context.handle(_placeRegionMeta, placeRegion.isAcceptableOrUnknown(data['place_region']!, _placeRegionMeta));
    }
    if (data.containsKey('cached_json')) {
      context.handle(_cachedJsonMeta, cachedJson.isAcceptableOrUnknown(data['cached_json']!, _cachedJsonMeta));
    }
    if (data.containsKey('cached_latitude')) {
      context.handle(
        _cachedLatitudeMeta,
        cachedLatitude.isAcceptableOrUnknown(data['cached_latitude']!, _cachedLatitudeMeta),
      );
    }
    if (data.containsKey('cached_longitude')) {
      context.handle(
        _cachedLongitudeMeta,
        cachedLongitude.isAcceptableOrUnknown(data['cached_longitude']!, _cachedLongitudeMeta),
      );
    }
    if (data.containsKey('cached_place_name')) {
      context.handle(
        _cachedPlaceNameMeta,
        cachedPlaceName.isAcceptableOrUnknown(data['cached_place_name']!, _cachedPlaceNameMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta, cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeatherSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherSettingsRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      placeLatitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}place_latitude']),
      placeLongitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}place_longitude']),
      placeName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_name']),
      placeRegion: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_region']),
      cachedJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}cached_json']),
      cachedLatitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}cached_latitude']),
      cachedLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cached_longitude'],
      ),
      cachedPlaceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_place_name'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at']),
    );
  }

  @override
  $WeatherSettingsTableTable createAlias(String alias) {
    return $WeatherSettingsTableTable(attachedDatabase, alias);
  }
}

class WeatherSettingsRow extends DataClass implements Insertable<WeatherSettingsRow> {
  final int id;

  /// A chosen place; all `null` = where the hub is.
  final double? placeLatitude;
  final double? placeLongitude;
  final String? placeName;
  final String? placeRegion;

  /// The last answer of the weather service, where it was for and when.
  final String? cachedJson;
  final double? cachedLatitude;
  final double? cachedLongitude;
  final String? cachedPlaceName;
  final DateTime? cachedAt;
  const WeatherSettingsRow({
    required this.id,
    this.placeLatitude,
    this.placeLongitude,
    this.placeName,
    this.placeRegion,
    this.cachedJson,
    this.cachedLatitude,
    this.cachedLongitude,
    this.cachedPlaceName,
    this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || placeLatitude != null) {
      map['place_latitude'] = Variable<double>(placeLatitude);
    }
    if (!nullToAbsent || placeLongitude != null) {
      map['place_longitude'] = Variable<double>(placeLongitude);
    }
    if (!nullToAbsent || placeName != null) {
      map['place_name'] = Variable<String>(placeName);
    }
    if (!nullToAbsent || placeRegion != null) {
      map['place_region'] = Variable<String>(placeRegion);
    }
    if (!nullToAbsent || cachedJson != null) {
      map['cached_json'] = Variable<String>(cachedJson);
    }
    if (!nullToAbsent || cachedLatitude != null) {
      map['cached_latitude'] = Variable<double>(cachedLatitude);
    }
    if (!nullToAbsent || cachedLongitude != null) {
      map['cached_longitude'] = Variable<double>(cachedLongitude);
    }
    if (!nullToAbsent || cachedPlaceName != null) {
      map['cached_place_name'] = Variable<String>(cachedPlaceName);
    }
    if (!nullToAbsent || cachedAt != null) {
      map['cached_at'] = Variable<DateTime>(cachedAt);
    }
    return map;
  }

  WeatherSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return WeatherSettingsTableCompanion(
      id: Value(id),
      placeLatitude: placeLatitude == null && nullToAbsent ? const Value.absent() : Value(placeLatitude),
      placeLongitude: placeLongitude == null && nullToAbsent ? const Value.absent() : Value(placeLongitude),
      placeName: placeName == null && nullToAbsent ? const Value.absent() : Value(placeName),
      placeRegion: placeRegion == null && nullToAbsent ? const Value.absent() : Value(placeRegion),
      cachedJson: cachedJson == null && nullToAbsent ? const Value.absent() : Value(cachedJson),
      cachedLatitude: cachedLatitude == null && nullToAbsent ? const Value.absent() : Value(cachedLatitude),
      cachedLongitude: cachedLongitude == null && nullToAbsent ? const Value.absent() : Value(cachedLongitude),
      cachedPlaceName: cachedPlaceName == null && nullToAbsent ? const Value.absent() : Value(cachedPlaceName),
      cachedAt: cachedAt == null && nullToAbsent ? const Value.absent() : Value(cachedAt),
    );
  }

  factory WeatherSettingsRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      placeLatitude: serializer.fromJson<double?>(json['placeLatitude']),
      placeLongitude: serializer.fromJson<double?>(json['placeLongitude']),
      placeName: serializer.fromJson<String?>(json['placeName']),
      placeRegion: serializer.fromJson<String?>(json['placeRegion']),
      cachedJson: serializer.fromJson<String?>(json['cachedJson']),
      cachedLatitude: serializer.fromJson<double?>(json['cachedLatitude']),
      cachedLongitude: serializer.fromJson<double?>(json['cachedLongitude']),
      cachedPlaceName: serializer.fromJson<String?>(json['cachedPlaceName']),
      cachedAt: serializer.fromJson<DateTime?>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'placeLatitude': serializer.toJson<double?>(placeLatitude),
      'placeLongitude': serializer.toJson<double?>(placeLongitude),
      'placeName': serializer.toJson<String?>(placeName),
      'placeRegion': serializer.toJson<String?>(placeRegion),
      'cachedJson': serializer.toJson<String?>(cachedJson),
      'cachedLatitude': serializer.toJson<double?>(cachedLatitude),
      'cachedLongitude': serializer.toJson<double?>(cachedLongitude),
      'cachedPlaceName': serializer.toJson<String?>(cachedPlaceName),
      'cachedAt': serializer.toJson<DateTime?>(cachedAt),
    };
  }

  WeatherSettingsRow copyWith({
    int? id,
    Value<double?> placeLatitude = const Value.absent(),
    Value<double?> placeLongitude = const Value.absent(),
    Value<String?> placeName = const Value.absent(),
    Value<String?> placeRegion = const Value.absent(),
    Value<String?> cachedJson = const Value.absent(),
    Value<double?> cachedLatitude = const Value.absent(),
    Value<double?> cachedLongitude = const Value.absent(),
    Value<String?> cachedPlaceName = const Value.absent(),
    Value<DateTime?> cachedAt = const Value.absent(),
  }) => WeatherSettingsRow(
    id: id ?? this.id,
    placeLatitude: placeLatitude.present ? placeLatitude.value : this.placeLatitude,
    placeLongitude: placeLongitude.present ? placeLongitude.value : this.placeLongitude,
    placeName: placeName.present ? placeName.value : this.placeName,
    placeRegion: placeRegion.present ? placeRegion.value : this.placeRegion,
    cachedJson: cachedJson.present ? cachedJson.value : this.cachedJson,
    cachedLatitude: cachedLatitude.present ? cachedLatitude.value : this.cachedLatitude,
    cachedLongitude: cachedLongitude.present ? cachedLongitude.value : this.cachedLongitude,
    cachedPlaceName: cachedPlaceName.present ? cachedPlaceName.value : this.cachedPlaceName,
    cachedAt: cachedAt.present ? cachedAt.value : this.cachedAt,
  );
  WeatherSettingsRow copyWithCompanion(WeatherSettingsTableCompanion data) {
    return WeatherSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      placeLatitude: data.placeLatitude.present ? data.placeLatitude.value : this.placeLatitude,
      placeLongitude: data.placeLongitude.present ? data.placeLongitude.value : this.placeLongitude,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      placeRegion: data.placeRegion.present ? data.placeRegion.value : this.placeRegion,
      cachedJson: data.cachedJson.present ? data.cachedJson.value : this.cachedJson,
      cachedLatitude: data.cachedLatitude.present ? data.cachedLatitude.value : this.cachedLatitude,
      cachedLongitude: data.cachedLongitude.present ? data.cachedLongitude.value : this.cachedLongitude,
      cachedPlaceName: data.cachedPlaceName.present ? data.cachedPlaceName.value : this.cachedPlaceName,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherSettingsRow(')
          ..write('id: $id, ')
          ..write('placeLatitude: $placeLatitude, ')
          ..write('placeLongitude: $placeLongitude, ')
          ..write('placeName: $placeName, ')
          ..write('placeRegion: $placeRegion, ')
          ..write('cachedJson: $cachedJson, ')
          ..write('cachedLatitude: $cachedLatitude, ')
          ..write('cachedLongitude: $cachedLongitude, ')
          ..write('cachedPlaceName: $cachedPlaceName, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    placeLatitude,
    placeLongitude,
    placeName,
    placeRegion,
    cachedJson,
    cachedLatitude,
    cachedLongitude,
    cachedPlaceName,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherSettingsRow &&
          other.id == this.id &&
          other.placeLatitude == this.placeLatitude &&
          other.placeLongitude == this.placeLongitude &&
          other.placeName == this.placeName &&
          other.placeRegion == this.placeRegion &&
          other.cachedJson == this.cachedJson &&
          other.cachedLatitude == this.cachedLatitude &&
          other.cachedLongitude == this.cachedLongitude &&
          other.cachedPlaceName == this.cachedPlaceName &&
          other.cachedAt == this.cachedAt);
}

class WeatherSettingsTableCompanion extends UpdateCompanion<WeatherSettingsRow> {
  final Value<int> id;
  final Value<double?> placeLatitude;
  final Value<double?> placeLongitude;
  final Value<String?> placeName;
  final Value<String?> placeRegion;
  final Value<String?> cachedJson;
  final Value<double?> cachedLatitude;
  final Value<double?> cachedLongitude;
  final Value<String?> cachedPlaceName;
  final Value<DateTime?> cachedAt;
  const WeatherSettingsTableCompanion({
    this.id = const Value.absent(),
    this.placeLatitude = const Value.absent(),
    this.placeLongitude = const Value.absent(),
    this.placeName = const Value.absent(),
    this.placeRegion = const Value.absent(),
    this.cachedJson = const Value.absent(),
    this.cachedLatitude = const Value.absent(),
    this.cachedLongitude = const Value.absent(),
    this.cachedPlaceName = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  WeatherSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.placeLatitude = const Value.absent(),
    this.placeLongitude = const Value.absent(),
    this.placeName = const Value.absent(),
    this.placeRegion = const Value.absent(),
    this.cachedJson = const Value.absent(),
    this.cachedLatitude = const Value.absent(),
    this.cachedLongitude = const Value.absent(),
    this.cachedPlaceName = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  static Insertable<WeatherSettingsRow> custom({
    Expression<int>? id,
    Expression<double>? placeLatitude,
    Expression<double>? placeLongitude,
    Expression<String>? placeName,
    Expression<String>? placeRegion,
    Expression<String>? cachedJson,
    Expression<double>? cachedLatitude,
    Expression<double>? cachedLongitude,
    Expression<String>? cachedPlaceName,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeLatitude != null) 'place_latitude': placeLatitude,
      if (placeLongitude != null) 'place_longitude': placeLongitude,
      if (placeName != null) 'place_name': placeName,
      if (placeRegion != null) 'place_region': placeRegion,
      if (cachedJson != null) 'cached_json': cachedJson,
      if (cachedLatitude != null) 'cached_latitude': cachedLatitude,
      if (cachedLongitude != null) 'cached_longitude': cachedLongitude,
      if (cachedPlaceName != null) 'cached_place_name': cachedPlaceName,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  WeatherSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<double?>? placeLatitude,
    Value<double?>? placeLongitude,
    Value<String?>? placeName,
    Value<String?>? placeRegion,
    Value<String?>? cachedJson,
    Value<double?>? cachedLatitude,
    Value<double?>? cachedLongitude,
    Value<String?>? cachedPlaceName,
    Value<DateTime?>? cachedAt,
  }) {
    return WeatherSettingsTableCompanion(
      id: id ?? this.id,
      placeLatitude: placeLatitude ?? this.placeLatitude,
      placeLongitude: placeLongitude ?? this.placeLongitude,
      placeName: placeName ?? this.placeName,
      placeRegion: placeRegion ?? this.placeRegion,
      cachedJson: cachedJson ?? this.cachedJson,
      cachedLatitude: cachedLatitude ?? this.cachedLatitude,
      cachedLongitude: cachedLongitude ?? this.cachedLongitude,
      cachedPlaceName: cachedPlaceName ?? this.cachedPlaceName,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (placeLatitude.present) {
      map['place_latitude'] = Variable<double>(placeLatitude.value);
    }
    if (placeLongitude.present) {
      map['place_longitude'] = Variable<double>(placeLongitude.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (placeRegion.present) {
      map['place_region'] = Variable<String>(placeRegion.value);
    }
    if (cachedJson.present) {
      map['cached_json'] = Variable<String>(cachedJson.value);
    }
    if (cachedLatitude.present) {
      map['cached_latitude'] = Variable<double>(cachedLatitude.value);
    }
    if (cachedLongitude.present) {
      map['cached_longitude'] = Variable<double>(cachedLongitude.value);
    }
    if (cachedPlaceName.present) {
      map['cached_place_name'] = Variable<String>(cachedPlaceName.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('placeLatitude: $placeLatitude, ')
          ..write('placeLongitude: $placeLongitude, ')
          ..write('placeName: $placeName, ')
          ..write('placeRegion: $placeRegion, ')
          ..write('cachedJson: $cachedJson, ')
          ..write('cachedLatitude: $cachedLatitude, ')
          ..write('cachedLongitude: $cachedLongitude, ')
          ..write('cachedPlaceName: $cachedPlaceName, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $DashboardWidgetsTableTable extends DashboardWidgetsTable
    with TableInfo<$DashboardWidgetsTableTable, DashboardWidgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardWidgetsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectionMeta = const VerificationMeta('selection');
  @override
  late final GeneratedColumn<String> selection = GeneratedColumn<String>(
    'selection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardMeta = const VerificationMeta('card');
  @override
  late final GeneratedColumn<bool> card = GeneratedColumn<bool>(
    'card',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("card" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, size, position, selection, card];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_widgets';
  @override
  VerificationContext validateIntegrity(Insertable<DashboardWidgetRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('size')) {
      context.handle(_sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('selection')) {
      context.handle(_selectionMeta, selection.isAcceptableOrUnknown(data['selection']!, _selectionMeta));
    }
    if (data.containsKey('card')) {
      context.handle(_cardMeta, card.isAcceptableOrUnknown(data['card']!, _cardMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DashboardWidgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardWidgetRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      size: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}size'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      selection: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}selection']),
      card: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}card']),
    );
  }

  @override
  $DashboardWidgetsTableTable createAlias(String alias) {
    return $DashboardWidgetsTableTable(attachedDatabase, alias);
  }
}

class DashboardWidgetRow extends DataClass implements Insertable<DashboardWidgetRow> {
  final String id;

  /// `DashboardWidgetKind` name.
  final String kind;

  /// `DashboardWidgetSize` name.
  final String size;
  final int position;

  /// `DashboardWidget.selection` as a JSON list; `null` when chosen automatically.
  final String? selection;

  /// `DashboardWidget.card`; `null` when the kind decides.
  final bool? card;
  const DashboardWidgetRow({
    required this.id,
    required this.kind,
    required this.size,
    required this.position,
    this.selection,
    this.card,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['size'] = Variable<String>(size);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || selection != null) {
      map['selection'] = Variable<String>(selection);
    }
    if (!nullToAbsent || card != null) {
      map['card'] = Variable<bool>(card);
    }
    return map;
  }

  DashboardWidgetsTableCompanion toCompanion(bool nullToAbsent) {
    return DashboardWidgetsTableCompanion(
      id: Value(id),
      kind: Value(kind),
      size: Value(size),
      position: Value(position),
      selection: selection == null && nullToAbsent ? const Value.absent() : Value(selection),
      card: card == null && nullToAbsent ? const Value.absent() : Value(card),
    );
  }

  factory DashboardWidgetRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardWidgetRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      size: serializer.fromJson<String>(json['size']),
      position: serializer.fromJson<int>(json['position']),
      selection: serializer.fromJson<String?>(json['selection']),
      card: serializer.fromJson<bool?>(json['card']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'size': serializer.toJson<String>(size),
      'position': serializer.toJson<int>(position),
      'selection': serializer.toJson<String?>(selection),
      'card': serializer.toJson<bool?>(card),
    };
  }

  DashboardWidgetRow copyWith({
    String? id,
    String? kind,
    String? size,
    int? position,
    Value<String?> selection = const Value.absent(),
    Value<bool?> card = const Value.absent(),
  }) => DashboardWidgetRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    size: size ?? this.size,
    position: position ?? this.position,
    selection: selection.present ? selection.value : this.selection,
    card: card.present ? card.value : this.card,
  );
  DashboardWidgetRow copyWithCompanion(DashboardWidgetsTableCompanion data) {
    return DashboardWidgetRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      size: data.size.present ? data.size.value : this.size,
      position: data.position.present ? data.position.value : this.position,
      selection: data.selection.present ? data.selection.value : this.selection,
      card: data.card.present ? data.card.value : this.card,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardWidgetRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('size: $size, ')
          ..write('position: $position, ')
          ..write('selection: $selection, ')
          ..write('card: $card')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, size, position, selection, card);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardWidgetRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.size == this.size &&
          other.position == this.position &&
          other.selection == this.selection &&
          other.card == this.card);
}

class DashboardWidgetsTableCompanion extends UpdateCompanion<DashboardWidgetRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> size;
  final Value<int> position;
  final Value<String?> selection;
  final Value<bool?> card;
  final Value<int> rowid;
  const DashboardWidgetsTableCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.size = const Value.absent(),
    this.position = const Value.absent(),
    this.selection = const Value.absent(),
    this.card = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardWidgetsTableCompanion.insert({
    required String id,
    required String kind,
    required String size,
    required int position,
    this.selection = const Value.absent(),
    this.card = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       size = Value(size),
       position = Value(position);
  static Insertable<DashboardWidgetRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? size,
    Expression<int>? position,
    Expression<String>? selection,
    Expression<bool>? card,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (size != null) 'size': size,
      if (position != null) 'position': position,
      if (selection != null) 'selection': selection,
      if (card != null) 'card': card,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardWidgetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? size,
    Value<int>? position,
    Value<String?>? selection,
    Value<bool?>? card,
    Value<int>? rowid,
  }) {
    return DashboardWidgetsTableCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      size: size ?? this.size,
      position: position ?? this.position,
      selection: selection ?? this.selection,
      card: card ?? this.card,
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
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (selection.present) {
      map['selection'] = Variable<String>(selection.value);
    }
    if (card.present) {
      map['card'] = Variable<bool>(card.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardWidgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('size: $size, ')
          ..write('position: $position, ')
          ..write('selection: $selection, ')
          ..write('card: $card, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DashboardStateTableTable extends DashboardStateTable
    with TableInfo<$DashboardStateTableTable, DashboardStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrangedMeta = const VerificationMeta('arranged');
  @override
  late final GeneratedColumn<bool> arranged = GeneratedColumn<bool>(
    'arranged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("arranged" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, arranged];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_state';
  @override
  VerificationContext validateIntegrity(Insertable<DashboardStateRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arranged')) {
      context.handle(_arrangedMeta, arranged.isAcceptableOrUnknown(data['arranged']!, _arrangedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DashboardStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardStateRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      arranged: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}arranged'])!,
    );
  }

  @override
  $DashboardStateTableTable createAlias(String alias) {
    return $DashboardStateTableTable(attachedDatabase, alias);
  }
}

class DashboardStateRow extends DataClass implements Insertable<DashboardStateRow> {
  final int id;
  final bool arranged;
  const DashboardStateRow({required this.id, required this.arranged});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arranged'] = Variable<bool>(arranged);
    return map;
  }

  DashboardStateTableCompanion toCompanion(bool nullToAbsent) {
    return DashboardStateTableCompanion(id: Value(id), arranged: Value(arranged));
  }

  factory DashboardStateRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardStateRow(
      id: serializer.fromJson<int>(json['id']),
      arranged: serializer.fromJson<bool>(json['arranged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<int>(id), 'arranged': serializer.toJson<bool>(arranged)};
  }

  DashboardStateRow copyWith({int? id, bool? arranged}) =>
      DashboardStateRow(id: id ?? this.id, arranged: arranged ?? this.arranged);
  DashboardStateRow copyWithCompanion(DashboardStateTableCompanion data) {
    return DashboardStateRow(
      id: data.id.present ? data.id.value : this.id,
      arranged: data.arranged.present ? data.arranged.value : this.arranged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardStateRow(')
          ..write('id: $id, ')
          ..write('arranged: $arranged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, arranged);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DashboardStateRow && other.id == this.id && other.arranged == this.arranged);
}

class DashboardStateTableCompanion extends UpdateCompanion<DashboardStateRow> {
  final Value<int> id;
  final Value<bool> arranged;
  const DashboardStateTableCompanion({this.id = const Value.absent(), this.arranged = const Value.absent()});
  DashboardStateTableCompanion.insert({this.id = const Value.absent(), this.arranged = const Value.absent()});
  static Insertable<DashboardStateRow> custom({Expression<int>? id, Expression<bool>? arranged}) {
    return RawValuesInsertable({if (id != null) 'id': id, if (arranged != null) 'arranged': arranged});
  }

  DashboardStateTableCompanion copyWith({Value<int>? id, Value<bool>? arranged}) {
    return DashboardStateTableCompanion(id: id ?? this.id, arranged: arranged ?? this.arranged);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arranged.present) {
      map['arranged'] = Variable<bool>(arranged.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardStateTableCompanion(')
          ..write('id: $id, ')
          ..write('arranged: $arranged')
          ..write(')'))
        .toString();
  }
}

class $RoomScenesTableTable extends RoomScenesTable with TableInfo<$RoomScenesTableTable, RoomSceneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomScenesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
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
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brightnessPercentMeta = const VerificationMeta('brightnessPercent');
  @override
  late final GeneratedColumn<int> brightnessPercent = GeneratedColumn<int>(
    'brightness_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kelvinMeta = const VerificationMeta('kelvin');
  @override
  late final GeneratedColumn<int> kelvin = GeneratedColumn<int>(
    'kelvin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lightsMeta = const VerificationMeta('lights');
  @override
  late final GeneratedColumn<String> lights = GeneratedColumn<String>(
    'lights',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, roomId, name, position, brightnessPercent, color, kelvin, lights];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_scenes';
  @override
  VerificationContext validateIntegrity(Insertable<RoomSceneRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(_roomIdMeta, roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta));
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('brightness_percent')) {
      context.handle(
        _brightnessPercentMeta,
        brightnessPercent.isAcceptableOrUnknown(data['brightness_percent']!, _brightnessPercentMeta),
      );
    } else if (isInserting) {
      context.missing(_brightnessPercentMeta);
    }
    if (data.containsKey('color')) {
      context.handle(_colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('kelvin')) {
      context.handle(_kelvinMeta, kelvin.isAcceptableOrUnknown(data['kelvin']!, _kelvinMeta));
    } else if (isInserting) {
      context.missing(_kelvinMeta);
    }
    if (data.containsKey('lights')) {
      context.handle(_lightsMeta, lights.isAcceptableOrUnknown(data['lights']!, _lightsMeta));
    } else if (isInserting) {
      context.missing(_lightsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomSceneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomSceneRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      roomId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}room_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      brightnessPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brightness_percent'],
      )!,
      color: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      kelvin: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}kelvin'])!,
      lights: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}lights'])!,
    );
  }

  @override
  $RoomScenesTableTable createAlias(String alias) {
    return $RoomScenesTableTable(attachedDatabase, alias);
  }
}

class RoomSceneRow extends DataClass implements Insertable<RoomSceneRow> {
  final String id;
  final String roomId;
  final String name;
  final int position;
  final int brightnessPercent;

  /// `0xFFRRGGBB`.
  final int color;
  final int kelvin;

  /// `RoomScene.lights` as JSON: light id → {on, brightness, color, kelvin}.
  final String lights;
  const RoomSceneRow({
    required this.id,
    required this.roomId,
    required this.name,
    required this.position,
    required this.brightnessPercent,
    required this.color,
    required this.kelvin,
    required this.lights,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    map['brightness_percent'] = Variable<int>(brightnessPercent);
    map['color'] = Variable<int>(color);
    map['kelvin'] = Variable<int>(kelvin);
    map['lights'] = Variable<String>(lights);
    return map;
  }

  RoomScenesTableCompanion toCompanion(bool nullToAbsent) {
    return RoomScenesTableCompanion(
      id: Value(id),
      roomId: Value(roomId),
      name: Value(name),
      position: Value(position),
      brightnessPercent: Value(brightnessPercent),
      color: Value(color),
      kelvin: Value(kelvin),
      lights: Value(lights),
    );
  }

  factory RoomSceneRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomSceneRow(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
      brightnessPercent: serializer.fromJson<int>(json['brightnessPercent']),
      color: serializer.fromJson<int>(json['color']),
      kelvin: serializer.fromJson<int>(json['kelvin']),
      lights: serializer.fromJson<String>(json['lights']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
      'brightnessPercent': serializer.toJson<int>(brightnessPercent),
      'color': serializer.toJson<int>(color),
      'kelvin': serializer.toJson<int>(kelvin),
      'lights': serializer.toJson<String>(lights),
    };
  }

  RoomSceneRow copyWith({
    String? id,
    String? roomId,
    String? name,
    int? position,
    int? brightnessPercent,
    int? color,
    int? kelvin,
    String? lights,
  }) => RoomSceneRow(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    name: name ?? this.name,
    position: position ?? this.position,
    brightnessPercent: brightnessPercent ?? this.brightnessPercent,
    color: color ?? this.color,
    kelvin: kelvin ?? this.kelvin,
    lights: lights ?? this.lights,
  );
  RoomSceneRow copyWithCompanion(RoomScenesTableCompanion data) {
    return RoomSceneRow(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
      brightnessPercent: data.brightnessPercent.present ? data.brightnessPercent.value : this.brightnessPercent,
      color: data.color.present ? data.color.value : this.color,
      kelvin: data.kelvin.present ? data.kelvin.value : this.kelvin,
      lights: data.lights.present ? data.lights.value : this.lights,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomSceneRow(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('brightnessPercent: $brightnessPercent, ')
          ..write('color: $color, ')
          ..write('kelvin: $kelvin, ')
          ..write('lights: $lights')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, roomId, name, position, brightnessPercent, color, kelvin, lights);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomSceneRow &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.name == this.name &&
          other.position == this.position &&
          other.brightnessPercent == this.brightnessPercent &&
          other.color == this.color &&
          other.kelvin == this.kelvin &&
          other.lights == this.lights);
}

class RoomScenesTableCompanion extends UpdateCompanion<RoomSceneRow> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<String> name;
  final Value<int> position;
  final Value<int> brightnessPercent;
  final Value<int> color;
  final Value<int> kelvin;
  final Value<String> lights;
  final Value<int> rowid;
  const RoomScenesTableCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
    this.brightnessPercent = const Value.absent(),
    this.color = const Value.absent(),
    this.kelvin = const Value.absent(),
    this.lights = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomScenesTableCompanion.insert({
    required String id,
    required String roomId,
    required String name,
    required int position,
    required int brightnessPercent,
    required int color,
    required int kelvin,
    required String lights,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       name = Value(name),
       position = Value(position),
       brightnessPercent = Value(brightnessPercent),
       color = Value(color),
       kelvin = Value(kelvin),
       lights = Value(lights);
  static Insertable<RoomSceneRow> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? name,
    Expression<int>? position,
    Expression<int>? brightnessPercent,
    Expression<int>? color,
    Expression<int>? kelvin,
    Expression<String>? lights,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
      if (brightnessPercent != null) 'brightness_percent': brightnessPercent,
      if (color != null) 'color': color,
      if (kelvin != null) 'kelvin': kelvin,
      if (lights != null) 'lights': lights,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomScenesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<String>? name,
    Value<int>? position,
    Value<int>? brightnessPercent,
    Value<int>? color,
    Value<int>? kelvin,
    Value<String>? lights,
    Value<int>? rowid,
  }) {
    return RoomScenesTableCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      position: position ?? this.position,
      brightnessPercent: brightnessPercent ?? this.brightnessPercent,
      color: color ?? this.color,
      kelvin: kelvin ?? this.kelvin,
      lights: lights ?? this.lights,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (brightnessPercent.present) {
      map['brightness_percent'] = Variable<int>(brightnessPercent.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (kelvin.present) {
      map['kelvin'] = Variable<int>(kelvin.value);
    }
    if (lights.present) {
      map['lights'] = Variable<String>(lights.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomScenesTableCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('brightnessPercent: $brightnessPercent, ')
          ..write('color: $color, ')
          ..write('kelvin: $kelvin, ')
          ..write('lights: $lights, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FloorPlansTableTable floorPlansTable = $FloorPlansTableTable(this);
  late final $PlacementsTableTable placementsTable = $PlacementsTableTable(this);
  late final $PlantsTableTable plantsTable = $PlantsTableTable(this);
  late final $SpeakerSettingsTableTable speakerSettingsTable = $SpeakerSettingsTableTable(this);
  late final $ZenSettingsTableTable zenSettingsTable = $ZenSettingsTableTable(this);
  late final $PlantProfilesTableTable plantProfilesTable = $PlantProfilesTableTable(this);
  late final $WeatherSettingsTableTable weatherSettingsTable = $WeatherSettingsTableTable(this);
  late final $DashboardWidgetsTableTable dashboardWidgetsTable = $DashboardWidgetsTableTable(this);
  late final $DashboardStateTableTable dashboardStateTable = $DashboardStateTableTable(this);
  late final $RoomScenesTableTable roomScenesTable = $RoomScenesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    floorPlansTable,
    placementsTable,
    plantsTable,
    speakerSettingsTable,
    zenSettingsTable,
    plantProfilesTable,
    weatherSettingsTable,
    dashboardWidgetsTable,
    dashboardStateTable,
    roomScenesTable,
  ];
  @override
  DriftDatabaseOptions get options => const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$FloorPlansTableTableCreateCompanionBuilder = FloorPlansTableCompanion Function({
  Value<int> id,
  required String json,
});
typedef $$FloorPlansTableTableUpdateCompanionBuilder = FloorPlansTableCompanion Function({
  Value<int> id,
  Value<String> json,
});

class $$FloorPlansTableTableFilterComposer extends Composer<_$AppDatabase, $FloorPlansTableTable> {
  $$FloorPlansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(column: $table.json, builder: (column) => ColumnFilters(column));
}

class $$FloorPlansTableTableOrderingComposer extends Composer<_$AppDatabase, $FloorPlansTableTable> {
  $$FloorPlansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnOrderings(column));
}

class $$FloorPlansTableTableAnnotationComposer extends Composer<_$AppDatabase, $FloorPlansTableTable> {
  $$FloorPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json => $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$FloorPlansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FloorPlansTableTable,
          FloorPlanRow,
          $$FloorPlansTableTableFilterComposer,
          $$FloorPlansTableTableOrderingComposer,
          $$FloorPlansTableTableAnnotationComposer,
          $$FloorPlansTableTableCreateCompanionBuilder,
          $$FloorPlansTableTableUpdateCompanionBuilder,
          (FloorPlanRow, BaseReferences<_$AppDatabase, $FloorPlansTableTable, FloorPlanRow>),
          FloorPlanRow,
          PrefetchHooks Function()
        > {
  $$FloorPlansTableTableTableManager(_$AppDatabase db, $FloorPlansTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FloorPlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$FloorPlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$FloorPlansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> json = const Value.absent(),
          }) => FloorPlansTableCompanion(id: id, json: json),
          createCompanionCallback: ({Value<int> id = const Value.absent(), required String json}) =>
              FloorPlansTableCompanion.insert(id: id, json: json),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FloorPlansTableTable, FloorPlanRow>(table),
                  BaseReferences<_$AppDatabase, $FloorPlansTableTable, FloorPlanRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FloorPlansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FloorPlansTableTable,
      FloorPlanRow,
      $$FloorPlansTableTableFilterComposer,
      $$FloorPlansTableTableOrderingComposer,
      $$FloorPlansTableTableAnnotationComposer,
      $$FloorPlansTableTableCreateCompanionBuilder,
      $$FloorPlansTableTableUpdateCompanionBuilder,
      (FloorPlanRow, BaseReferences<_$AppDatabase, $FloorPlansTableTable, FloorPlanRow>),
      FloorPlanRow,
      PrefetchHooks Function()
    >;
typedef $$PlacementsTableTableCreateCompanionBuilder = PlacementsTableCompanion Function({
  required String deviceId,
  required DeviceKind kind,
  required double x,
  required double y,
  Value<int> rowid,
});
typedef $$PlacementsTableTableUpdateCompanionBuilder = PlacementsTableCompanion Function({
  Value<String> deviceId,
  Value<DeviceKind> kind,
  Value<double> x,
  Value<double> y,
  Value<int> rowid,
});

class $$PlacementsTableTableFilterComposer extends Composer<_$AppDatabase, $PlacementsTableTable> {
  $$PlacementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DeviceKind, DeviceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get x => $composableBuilder(column: $table.x, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get y => $composableBuilder(column: $table.y, builder: (column) => ColumnFilters(column));
}

class $$PlacementsTableTableOrderingComposer extends Composer<_$AppDatabase, $PlacementsTableTable> {
  $$PlacementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get x => $composableBuilder(column: $table.x, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get y => $composableBuilder(column: $table.y, builder: (column) => ColumnOrderings(column));
}

class $$PlacementsTableTableAnnotationComposer extends Composer<_$AppDatabase, $PlacementsTableTable> {
  $$PlacementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId => $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DeviceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get x => $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y => $composableBuilder(column: $table.y, builder: (column) => column);
}

class $$PlacementsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacementsTableTable,
          PlacementRow,
          $$PlacementsTableTableFilterComposer,
          $$PlacementsTableTableOrderingComposer,
          $$PlacementsTableTableAnnotationComposer,
          $$PlacementsTableTableCreateCompanionBuilder,
          $$PlacementsTableTableUpdateCompanionBuilder,
          (PlacementRow, BaseReferences<_$AppDatabase, $PlacementsTableTable, PlacementRow>),
          PlacementRow,
          PrefetchHooks Function()
        > {
  $$PlacementsTableTableTableManager(_$AppDatabase db, $PlacementsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlacementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlacementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlacementsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> deviceId = const Value.absent(),
            Value<DeviceKind> kind = const Value.absent(),
            Value<double> x = const Value.absent(),
            Value<double> y = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PlacementsTableCompanion(deviceId: deviceId, kind: kind, x: x, y: y, rowid: rowid),
          createCompanionCallback: ({
            required String deviceId,
            required DeviceKind kind,
            required double x,
            required double y,
            Value<int> rowid = const Value.absent(),
          }) => PlacementsTableCompanion.insert(deviceId: deviceId, kind: kind, x: x, y: y, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacementsTableTable, PlacementRow>(table),
                  BaseReferences<_$AppDatabase, $PlacementsTableTable, PlacementRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlacementsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacementsTableTable,
      PlacementRow,
      $$PlacementsTableTableFilterComposer,
      $$PlacementsTableTableOrderingComposer,
      $$PlacementsTableTableAnnotationComposer,
      $$PlacementsTableTableCreateCompanionBuilder,
      $$PlacementsTableTableUpdateCompanionBuilder,
      (PlacementRow, BaseReferences<_$AppDatabase, $PlacementsTableTable, PlacementRow>),
      PlacementRow,
      PrefetchHooks Function()
    >;
typedef $$PlantsTableTableCreateCompanionBuilder = PlantsTableCompanion Function({
  required String id,
  required String name,
  required int everyDays,
  required DateTime lastWatered,
  Value<DateTime?> previousWatered,
  Value<String?> photoPath,
  Value<int?> fertilizeEveryWeeks,
  Value<DateTime?> lastFertilized,
  Value<int> rowid,
});
typedef $$PlantsTableTableUpdateCompanionBuilder = PlantsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> everyDays,
  Value<DateTime> lastWatered,
  Value<DateTime?> previousWatered,
  Value<String?> photoPath,
  Value<int?> fertilizeEveryWeeks,
  Value<DateTime?> lastFertilized,
  Value<int> rowid,
});

class $$PlantsTableTableFilterComposer extends Composer<_$AppDatabase, $PlantsTableTable> {
  $$PlantsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get everyDays =>
      $composableBuilder(column: $table.everyDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastWatered =>
      $composableBuilder(column: $table.lastWatered, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get previousWatered =>
      $composableBuilder(column: $table.previousWatered, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fertilizeEveryWeeks =>
      $composableBuilder(column: $table.fertilizeEveryWeeks, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastFertilized =>
      $composableBuilder(column: $table.lastFertilized, builder: (column) => ColumnFilters(column));
}

class $$PlantsTableTableOrderingComposer extends Composer<_$AppDatabase, $PlantsTableTable> {
  $$PlantsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get everyDays =>
      $composableBuilder(column: $table.everyDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastWatered =>
      $composableBuilder(column: $table.lastWatered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get previousWatered =>
      $composableBuilder(column: $table.previousWatered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fertilizeEveryWeeks =>
      $composableBuilder(column: $table.fertilizeEveryWeeks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastFertilized =>
      $composableBuilder(column: $table.lastFertilized, builder: (column) => ColumnOrderings(column));
}

class $$PlantsTableTableAnnotationComposer extends Composer<_$AppDatabase, $PlantsTableTable> {
  $$PlantsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get everyDays => $composableBuilder(column: $table.everyDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastWatered =>
      $composableBuilder(column: $table.lastWatered, builder: (column) => column);

  GeneratedColumn<DateTime> get previousWatered =>
      $composableBuilder(column: $table.previousWatered, builder: (column) => column);

  GeneratedColumn<String> get photoPath => $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get fertilizeEveryWeeks =>
      $composableBuilder(column: $table.fertilizeEveryWeeks, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFertilized =>
      $composableBuilder(column: $table.lastFertilized, builder: (column) => column);
}

class $$PlantsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantsTableTable,
          PlantRow,
          $$PlantsTableTableFilterComposer,
          $$PlantsTableTableOrderingComposer,
          $$PlantsTableTableAnnotationComposer,
          $$PlantsTableTableCreateCompanionBuilder,
          $$PlantsTableTableUpdateCompanionBuilder,
          (PlantRow, BaseReferences<_$AppDatabase, $PlantsTableTable, PlantRow>),
          PlantRow,
          PrefetchHooks Function()
        > {
  $$PlantsTableTableTableManager(_$AppDatabase db, $PlantsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlantsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlantsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlantsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> everyDays = const Value.absent(),
                Value<DateTime> lastWatered = const Value.absent(),
                Value<DateTime?> previousWatered = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> fertilizeEveryWeeks = const Value.absent(),
                Value<DateTime?> lastFertilized = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsTableCompanion(
                id: id,
                name: name,
                everyDays: everyDays,
                lastWatered: lastWatered,
                previousWatered: previousWatered,
                photoPath: photoPath,
                fertilizeEveryWeeks: fertilizeEveryWeeks,
                lastFertilized: lastFertilized,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int everyDays,
                required DateTime lastWatered,
                Value<DateTime?> previousWatered = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> fertilizeEveryWeeks = const Value.absent(),
                Value<DateTime?> lastFertilized = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsTableCompanion.insert(
                id: id,
                name: name,
                everyDays: everyDays,
                lastWatered: lastWatered,
                previousWatered: previousWatered,
                photoPath: photoPath,
                fertilizeEveryWeeks: fertilizeEveryWeeks,
                lastFertilized: lastFertilized,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlantsTableTable, PlantRow>(table),
                  BaseReferences<_$AppDatabase, $PlantsTableTable, PlantRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlantsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantsTableTable,
      PlantRow,
      $$PlantsTableTableFilterComposer,
      $$PlantsTableTableOrderingComposer,
      $$PlantsTableTableAnnotationComposer,
      $$PlantsTableTableCreateCompanionBuilder,
      $$PlantsTableTableUpdateCompanionBuilder,
      (PlantRow, BaseReferences<_$AppDatabase, $PlantsTableTable, PlantRow>),
      PlantRow,
      PrefetchHooks Function()
    >;
typedef $$SpeakerSettingsTableTableCreateCompanionBuilder = SpeakerSettingsTableCompanion Function({
  required String id,
  Value<String?> displayName,
  Value<bool> hidden,
  Value<bool> isDefault,
  Value<int> rowid,
});
typedef $$SpeakerSettingsTableTableUpdateCompanionBuilder = SpeakerSettingsTableCompanion Function({
  Value<String> id,
  Value<String?> displayName,
  Value<bool> hidden,
  Value<bool> isDefault,
  Value<int> rowid,
});

class $$SpeakerSettingsTableTableFilterComposer extends Composer<_$AppDatabase, $SpeakerSettingsTableTable> {
  $$SpeakerSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => ColumnFilters(column));
}

class $$SpeakerSettingsTableTableOrderingComposer extends Composer<_$AppDatabase, $SpeakerSettingsTableTable> {
  $$SpeakerSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => ColumnOrderings(column));
}

class $$SpeakerSettingsTableTableAnnotationComposer extends Composer<_$AppDatabase, $SpeakerSettingsTableTable> {
  $$SpeakerSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => column);

  GeneratedColumn<bool> get hidden => $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<bool> get isDefault => $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$SpeakerSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeakerSettingsTableTable,
          SpeakerSettingRow,
          $$SpeakerSettingsTableTableFilterComposer,
          $$SpeakerSettingsTableTableOrderingComposer,
          $$SpeakerSettingsTableTableAnnotationComposer,
          $$SpeakerSettingsTableTableCreateCompanionBuilder,
          $$SpeakerSettingsTableTableUpdateCompanionBuilder,
          (SpeakerSettingRow, BaseReferences<_$AppDatabase, $SpeakerSettingsTableTable, SpeakerSettingRow>),
          SpeakerSettingRow,
          PrefetchHooks Function()
        > {
  $$SpeakerSettingsTableTableTableManager(_$AppDatabase db, $SpeakerSettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SpeakerSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SpeakerSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SpeakerSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeakerSettingsTableCompanion(
                id: id,
                displayName: displayName,
                hidden: hidden,
                isDefault: isDefault,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> displayName = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeakerSettingsTableCompanion.insert(
                id: id,
                displayName: displayName,
                hidden: hidden,
                isDefault: isDefault,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpeakerSettingsTableTable, SpeakerSettingRow>(table),
                  BaseReferences<_$AppDatabase, $SpeakerSettingsTableTable, SpeakerSettingRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpeakerSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeakerSettingsTableTable,
      SpeakerSettingRow,
      $$SpeakerSettingsTableTableFilterComposer,
      $$SpeakerSettingsTableTableOrderingComposer,
      $$SpeakerSettingsTableTableAnnotationComposer,
      $$SpeakerSettingsTableTableCreateCompanionBuilder,
      $$SpeakerSettingsTableTableUpdateCompanionBuilder,
      (SpeakerSettingRow, BaseReferences<_$AppDatabase, $SpeakerSettingsTableTable, SpeakerSettingRow>),
      SpeakerSettingRow,
      PrefetchHooks Function()
    >;
typedef $$ZenSettingsTableTableCreateCompanionBuilder = ZenSettingsTableCompanion Function({
  Value<int> id,
  Value<int> idleMinutes,
});
typedef $$ZenSettingsTableTableUpdateCompanionBuilder = ZenSettingsTableCompanion Function({
  Value<int> id,
  Value<int> idleMinutes,
});

class $$ZenSettingsTableTableFilterComposer extends Composer<_$AppDatabase, $ZenSettingsTableTable> {
  $$ZenSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idleMinutes =>
      $composableBuilder(column: $table.idleMinutes, builder: (column) => ColumnFilters(column));
}

class $$ZenSettingsTableTableOrderingComposer extends Composer<_$AppDatabase, $ZenSettingsTableTable> {
  $$ZenSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idleMinutes =>
      $composableBuilder(column: $table.idleMinutes, builder: (column) => ColumnOrderings(column));
}

class $$ZenSettingsTableTableAnnotationComposer extends Composer<_$AppDatabase, $ZenSettingsTableTable> {
  $$ZenSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get idleMinutes => $composableBuilder(column: $table.idleMinutes, builder: (column) => column);
}

class $$ZenSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZenSettingsTableTable,
          ZenSettingsRow,
          $$ZenSettingsTableTableFilterComposer,
          $$ZenSettingsTableTableOrderingComposer,
          $$ZenSettingsTableTableAnnotationComposer,
          $$ZenSettingsTableTableCreateCompanionBuilder,
          $$ZenSettingsTableTableUpdateCompanionBuilder,
          (ZenSettingsRow, BaseReferences<_$AppDatabase, $ZenSettingsTableTable, ZenSettingsRow>),
          ZenSettingsRow,
          PrefetchHooks Function()
        > {
  $$ZenSettingsTableTableTableManager(_$AppDatabase db, $ZenSettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ZenSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ZenSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ZenSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> idleMinutes = const Value.absent(),
          }) => ZenSettingsTableCompanion(id: id, idleMinutes: idleMinutes),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> idleMinutes = const Value.absent(),
          }) => ZenSettingsTableCompanion.insert(id: id, idleMinutes: idleMinutes),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZenSettingsTableTable, ZenSettingsRow>(table),
                  BaseReferences<_$AppDatabase, $ZenSettingsTableTable, ZenSettingsRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ZenSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZenSettingsTableTable,
      ZenSettingsRow,
      $$ZenSettingsTableTableFilterComposer,
      $$ZenSettingsTableTableOrderingComposer,
      $$ZenSettingsTableTableAnnotationComposer,
      $$ZenSettingsTableTableCreateCompanionBuilder,
      $$ZenSettingsTableTableUpdateCompanionBuilder,
      (ZenSettingsRow, BaseReferences<_$AppDatabase, $ZenSettingsTableTable, ZenSettingsRow>),
      ZenSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$PlantProfilesTableTableCreateCompanionBuilder = PlantProfilesTableCompanion Function({
  required String plantId,
  Value<int?> speciesId,
  Value<String> source,
  required String commonName,
  Value<String?> scientificName,
  Value<String?> imageUrl,
  Value<String?> watering,
  Value<int?> wateringMinDays,
  Value<int?> wateringMaxDays,
  Value<int?> wateringWinterMinDays,
  Value<int?> wateringWinterMaxDays,
  Value<int?> fertilizeEveryWeeks,
  Value<String> sunlight,
  Value<String?> careLevel,
  Value<bool?> indoor,
  Value<bool?> poisonousToPets,
  Value<String> pruningMonths,
  Value<String?> wateringGuide,
  Value<String?> sunlightGuide,
  Value<String?> pruningGuide,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$PlantProfilesTableTableUpdateCompanionBuilder = PlantProfilesTableCompanion Function({
  Value<String> plantId,
  Value<int?> speciesId,
  Value<String> source,
  Value<String> commonName,
  Value<String?> scientificName,
  Value<String?> imageUrl,
  Value<String?> watering,
  Value<int?> wateringMinDays,
  Value<int?> wateringMaxDays,
  Value<int?> wateringWinterMinDays,
  Value<int?> wateringWinterMaxDays,
  Value<int?> fertilizeEveryWeeks,
  Value<String> sunlight,
  Value<String?> careLevel,
  Value<bool?> indoor,
  Value<bool?> poisonousToPets,
  Value<String> pruningMonths,
  Value<String?> wateringGuide,
  Value<String?> sunlightGuide,
  Value<String?> pruningGuide,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$PlantProfilesTableTableFilterComposer extends Composer<_$AppDatabase, $PlantProfilesTableTable> {
  $$PlantProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get plantId =>
      $composableBuilder(column: $table.plantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commonName =>
      $composableBuilder(column: $table.commonName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scientificName =>
      $composableBuilder(column: $table.scientificName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get watering =>
      $composableBuilder(column: $table.watering, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wateringMinDays =>
      $composableBuilder(column: $table.wateringMinDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wateringMaxDays =>
      $composableBuilder(column: $table.wateringMaxDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wateringWinterMinDays =>
      $composableBuilder(column: $table.wateringWinterMinDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wateringWinterMaxDays =>
      $composableBuilder(column: $table.wateringWinterMaxDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fertilizeEveryWeeks =>
      $composableBuilder(column: $table.fertilizeEveryWeeks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sunlight =>
      $composableBuilder(column: $table.sunlight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get careLevel =>
      $composableBuilder(column: $table.careLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get indoor =>
      $composableBuilder(column: $table.indoor, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get poisonousToPets =>
      $composableBuilder(column: $table.poisonousToPets, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pruningMonths =>
      $composableBuilder(column: $table.pruningMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wateringGuide =>
      $composableBuilder(column: $table.wateringGuide, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sunlightGuide =>
      $composableBuilder(column: $table.sunlightGuide, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pruningGuide =>
      $composableBuilder(column: $table.pruningGuide, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$PlantProfilesTableTableOrderingComposer extends Composer<_$AppDatabase, $PlantProfilesTableTable> {
  $$PlantProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get plantId =>
      $composableBuilder(column: $table.plantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commonName =>
      $composableBuilder(column: $table.commonName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scientificName =>
      $composableBuilder(column: $table.scientificName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get watering =>
      $composableBuilder(column: $table.watering, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wateringMinDays =>
      $composableBuilder(column: $table.wateringMinDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wateringMaxDays =>
      $composableBuilder(column: $table.wateringMaxDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wateringWinterMinDays =>
      $composableBuilder(column: $table.wateringWinterMinDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wateringWinterMaxDays =>
      $composableBuilder(column: $table.wateringWinterMaxDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fertilizeEveryWeeks =>
      $composableBuilder(column: $table.fertilizeEveryWeeks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sunlight =>
      $composableBuilder(column: $table.sunlight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get careLevel =>
      $composableBuilder(column: $table.careLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get indoor =>
      $composableBuilder(column: $table.indoor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get poisonousToPets =>
      $composableBuilder(column: $table.poisonousToPets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pruningMonths =>
      $composableBuilder(column: $table.pruningMonths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wateringGuide =>
      $composableBuilder(column: $table.wateringGuide, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sunlightGuide =>
      $composableBuilder(column: $table.sunlightGuide, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pruningGuide =>
      $composableBuilder(column: $table.pruningGuide, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlantProfilesTableTableAnnotationComposer extends Composer<_$AppDatabase, $PlantProfilesTableTable> {
  $$PlantProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get plantId => $composableBuilder(column: $table.plantId, builder: (column) => column);

  GeneratedColumn<int> get speciesId => $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get commonName => $composableBuilder(column: $table.commonName, builder: (column) => column);

  GeneratedColumn<String> get scientificName =>
      $composableBuilder(column: $table.scientificName, builder: (column) => column);

  GeneratedColumn<String> get imageUrl => $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get watering => $composableBuilder(column: $table.watering, builder: (column) => column);

  GeneratedColumn<int> get wateringMinDays =>
      $composableBuilder(column: $table.wateringMinDays, builder: (column) => column);

  GeneratedColumn<int> get wateringMaxDays =>
      $composableBuilder(column: $table.wateringMaxDays, builder: (column) => column);

  GeneratedColumn<int> get wateringWinterMinDays =>
      $composableBuilder(column: $table.wateringWinterMinDays, builder: (column) => column);

  GeneratedColumn<int> get wateringWinterMaxDays =>
      $composableBuilder(column: $table.wateringWinterMaxDays, builder: (column) => column);

  GeneratedColumn<int> get fertilizeEveryWeeks =>
      $composableBuilder(column: $table.fertilizeEveryWeeks, builder: (column) => column);

  GeneratedColumn<String> get sunlight => $composableBuilder(column: $table.sunlight, builder: (column) => column);

  GeneratedColumn<String> get careLevel => $composableBuilder(column: $table.careLevel, builder: (column) => column);

  GeneratedColumn<bool> get indoor => $composableBuilder(column: $table.indoor, builder: (column) => column);

  GeneratedColumn<bool> get poisonousToPets =>
      $composableBuilder(column: $table.poisonousToPets, builder: (column) => column);

  GeneratedColumn<String> get pruningMonths =>
      $composableBuilder(column: $table.pruningMonths, builder: (column) => column);

  GeneratedColumn<String> get wateringGuide =>
      $composableBuilder(column: $table.wateringGuide, builder: (column) => column);

  GeneratedColumn<String> get sunlightGuide =>
      $composableBuilder(column: $table.sunlightGuide, builder: (column) => column);

  GeneratedColumn<String> get pruningGuide =>
      $composableBuilder(column: $table.pruningGuide, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt => $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$PlantProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantProfilesTableTable,
          PlantProfileRow,
          $$PlantProfilesTableTableFilterComposer,
          $$PlantProfilesTableTableOrderingComposer,
          $$PlantProfilesTableTableAnnotationComposer,
          $$PlantProfilesTableTableCreateCompanionBuilder,
          $$PlantProfilesTableTableUpdateCompanionBuilder,
          (PlantProfileRow, BaseReferences<_$AppDatabase, $PlantProfilesTableTable, PlantProfileRow>),
          PlantProfileRow,
          PrefetchHooks Function()
        > {
  $$PlantProfilesTableTableTableManager(_$AppDatabase db, $PlantProfilesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlantProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlantProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlantProfilesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> plantId = const Value.absent(),
                Value<int?> speciesId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> commonName = const Value.absent(),
                Value<String?> scientificName = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> watering = const Value.absent(),
                Value<int?> wateringMinDays = const Value.absent(),
                Value<int?> wateringMaxDays = const Value.absent(),
                Value<int?> wateringWinterMinDays = const Value.absent(),
                Value<int?> wateringWinterMaxDays = const Value.absent(),
                Value<int?> fertilizeEveryWeeks = const Value.absent(),
                Value<String> sunlight = const Value.absent(),
                Value<String?> careLevel = const Value.absent(),
                Value<bool?> indoor = const Value.absent(),
                Value<bool?> poisonousToPets = const Value.absent(),
                Value<String> pruningMonths = const Value.absent(),
                Value<String?> wateringGuide = const Value.absent(),
                Value<String?> sunlightGuide = const Value.absent(),
                Value<String?> pruningGuide = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantProfilesTableCompanion(
                plantId: plantId,
                speciesId: speciesId,
                source: source,
                commonName: commonName,
                scientificName: scientificName,
                imageUrl: imageUrl,
                watering: watering,
                wateringMinDays: wateringMinDays,
                wateringMaxDays: wateringMaxDays,
                wateringWinterMinDays: wateringWinterMinDays,
                wateringWinterMaxDays: wateringWinterMaxDays,
                fertilizeEveryWeeks: fertilizeEveryWeeks,
                sunlight: sunlight,
                careLevel: careLevel,
                indoor: indoor,
                poisonousToPets: poisonousToPets,
                pruningMonths: pruningMonths,
                wateringGuide: wateringGuide,
                sunlightGuide: sunlightGuide,
                pruningGuide: pruningGuide,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String plantId,
                Value<int?> speciesId = const Value.absent(),
                Value<String> source = const Value.absent(),
                required String commonName,
                Value<String?> scientificName = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> watering = const Value.absent(),
                Value<int?> wateringMinDays = const Value.absent(),
                Value<int?> wateringMaxDays = const Value.absent(),
                Value<int?> wateringWinterMinDays = const Value.absent(),
                Value<int?> wateringWinterMaxDays = const Value.absent(),
                Value<int?> fertilizeEveryWeeks = const Value.absent(),
                Value<String> sunlight = const Value.absent(),
                Value<String?> careLevel = const Value.absent(),
                Value<bool?> indoor = const Value.absent(),
                Value<bool?> poisonousToPets = const Value.absent(),
                Value<String> pruningMonths = const Value.absent(),
                Value<String?> wateringGuide = const Value.absent(),
                Value<String?> sunlightGuide = const Value.absent(),
                Value<String?> pruningGuide = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlantProfilesTableCompanion.insert(
                plantId: plantId,
                speciesId: speciesId,
                source: source,
                commonName: commonName,
                scientificName: scientificName,
                imageUrl: imageUrl,
                watering: watering,
                wateringMinDays: wateringMinDays,
                wateringMaxDays: wateringMaxDays,
                wateringWinterMinDays: wateringWinterMinDays,
                wateringWinterMaxDays: wateringWinterMaxDays,
                fertilizeEveryWeeks: fertilizeEveryWeeks,
                sunlight: sunlight,
                careLevel: careLevel,
                indoor: indoor,
                poisonousToPets: poisonousToPets,
                pruningMonths: pruningMonths,
                wateringGuide: wateringGuide,
                sunlightGuide: sunlightGuide,
                pruningGuide: pruningGuide,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlantProfilesTableTable, PlantProfileRow>(table),
                  BaseReferences<_$AppDatabase, $PlantProfilesTableTable, PlantProfileRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlantProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantProfilesTableTable,
      PlantProfileRow,
      $$PlantProfilesTableTableFilterComposer,
      $$PlantProfilesTableTableOrderingComposer,
      $$PlantProfilesTableTableAnnotationComposer,
      $$PlantProfilesTableTableCreateCompanionBuilder,
      $$PlantProfilesTableTableUpdateCompanionBuilder,
      (PlantProfileRow, BaseReferences<_$AppDatabase, $PlantProfilesTableTable, PlantProfileRow>),
      PlantProfileRow,
      PrefetchHooks Function()
    >;
typedef $$WeatherSettingsTableTableCreateCompanionBuilder = WeatherSettingsTableCompanion Function({
  Value<int> id,
  Value<double?> placeLatitude,
  Value<double?> placeLongitude,
  Value<String?> placeName,
  Value<String?> placeRegion,
  Value<String?> cachedJson,
  Value<double?> cachedLatitude,
  Value<double?> cachedLongitude,
  Value<String?> cachedPlaceName,
  Value<DateTime?> cachedAt,
});
typedef $$WeatherSettingsTableTableUpdateCompanionBuilder = WeatherSettingsTableCompanion Function({
  Value<int> id,
  Value<double?> placeLatitude,
  Value<double?> placeLongitude,
  Value<String?> placeName,
  Value<String?> placeRegion,
  Value<String?> cachedJson,
  Value<double?> cachedLatitude,
  Value<double?> cachedLongitude,
  Value<String?> cachedPlaceName,
  Value<DateTime?> cachedAt,
});

class $$WeatherSettingsTableTableFilterComposer extends Composer<_$AppDatabase, $WeatherSettingsTableTable> {
  $$WeatherSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get placeLatitude =>
      $composableBuilder(column: $table.placeLatitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get placeLongitude =>
      $composableBuilder(column: $table.placeLongitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeRegion =>
      $composableBuilder(column: $table.placeRegion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cachedJson =>
      $composableBuilder(column: $table.cachedJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cachedLatitude =>
      $composableBuilder(column: $table.cachedLatitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cachedLongitude =>
      $composableBuilder(column: $table.cachedLongitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cachedPlaceName =>
      $composableBuilder(column: $table.cachedPlaceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$WeatherSettingsTableTableOrderingComposer extends Composer<_$AppDatabase, $WeatherSettingsTableTable> {
  $$WeatherSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get placeLatitude =>
      $composableBuilder(column: $table.placeLatitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get placeLongitude =>
      $composableBuilder(column: $table.placeLongitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeRegion =>
      $composableBuilder(column: $table.placeRegion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cachedJson =>
      $composableBuilder(column: $table.cachedJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cachedLatitude =>
      $composableBuilder(column: $table.cachedLatitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cachedLongitude =>
      $composableBuilder(column: $table.cachedLongitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cachedPlaceName =>
      $composableBuilder(column: $table.cachedPlaceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$WeatherSettingsTableTableAnnotationComposer extends Composer<_$AppDatabase, $WeatherSettingsTableTable> {
  $$WeatherSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get placeLatitude =>
      $composableBuilder(column: $table.placeLatitude, builder: (column) => column);

  GeneratedColumn<double> get placeLongitude =>
      $composableBuilder(column: $table.placeLongitude, builder: (column) => column);

  GeneratedColumn<String> get placeName => $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get placeRegion =>
      $composableBuilder(column: $table.placeRegion, builder: (column) => column);

  GeneratedColumn<String> get cachedJson => $composableBuilder(column: $table.cachedJson, builder: (column) => column);

  GeneratedColumn<double> get cachedLatitude =>
      $composableBuilder(column: $table.cachedLatitude, builder: (column) => column);

  GeneratedColumn<double> get cachedLongitude =>
      $composableBuilder(column: $table.cachedLongitude, builder: (column) => column);

  GeneratedColumn<String> get cachedPlaceName =>
      $composableBuilder(column: $table.cachedPlaceName, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt => $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$WeatherSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeatherSettingsTableTable,
          WeatherSettingsRow,
          $$WeatherSettingsTableTableFilterComposer,
          $$WeatherSettingsTableTableOrderingComposer,
          $$WeatherSettingsTableTableAnnotationComposer,
          $$WeatherSettingsTableTableCreateCompanionBuilder,
          $$WeatherSettingsTableTableUpdateCompanionBuilder,
          (WeatherSettingsRow, BaseReferences<_$AppDatabase, $WeatherSettingsTableTable, WeatherSettingsRow>),
          WeatherSettingsRow,
          PrefetchHooks Function()
        > {
  $$WeatherSettingsTableTableTableManager(_$AppDatabase db, $WeatherSettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$WeatherSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$WeatherSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$WeatherSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double?> placeLatitude = const Value.absent(),
                Value<double?> placeLongitude = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> placeRegion = const Value.absent(),
                Value<String?> cachedJson = const Value.absent(),
                Value<double?> cachedLatitude = const Value.absent(),
                Value<double?> cachedLongitude = const Value.absent(),
                Value<String?> cachedPlaceName = const Value.absent(),
                Value<DateTime?> cachedAt = const Value.absent(),
              }) => WeatherSettingsTableCompanion(
                id: id,
                placeLatitude: placeLatitude,
                placeLongitude: placeLongitude,
                placeName: placeName,
                placeRegion: placeRegion,
                cachedJson: cachedJson,
                cachedLatitude: cachedLatitude,
                cachedLongitude: cachedLongitude,
                cachedPlaceName: cachedPlaceName,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double?> placeLatitude = const Value.absent(),
                Value<double?> placeLongitude = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> placeRegion = const Value.absent(),
                Value<String?> cachedJson = const Value.absent(),
                Value<double?> cachedLatitude = const Value.absent(),
                Value<double?> cachedLongitude = const Value.absent(),
                Value<String?> cachedPlaceName = const Value.absent(),
                Value<DateTime?> cachedAt = const Value.absent(),
              }) => WeatherSettingsTableCompanion.insert(
                id: id,
                placeLatitude: placeLatitude,
                placeLongitude: placeLongitude,
                placeName: placeName,
                placeRegion: placeRegion,
                cachedJson: cachedJson,
                cachedLatitude: cachedLatitude,
                cachedLongitude: cachedLongitude,
                cachedPlaceName: cachedPlaceName,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeatherSettingsTableTable, WeatherSettingsRow>(table),
                  BaseReferences<_$AppDatabase, $WeatherSettingsTableTable, WeatherSettingsRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeatherSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeatherSettingsTableTable,
      WeatherSettingsRow,
      $$WeatherSettingsTableTableFilterComposer,
      $$WeatherSettingsTableTableOrderingComposer,
      $$WeatherSettingsTableTableAnnotationComposer,
      $$WeatherSettingsTableTableCreateCompanionBuilder,
      $$WeatherSettingsTableTableUpdateCompanionBuilder,
      (WeatherSettingsRow, BaseReferences<_$AppDatabase, $WeatherSettingsTableTable, WeatherSettingsRow>),
      WeatherSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$DashboardWidgetsTableTableCreateCompanionBuilder = DashboardWidgetsTableCompanion Function({
  required String id,
  required String kind,
  required String size,
  required int position,
  Value<String?> selection,
  Value<bool?> card,
  Value<int> rowid,
});
typedef $$DashboardWidgetsTableTableUpdateCompanionBuilder = DashboardWidgetsTableCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<String> size,
  Value<int> position,
  Value<String?> selection,
  Value<bool?> card,
  Value<int> rowid,
});

class $$DashboardWidgetsTableTableFilterComposer extends Composer<_$AppDatabase, $DashboardWidgetsTableTable> {
  $$DashboardWidgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get size => $composableBuilder(column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selection =>
      $composableBuilder(column: $table.selection, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get card => $composableBuilder(column: $table.card, builder: (column) => ColumnFilters(column));
}

class $$DashboardWidgetsTableTableOrderingComposer extends Composer<_$AppDatabase, $DashboardWidgetsTableTable> {
  $$DashboardWidgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selection =>
      $composableBuilder(column: $table.selection, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get card =>
      $composableBuilder(column: $table.card, builder: (column) => ColumnOrderings(column));
}

class $$DashboardWidgetsTableTableAnnotationComposer extends Composer<_$AppDatabase, $DashboardWidgetsTableTable> {
  $$DashboardWidgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get size => $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get selection => $composableBuilder(column: $table.selection, builder: (column) => column);

  GeneratedColumn<bool> get card => $composableBuilder(column: $table.card, builder: (column) => column);
}

class $$DashboardWidgetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardWidgetsTableTable,
          DashboardWidgetRow,
          $$DashboardWidgetsTableTableFilterComposer,
          $$DashboardWidgetsTableTableOrderingComposer,
          $$DashboardWidgetsTableTableAnnotationComposer,
          $$DashboardWidgetsTableTableCreateCompanionBuilder,
          $$DashboardWidgetsTableTableUpdateCompanionBuilder,
          (DashboardWidgetRow, BaseReferences<_$AppDatabase, $DashboardWidgetsTableTable, DashboardWidgetRow>),
          DashboardWidgetRow,
          PrefetchHooks Function()
        > {
  $$DashboardWidgetsTableTableTableManager(_$AppDatabase db, $DashboardWidgetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DashboardWidgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DashboardWidgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$DashboardWidgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> size = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> selection = const Value.absent(),
                Value<bool?> card = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardWidgetsTableCompanion(
                id: id,
                kind: kind,
                size: size,
                position: position,
                selection: selection,
                card: card,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String size,
                required int position,
                Value<String?> selection = const Value.absent(),
                Value<bool?> card = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardWidgetsTableCompanion.insert(
                id: id,
                kind: kind,
                size: size,
                position: position,
                selection: selection,
                card: card,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DashboardWidgetsTableTable, DashboardWidgetRow>(table),
                  BaseReferences<_$AppDatabase, $DashboardWidgetsTableTable, DashboardWidgetRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardWidgetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardWidgetsTableTable,
      DashboardWidgetRow,
      $$DashboardWidgetsTableTableFilterComposer,
      $$DashboardWidgetsTableTableOrderingComposer,
      $$DashboardWidgetsTableTableAnnotationComposer,
      $$DashboardWidgetsTableTableCreateCompanionBuilder,
      $$DashboardWidgetsTableTableUpdateCompanionBuilder,
      (DashboardWidgetRow, BaseReferences<_$AppDatabase, $DashboardWidgetsTableTable, DashboardWidgetRow>),
      DashboardWidgetRow,
      PrefetchHooks Function()
    >;
typedef $$DashboardStateTableTableCreateCompanionBuilder = DashboardStateTableCompanion Function({
  Value<int> id,
  Value<bool> arranged,
});
typedef $$DashboardStateTableTableUpdateCompanionBuilder = DashboardStateTableCompanion Function({
  Value<int> id,
  Value<bool> arranged,
});

class $$DashboardStateTableTableFilterComposer extends Composer<_$AppDatabase, $DashboardStateTableTable> {
  $$DashboardStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get arranged =>
      $composableBuilder(column: $table.arranged, builder: (column) => ColumnFilters(column));
}

class $$DashboardStateTableTableOrderingComposer extends Composer<_$AppDatabase, $DashboardStateTableTable> {
  $$DashboardStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get arranged =>
      $composableBuilder(column: $table.arranged, builder: (column) => ColumnOrderings(column));
}

class $$DashboardStateTableTableAnnotationComposer extends Composer<_$AppDatabase, $DashboardStateTableTable> {
  $$DashboardStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get arranged => $composableBuilder(column: $table.arranged, builder: (column) => column);
}

class $$DashboardStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardStateTableTable,
          DashboardStateRow,
          $$DashboardStateTableTableFilterComposer,
          $$DashboardStateTableTableOrderingComposer,
          $$DashboardStateTableTableAnnotationComposer,
          $$DashboardStateTableTableCreateCompanionBuilder,
          $$DashboardStateTableTableUpdateCompanionBuilder,
          (DashboardStateRow, BaseReferences<_$AppDatabase, $DashboardStateTableTable, DashboardStateRow>),
          DashboardStateRow,
          PrefetchHooks Function()
        > {
  $$DashboardStateTableTableTableManager(_$AppDatabase db, $DashboardStateTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DashboardStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DashboardStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$DashboardStateTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> arranged = const Value.absent(),
          }) => DashboardStateTableCompanion(id: id, arranged: arranged),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> arranged = const Value.absent(),
          }) => DashboardStateTableCompanion.insert(id: id, arranged: arranged),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DashboardStateTableTable, DashboardStateRow>(table),
                  BaseReferences<_$AppDatabase, $DashboardStateTableTable, DashboardStateRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardStateTableTable,
      DashboardStateRow,
      $$DashboardStateTableTableFilterComposer,
      $$DashboardStateTableTableOrderingComposer,
      $$DashboardStateTableTableAnnotationComposer,
      $$DashboardStateTableTableCreateCompanionBuilder,
      $$DashboardStateTableTableUpdateCompanionBuilder,
      (DashboardStateRow, BaseReferences<_$AppDatabase, $DashboardStateTableTable, DashboardStateRow>),
      DashboardStateRow,
      PrefetchHooks Function()
    >;
typedef $$RoomScenesTableTableCreateCompanionBuilder = RoomScenesTableCompanion Function({
  required String id,
  required String roomId,
  required String name,
  required int position,
  required int brightnessPercent,
  required int color,
  required int kelvin,
  required String lights,
  Value<int> rowid,
});
typedef $$RoomScenesTableTableUpdateCompanionBuilder = RoomScenesTableCompanion Function({
  Value<String> id,
  Value<String> roomId,
  Value<String> name,
  Value<int> position,
  Value<int> brightnessPercent,
  Value<int> color,
  Value<int> kelvin,
  Value<String> lights,
  Value<int> rowid,
});

class $$RoomScenesTableTableFilterComposer extends Composer<_$AppDatabase, $RoomScenesTableTable> {
  $$RoomScenesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get brightnessPercent =>
      $composableBuilder(column: $table.brightnessPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kelvin =>
      $composableBuilder(column: $table.kelvin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lights =>
      $composableBuilder(column: $table.lights, builder: (column) => ColumnFilters(column));
}

class $$RoomScenesTableTableOrderingComposer extends Composer<_$AppDatabase, $RoomScenesTableTable> {
  $$RoomScenesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get brightnessPercent =>
      $composableBuilder(column: $table.brightnessPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kelvin =>
      $composableBuilder(column: $table.kelvin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lights =>
      $composableBuilder(column: $table.lights, builder: (column) => ColumnOrderings(column));
}

class $$RoomScenesTableTableAnnotationComposer extends Composer<_$AppDatabase, $RoomScenesTableTable> {
  $$RoomScenesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roomId => $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get brightnessPercent =>
      $composableBuilder(column: $table.brightnessPercent, builder: (column) => column);

  GeneratedColumn<int> get color => $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get kelvin => $composableBuilder(column: $table.kelvin, builder: (column) => column);

  GeneratedColumn<String> get lights => $composableBuilder(column: $table.lights, builder: (column) => column);
}

class $$RoomScenesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomScenesTableTable,
          RoomSceneRow,
          $$RoomScenesTableTableFilterComposer,
          $$RoomScenesTableTableOrderingComposer,
          $$RoomScenesTableTableAnnotationComposer,
          $$RoomScenesTableTableCreateCompanionBuilder,
          $$RoomScenesTableTableUpdateCompanionBuilder,
          (RoomSceneRow, BaseReferences<_$AppDatabase, $RoomScenesTableTable, RoomSceneRow>),
          RoomSceneRow,
          PrefetchHooks Function()
        > {
  $$RoomScenesTableTableTableManager(_$AppDatabase db, $RoomScenesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$RoomScenesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$RoomScenesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$RoomScenesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> brightnessPercent = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> kelvin = const Value.absent(),
                Value<String> lights = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomScenesTableCompanion(
                id: id,
                roomId: roomId,
                name: name,
                position: position,
                brightnessPercent: brightnessPercent,
                color: color,
                kelvin: kelvin,
                lights: lights,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                required String name,
                required int position,
                required int brightnessPercent,
                required int color,
                required int kelvin,
                required String lights,
                Value<int> rowid = const Value.absent(),
              }) => RoomScenesTableCompanion.insert(
                id: id,
                roomId: roomId,
                name: name,
                position: position,
                brightnessPercent: brightnessPercent,
                color: color,
                kelvin: kelvin,
                lights: lights,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomScenesTableTable, RoomSceneRow>(table),
                  BaseReferences<_$AppDatabase, $RoomScenesTableTable, RoomSceneRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomScenesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomScenesTableTable,
      RoomSceneRow,
      $$RoomScenesTableTableFilterComposer,
      $$RoomScenesTableTableOrderingComposer,
      $$RoomScenesTableTableAnnotationComposer,
      $$RoomScenesTableTableCreateCompanionBuilder,
      $$RoomScenesTableTableUpdateCompanionBuilder,
      (RoomSceneRow, BaseReferences<_$AppDatabase, $RoomScenesTableTable, RoomSceneRow>),
      RoomSceneRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FloorPlansTableTableTableManager get floorPlansTable =>
      $$FloorPlansTableTableTableManager(_db, _db.floorPlansTable);
  $$PlacementsTableTableTableManager get placementsTable =>
      $$PlacementsTableTableTableManager(_db, _db.placementsTable);
  $$PlantsTableTableTableManager get plantsTable => $$PlantsTableTableTableManager(_db, _db.plantsTable);
  $$SpeakerSettingsTableTableTableManager get speakerSettingsTable =>
      $$SpeakerSettingsTableTableTableManager(_db, _db.speakerSettingsTable);
  $$ZenSettingsTableTableTableManager get zenSettingsTable =>
      $$ZenSettingsTableTableTableManager(_db, _db.zenSettingsTable);
  $$PlantProfilesTableTableTableManager get plantProfilesTable =>
      $$PlantProfilesTableTableTableManager(_db, _db.plantProfilesTable);
  $$WeatherSettingsTableTableTableManager get weatherSettingsTable =>
      $$WeatherSettingsTableTableTableManager(_db, _db.weatherSettingsTable);
  $$DashboardWidgetsTableTableTableManager get dashboardWidgetsTable =>
      $$DashboardWidgetsTableTableTableManager(_db, _db.dashboardWidgetsTable);
  $$DashboardStateTableTableTableManager get dashboardStateTable =>
      $$DashboardStateTableTableTableManager(_db, _db.dashboardStateTable);
  $$RoomScenesTableTableTableManager get roomScenesTable =>
      $$RoomScenesTableTableTableManager(_db, _db.roomScenesTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Providers

final class AppDatabaseProvider extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Providers
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AppDatabase>(value));
  }
}

String _$appDatabaseHash() => r'44154e51c3f3079ee293d8ad0ebd1e17cca871ed';
