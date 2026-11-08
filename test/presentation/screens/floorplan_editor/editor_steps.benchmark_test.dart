import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';

import '../../../fixtures/floorplan.fixture.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/riverpod.test_util.dart';

/// Counts the steps a person needs in the editor: every tap, drag and picked tool or chip is one step, typing one
/// step per letter. Each call stands for exactly one gesture on the screen.
class _Steps {
  _Steps(this.controller);

  final FloorplanEditorController Function() controller;
  var count = 0;

  /// Touch radius as on the tablet at the editor's usual zoom (about 0.9 cm per pixel).
  static const cmPerPx = 0.9;

  void tool(EditorTool tool) => _step(() => controller().selectTool(tool));

  void tap(PlanPoint at) => _step(() => controller().tap(at, cmPerPx: cmPerPx));

  void drag(PlanPoint from, PlanPoint to) => _step(() {
    controller().startDrag(from, cmPerPx: cmPerPx);
    controller().updateDrag(PlanPoint((from.x + to.x) / 2, (from.y + to.y) / 2), cmPerPx: cmPerPx);
    controller().updateDrag(to, cmPerPx: cmPerPx);
    controller().endDrag();
  });

  /// A button or chip in the side panel.
  void press(void Function(FloorplanEditorController controller) action) => _step(() => action(controller()));

  void _step(void Function() action) {
    count++;
    action();
  }
}

final _results = <String, int>{};

