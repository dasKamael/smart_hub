import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:smart_hub/presentation/shared_widgets/camera_capture.dart';

import '../../utils/widget.test_util.dart';

void main() {
  group('CameraCapture', () {
    testWidgets('Given a device without a camera, '
        'when opening the camera and closing it, '
        'then it says so and returns no photo', (tester) async {
      // Given
      CameraPlatform.instance = _NoCameras();
      String? result = 'unset';
      final context = await loadWidgetTestApp(tester: tester, underTestWidget: const SizedBox.shrink());

      // When
      final closed = showCameraCapture(context).then((path) => result = path);
      await tester.pumpAndSettle();
      final message = find.text('No camera found').evaluate().length;
      await tester.tap(find.bySemanticsLabel('Close camera'));
      await tester.pumpAndSettle();
      await closed;

      // Then
      expect(message, 1);
      expect(result, isNull);
    });
  });
}

class _NoCameras extends CameraPlatform with MockPlatformInterfaceMixin {
  @override
  Future<List<CameraDescription>> availableCameras() async => const [];
}
