import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_theme.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';

/// Acceptance criterion: dragging stays at 60 fps with ~30 markers.
///
/// Run in profile mode: `flutter drive --profile --driver=test_driver/perf_driver.dart
/// --target=integration_test/plan_drag_perf_test.dart`. The summary lands in `build/plan_drag.timeline_summary.json`.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('drag a light across the plan with 30 markers', (tester) async {
    final random = math.Random(7);
    final lights = [
      for (var i = 0; i < 24; i++)
        LightState(
          id: 'light.l$i',
          name: 'Light $i',
          isOn: i.isEven,
          brightnessPercent: 30 + random.nextInt(70),
          color: RgbColor(255, 120 + random.nextInt(130), 60 + random.nextInt(190)),
          capabilities: const {LightCapability.brightness, LightCapability.color},
        ),
    ];
    final placements = [
      for (final (i, light) in lights.indexed)
        Placement(
          deviceId: light.id,
          kind: DeviceKind.light,
          position: PlanPoint(60 + (i % 8) * 125.0, 60 + (i ~/ 8) * 140.0),
        ),
      for (var i = 0; i < 6; i++)
        Placement(deviceId: 'media_player.s$i', kind: DeviceKind.speaker, position: PlanPoint(120 + i * 150.0, 400)),
    ];

    final plan = FloorplanRepository.parse(
      jsonDecode(await rootBundle.loadString(FloorplanRepository.initialPlanAsset)) as Map<String, Object?>,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          floorPlanServiceProvider.overrideWith((ref) async => plan),
          lightsServiceProvider.overrideWith(() => _Lights(lights)),
          speakersServiceProvider.overrideWith(_Speakers.new),
          placementServiceProvider.overrideWith(() => _Placements(placements)),
          connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
        ],
        child: MaterialApp(
          theme: HubTheme.dark,
          home: const Scaffold(
            body: Padding(padding: EdgeInsets.all(24), child: FloorplanScreen()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final marker = find.byWidgetPredicate((w) => w is DeviceMarker && w.label == 'Light 0');
    expect(find.byType(DeviceMarker), findsNWidgets(30));

    Future<void> dragAround() async {
      final gesture = await tester.startGesture(tester.getCenter(marker));
      for (var step = 0; step < 240; step++) {
        final angle = step / 240 * 4 * math.pi;
        await gesture.moveBy(Offset(math.cos(angle) * 6, math.sin(angle) * 3));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await tester.pumpAndSettle();
    }

    // Baseline: the plan without any change, frames forced every 16 ms.
    await binding.traceAction(() async {
      for (var i = 0; i < 120; i++) {
        binding.scheduleForcedFrame();
        await tester.pump(const Duration(milliseconds: 16));
      }
    }, reportKey: 'plan_idle');

    await binding.traceAction(dragAround, reportKey: 'plan_drag');

    // Same drag without the light glow, to see what the glow costs.
    await tester.tap(find.text('Glow'));
    await tester.pumpAndSettle();
    await binding.traceAction(dragAround, reportKey: 'plan_drag_no_glow');
  });
}

class _Lights extends LightsService {
  _Lights(this.lights);

  final List<LightState> lights;

  @override
  Future<List<LightState>> build() async => lights;
}

class _Speakers extends SpeakersService {
  @override
  Future<List<SpeakerState>> build() async {
    return [
      for (var i = 0; i < 6; i++)
        SpeakerState(id: 'media_player.s$i', name: 'Speaker $i', playback: i.isEven ? Playback.playing : Playback.idle),
    ];
  }
}

class _Placements extends PlacementService {
  _Placements(this.placements);

  final List<Placement> placements;

  @override
  Stream<List<Placement>> build() => Stream.value(placements);

  @override
  Future<void> place(String deviceId, DeviceKind kind, PlanPoint position) async {}
}
