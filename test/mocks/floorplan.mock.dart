import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/data/floorplan/placement.repository.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/lights/room_scenes.service.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';

import '../fixtures/floorplan.fixture.dart';
import 'devices.mock.dart';

/// The day the tests run on.
final testToday = DateTime(2026, 10, 26);

/// The apartment plan and in-memory placement and plant stores, closed at the end of the test.
List<Override> floorplanTestOverrides({PlacementRepository? placements}) {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  return [
    floorPlanServiceProvider.overrideWith((ref) async => loadApartmentPlan()),
    placementRepositoryProvider.overrideWithValue(placements ?? PlacementRepository(database: database)),
    plantRepositoryProvider.overrideWithValue(PlantRepository(database: database)),
    currentDayProvider.overrideWith((ref) => Stream.value(testToday)),
  ];
}

/// [PlacementService] holding [placements] in memory, without a database.
class FakePlacementService extends PlacementService {
  FakePlacementService([List<Placement> placements = const []]) : _placements = [...placements];

  final List<Placement> _placements;
  final removed = <String>[];

  @override
  Stream<List<Placement>> build() => Stream.value(List.of(_placements));

  @override
  Future<void> place(String deviceId, DeviceKind kind, PlanPoint position) async {
    _placements
      ..removeWhere((p) => p.deviceId == deviceId)
      ..add(Placement(deviceId: deviceId, kind: kind, position: position));
    state = AsyncData(List.of(_placements));
  }

  @override
  Future<void> remove(String deviceId) async {
    removed.add(deviceId);
    _placements.removeWhere((p) => p.deviceId == deviceId);
    state = AsyncData(List.of(_placements));
  }
}

/// The apartment plan, [FakePlacementService] and [FakePlantsService] – for widget tests, where a database would
/// leave timers.
List<Override> floorplanWidgetTestOverrides(
  FakePlacementService placements, {
  FakePlantsService? plants,
  bool hasHomeAssistant = true,
}) {
  return [
    floorPlanServiceProvider.overrideWith((ref) async => loadApartmentPlan()),
    placementServiceProvider.overrideWith(() => placements),
    plantsServiceProvider.overrideWith(() => plants ?? FakePlantsService()),
    currentDayProvider.overrideWith((ref) => Stream.value(testToday)),
    // Lights and speakers on the plan come from Home Assistant.
    hasHomeAssistantProvider.overrideWithValue(hasHomeAssistant),
    roomScenesServiceProvider.overrideWith(FakeRoomScenesService.new),
  ];
}

/// [PlantsService] holding [plants] in memory that records watering commands as text.
class FakePlantsService extends PlantsService {
  FakePlantsService([this.plants = const []]);

  final List<Plant> plants;
  final commands = <String>[];

  @override
  Stream<List<Plant>> build() => Stream.value(plants);

  @override
  Future<void> water(List<String> ids) async => commands.add('water ${ids.join(',')}');

  @override
  Future<void> undoWatering(String id) async => commands.add('undo $id');

  @override
  Future<void> addAllIfEmpty(List<Plant> plants) async => commands.add('demo ${plants.length}');

  @override
  Future<Plant> add({
    required String name,
    required int everyDays,
    int? fertilizeEveryWeeks,
    String? photoSource,
  }) async {
    commands.add(
      'add $name every $everyDays${fertilizeEveryWeeks == null ? '' : ' feed $fertilizeEveryWeeks'} '
      'photo ${photoSource ?? '-'}',
    );
    return Plant(id: 'new', name: name, everyDays: everyDays, lastWatered: testToday);
  }

  @override
  Future<void> edit(Plant plant, {String? photoSource}) async => commands.add(
    'edit ${plant.id} ${plant.name} every ${plant.everyDays}'
    '${plant.fertilizeEveryWeeks == null ? '' : ' feed ${plant.fertilizeEveryWeeks}'}',
  );

  @override
  Future<void> fertilize(List<String> ids) async => commands.add('feed ${ids.join(',')}');

  @override
  Future<void> delete(Plant plant) async => commands.add('delete ${plant.id}');
}
