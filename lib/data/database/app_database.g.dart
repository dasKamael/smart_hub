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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FloorPlansTableTable floorPlansTable = $FloorPlansTableTable(this);
  late final $PlacementsTableTable placementsTable = $PlacementsTableTable(this);
  late final $PlantsTableTable plantsTable = $PlantsTableTable(this);
  late final $SpeakerSettingsTableTable speakerSettingsTable = $SpeakerSettingsTableTable(this);
  late final $ZenSettingsTableTable zenSettingsTable = $ZenSettingsTableTable(this);
  late final $PlantProfilesTableTable plantProfilesTable = $PlantProfilesTableTable(this);
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