void main() {
  late ProviderContainer container;
  late _Steps steps;

  FloorplanEditorState state() => container.read(floorplanEditorControllerProvider);
  Map<String, double> areasByName() {
    final outlines = LayoutRoomsUtil.outlines(state().layout);
    return {
      for (final room in state().layout.rooms)
        if (outlines[room.id] case final outline?) room.name: PlanGeometryUtil.areaInSquareMeters(outline),
    };
  }

  Future<void> open(HomeLayout layout) async {
    container = createTestContainer(
      overrides: [homeLayoutServiceProvider.overrideWith(() => FakeHomeLayoutService(layout))],
    );
    await container.read(homeLayoutServiceProvider.future);
    container.listen(floorplanEditorControllerProvider, (_, _) {});
    steps = _Steps(() => container.read(floorplanEditorControllerProvider.notifier));
  }

  tearDownAll(() {
    final table = StringBuffer('| Scenario | Steps |\n|---|---|\n');
    for (final MapEntry(key: name, value: count) in _results.entries) {
      table.writeln('| $name | $count |');
    }
    Directory('build').createSync(recursive: true);
    File('build/editor_steps.md').writeAsStringSync(table.toString());
  });

  group('Steps to build rooms', () {
    test('A rectangular room against an existing one, typed as bedroom', () async {
      await open(loadApartmentLayout());

      steps
        ..drag(const PlanPoint(1400, 450), const PlanPoint(1030, 0))
        ..press((c) => c.setRoomType(RoomType.bedroom));

      expect(areasByName()['Bedroom 2'] ?? areasByName()['Bedroom'], closeTo(16.65, 0.01));
      _results['Rectangular room next to another, with its type'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(2));
    });

    test('An L-shaped room in free space, typed as living room', () async {
      await open(loadApartmentLayout());

      // Two rectangles, then the wall between them goes.
      steps
        ..drag(const PlanPoint(1200, 0), const PlanPoint(1600, 200))
        ..drag(const PlanPoint(1600, 400), const PlanPoint(1400, 200))
        ..tap(const PlanPoint(1450, 200))
        ..press((c) => c.deleteWall())
        ..press((c) => c.setRoomType(RoomType.living));

      expect(areasByName()['Living room'], closeTo(12, 0.01));
      _results['L-shaped room, with its type'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(5));
    });

    test('Splitting the kitchen into kitchen and dining', () async {
      await open(loadApartmentLayout());

      steps
        ..drag(const PlanPoint(598, 150), const PlanPoint(603, 300))
        ..press((c) => c.setRoomType(RoomType.dining));

      expect(areasByName()['Dining'], isNotNull);
      _results['Split a room in two, with the new type'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(2));
    });

    test('A door between kitchen and WC, a window on the bedroom', () async {
      await open(loadApartmentLayout());

      steps
        ..tool(EditorTool.door)
        ..tap(const PlanPoint(715, 200))
        ..tool(EditorTool.window)
        ..tap(const PlanPoint(930, 0));

      expect(state().layout.openings.where((o) => o.type == DoorType.window), hasLength(1));
      _results['A door and a window'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(4));
    });

    test('Opening the whole wall between hall and kitchen', () async {
      await open(loadApartmentLayout());
      final wall = LayoutGraphUtil.wallAt(state().layout, const PlanPoint(450, 400), radius: 2)!;
      final (a, b) = LayoutGraphUtil.endsOf(state().layout, wall);

      steps
        ..tool(EditorTool.opening)
        ..drag(a + const PlanPoint(0, 4), b - const PlanPoint(0, 4));

      final opening = state().layout.openings.last;
      expect(opening.wallId, wall.id);
      expect(opening.width, closeTo(a.distanceTo(b), 0.01));
      _results['Open a whole wall'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(2));
    });

    test('Moving the WC wall with the door 60 cm up', () async {
      await open(loadApartmentLayout());

      steps.drag(const PlanPoint(730, 366), const PlanPoint(730, 306));

      final door = state().layout.openings.firstWhere((o) => o.id == 'd5');
      expect(LayoutGraphUtil.openingSegment(state().layout, door)!.$1.y, closeTo(305, 0.5));
      _results['Move a wall; neighbor and door follow'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(1));
    });

    test('Furnishing a bedroom', () async {
      await open(loadApartmentLayout());

      steps
        ..tap(const PlanPoint(930, 300))
        ..press((c) => c.furnishRoom());

      expect(state().layout.furniture.map((item) => item.kind), contains(FurnitureKind.bed));
      _results['Furnish a bedroom'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(2));
    });

    test('The whole apartment from an empty plan: 7 rooms with types, 7 openings, furnished', () async {
      await open(const HomeLayout());

      // The rooms on the right as rectangles, each typed right after drawing.
      steps
        ..drag(const PlanPoint(825, 0), const PlanPoint(1030, 450))
        ..press((c) => c.setRoomType(RoomType.bedroom))
        ..drag(const PlanPoint(715, 0), const PlanPoint(825, 365))
        ..press((c) => c.setRoomType(RoomType.wc))
        ..drag(const PlanPoint(450, 0), const PlanPoint(825, 450))
        ..press((c) => c.setRoomType(RoomType.kitchen))
        ..drag(const PlanPoint(0, 0), const PlanPoint(450, 450));
      // The left block: cut off the corner, then split it into office, hall and the two storage rooms.
      steps
        ..tool(EditorTool.wall)
        ..tap(const PlanPoint(0, 245))
        ..tap(const PlanPoint(190, 245))
        ..tap(const PlanPoint(190, 450))
        ..tap(const PlanPoint(0, 150))
        ..tap(const PlanPoint(240, 150))
        ..tap(const PlanPoint(280, 270))
        ..tap(const PlanPoint(450, 270))
        ..tap(const PlanPoint(280, 270))
        ..tap(const PlanPoint(280, 365))
        ..tap(const PlanPoint(450, 365))
        ..tap(const PlanPoint(370, 270))
        ..tap(const PlanPoint(370, 365))
        ..press((c) => c.setRoomType(RoomType.storage));
      steps
        ..tool(EditorTool.select)
        ..tap(const PlanPoint(320, 320))
        ..press((c) => c.setRoomType(RoomType.storage))
        ..tap(const PlanPoint(100, 60))
        ..press((c) => c.setRoomType(RoomType.office))
        ..tap(const PlanPoint(100, 200))
        ..press((c) => c.setRoomType(RoomType.hall))
        ..tap(const PlanPoint(80, 400))
        ..press((c) => c.deleteRoom());
      // Doors and open passages.
      steps
        ..tool(EditorTool.door)
        ..tap(const PlanPoint(0, 200))
        ..tap(const PlanPoint(130, 150))
        ..tap(const PlanPoint(770, 365))
        ..tool(EditorTool.opening)
        ..tap(const PlanPoint(325, 365))
        ..tap(const PlanPoint(410, 365))
        ..tap(const PlanPoint(450, 408))
        ..tap(const PlanPoint(825, 408))
        ..tool(EditorTool.select)
        ..tap(const PlanPoint(2000, 2000))
        ..press((c) => c.furnishAll());

      final areas = areasByName();
      final apartment = loadApartmentPlan();
      for (final (name, original) in [
        ('Office', 'office'),
        ('Hall', 'hall'),
        ('Kitchen', 'kitchen'),
        ('WC', 'wc'),
        ('Bedroom', 'sleep'),
      ]) {
        final room = apartment.rooms.firstWhere((room) => room.id == original);
        expect(areas[name], closeTo(PlanGeometryUtil.areaInSquareMeters(room.polygon), 0.01), reason: name);
      }
      expect(areas.keys, containsAll(['Storage', 'Storage 2']));
      expect(state().layout.rooms, hasLength(7));
      expect(state().layout.openings, hasLength(7));
      expect(state().layout.furniture, isNotEmpty);
      _results['Whole apartment from scratch (7 rooms, 7 openings, furnished)'] = steps.count;
      expect(steps.count, lessThanOrEqualTo(45));
    });
  });
}
