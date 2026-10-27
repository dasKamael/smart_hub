import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';

/// Where the devices of the demo home stand on the bundled apartment plan. One light and one plant stay in the
/// tray.
const demoLayout = [
  Placement(deviceId: 'light.office_desk', kind: DeviceKind.light, position: PlanPoint(390, 70)),
  Placement(deviceId: 'light.office_ceiling', kind: DeviceKind.light, position: PlanPoint(220, 80)),
  Placement(deviceId: 'media_player.office', kind: DeviceKind.speaker, position: PlanPoint(60, 110)),
  Placement(deviceId: 'light.hall', kind: DeviceKind.light, position: PlanPoint(110, 200)),
  Placement(deviceId: 'light.kitchen_counter', kind: DeviceKind.light, position: PlanPoint(640, 60)),
  Placement(deviceId: 'light.kitchen_pendant', kind: DeviceKind.light, position: PlanPoint(560, 250)),
  Placement(deviceId: 'media_player.kitchen', kind: DeviceKind.speaker, position: PlanPoint(670, 320)),
  Placement(deviceId: 'light.wc', kind: DeviceKind.light, position: PlanPoint(770, 180)),
  Placement(deviceId: 'light.sleep_bedside', kind: DeviceKind.light, position: PlanPoint(980, 80)),
  Placement(deviceId: 'media_player.sleep', kind: DeviceKind.speaker, position: PlanPoint(880, 400)),
  Placement(deviceId: 'plant-demo-monstera', kind: DeviceKind.plant, position: PlanPoint(290, 120)),
  Placement(deviceId: 'plant-demo-basil', kind: DeviceKind.plant, position: PlanPoint(540, 140)),
  Placement(deviceId: 'plant-demo-pothos', kind: DeviceKind.plant, position: PlanPoint(250, 410)),
  Placement(deviceId: 'plant-demo-fern', kind: DeviceKind.plant, position: PlanPoint(960, 330)),
  Placement(deviceId: 'plant-demo-fig', kind: DeviceKind.plant, position: PlanPoint(620, 410)),
];

/// Plants of the demo home in every watering state, relative to [now].
List<Plant> demoPlants(DateTime now) {
  DateTime daysAgo(int days) => now.subtract(Duration(days: days));
  return [
    Plant(id: 'plant-demo-monstera', name: 'Monstera', everyDays: 7, lastWatered: daysAgo(9)),
    Plant(id: 'plant-demo-basil', name: 'Basil', everyDays: 2, lastWatered: daysAgo(2)),
    Plant(id: 'plant-demo-pothos', name: 'Pothos', everyDays: 5, lastWatered: daysAgo(6)),
    Plant(id: 'plant-demo-fern', name: 'Boston fern', everyDays: 3, lastWatered: now, previousWatered: daysAgo(3)),
    Plant(id: 'plant-demo-fig', name: 'Fiddle leaf fig', everyDays: 7, lastWatered: daysAgo(3)),
    Plant(id: 'plant-demo-snake', name: 'Snake plant', everyDays: 14, lastWatered: daysAgo(5)),
  ];
}
