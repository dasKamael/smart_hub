import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Takes a photo in the hub itself and returns its temporary path; `null` when closed. The system camera app has no
/// way back without the navigation bar the kiosk hides.
Future<String?> showCameraCapture(BuildContext context) {
  return Navigator.of(context).push<String>(
    PageRouteBuilder(
      transitionDuration: HubMotion.fadeDuration,
      reverseTransitionDuration: HubMotion.fadeDuration,
      pageBuilder: (context, animation, _) => FadeTransition(opacity: animation, child: const CameraCapture()),
    ),
  );
}

/// Full screen preview with a shutter, a close button and – with several cameras – one to switch between them.
class CameraCapture extends StatefulWidget {
  const CameraCapture({super.key});

  @override
  State<CameraCapture> createState() => _CameraCaptureState();
}

class _CameraCaptureState extends State<CameraCapture> {
  static final _log = Logger('CameraCapture');

  List<CameraDescription> _cameras = const [];
  CameraController? _controller;
  var _taking = false;
  String? _problem;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      _cameras = await availableCameras();
      // The back camera first: plants are photographed, not the person holding the tablet.
      final back = _cameras.where((camera) => camera.lensDirection == CameraLensDirection.back).firstOrNull;
      final first = back ?? _cameras.firstOrNull;
      if (first == null) {
        if (mounted) setState(() => _problem = 'No camera found');
        return;
      }
      await _open(first);
    } on CameraException catch (error) {
      _log.warning('Camera not available', error);
      if (mounted) setState(() => _problem = 'The camera is not available');
    }
  }

  Future<void> _open(CameraDescription camera) async {
    final old = _controller;
    final controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
    setState(() => _controller = null);
    await old?.dispose();
    try {
      await controller.initialize();
    } on CameraException catch (error) {
      _log.warning('Camera not available', error);
      await controller.dispose();
      if (mounted) setState(() => _problem = 'The camera is not available');
      return;
    }
    if (!mounted) return unawaited(controller.dispose());
    setState(() => _controller = controller);
  }

  Future<void> _switch() async {
    final current = _controller?.description;
    if (current == null || _cameras.length < 2) return;
    await _open(_cameras[(_cameras.indexOf(current) + 1) % _cameras.length]);
  }

  Future<void> _take() async {
    final controller = _controller;
    if (controller == null || _taking) return;
    setState(() => _taking = true);
    try {
      final file = await controller.takePicture();
      if (mounted) Navigator.of(context).pop(file.path);
    } on CameraException catch (error) {
      _log.warning('Taking the photo failed', error);
      if (mounted) setState(() => _taking = false);
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return ColoredBox(
      color: const Color(0xFF000000),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: switch ((controller, _problem)) {
              (_, final problem?) => Text(problem, style: HubTextStyles.secondary),
              (final controller?, _) => CameraPreview(controller),
              _ => const SizedBox.shrink(),
            },
          ),
          Positioned(
            left: 24,
            top: 24,
            child: _CameraButton(
              glyph: HubGlyph.close,
              label: 'Close camera',
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            right: 32,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 28,
              children: [
                _Shutter(onTap: controller == null || _taking ? null : () => unawaited(_take())),
                if (_cameras.length > 1)
                  _CameraButton(glyph: HubGlyph.sync, label: 'Switch camera', onTap: () => unawaited(_switch())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  const _CameraButton({required this.glyph, required this.label, required this.onTap});

  final HubGlyph glyph;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: HubColorPalette.card,
            shape: BoxShape.circle,
            border: Border.all(color: HubColorPalette.cardBorder),
          ),
          child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(20)),
        ),
      ),
    );
  }
}

/// The white ring that takes the photo; dimmed while the camera starts or a photo is being taken.
class _Shutter extends StatelessWidget {
  const _Shutter({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Take photo',
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: HubMotion.fadeDuration,
          opacity: onTap == null ? 0.4 : 1,
          child: Container(
            width: 84,
            height: 84,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: HubColorPalette.text, width: 4),
            ),
            child: const DecoratedBox(
              decoration: BoxDecoration(color: HubColorPalette.text, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }
}
