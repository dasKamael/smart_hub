import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/domain/lights/model/light_bridge.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Pairs a light bridge: pick a found one or type its address, then press the button on the bridge. Returns
/// `true` once paired.
Future<bool?> showLightBridgeDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => const LightBridgeDialog(),
  );
}

class LightBridgeDialog extends ConsumerStatefulWidget {
  const LightBridgeDialog({super.key});

  @override
  ConsumerState<LightBridgeDialog> createState() => _LightBridgeDialogState();
}

enum _Step { search, pressButton, failed }

class _LightBridgeDialogState extends ConsumerState<LightBridgeDialog> {
  var _step = _Step.search;
  List<String>? _found;
  var _address = '';
  String? _host;

  @override
  void initState() {
    super.initState();
    unawaited(_search());
  }

  Future<void> _search() async {
    final found = await ref.read(lightBridgeServiceProvider.notifier).discover();
    if (mounted) setState(() => _found = found);
  }

  Future<void> _pair(String host) async {
    setState(() {
      _host = host;
      _step = _Step.pressButton;
    });
    final paired = await ref.read(lightBridgeServiceProvider.notifier).pair(host, isCancelled: () => !mounted);
    if (!mounted) return;
    if (paired) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _step = _Step.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s16,
            children: [
              const Text('Pair light bridge', style: HubTextStyles.pageTitle),
              ...switch (_step) {
                _Step.search => _searchStep(),
                _Step.pressButton => _pressButtonStep(),
                _Step.failed => _failedStep(),
              },
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _searchStep() {
    final paired = {
      for (final bridge in ref.watch(lightBridgeServiceProvider).value ?? const <LightBridge>[]) bridge.host,
    };
    final found = _found?.where((host) => !paired.contains(host)).toList();
    return [
      Text(
        'The hub talks to the bridge directly in your home network – no account, no cloud.',
        style: HubTextStyles.secondary,
      ),
      if (found == null)
        Row(
          spacing: HubSpacing.s12,
          children: [
            const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            Text('Looking for bridges …', style: HubTextStyles.secondary.copyWith(color: HubColorPalette.text)),
          ],
        )
      else if (found.isEmpty)
        Text(
          paired.isEmpty
              ? 'No bridge found. Type its address – the app of your lights shows it.'
              : 'No other bridge found. Type its address – the app of your lights shows it.',
          style: HubTextStyles.secondary,
        )
      else
        for (final host in found) _FoundBridge(host: host, onTap: () => unawaited(_pair(host))),
      HubTextField(
        label: 'Address of the bridge',
        hint: '192.168.1.20',
        keyboardType: TextInputType.number,
        onChanged: (value) => setState(() => _address = value.trim()),
        onSubmitted: (value) => value.trim().isEmpty ? null : unawaited(_pair(value.trim())),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: HubSpacing.s12,
        children: [
          HubButton(
            label: 'Cancel',
            variant: HubButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          HubButton(label: 'Pair', onPressed: _address.isEmpty ? null : () => unawaited(_pair(_address))),
        ],
      ),
    ];
  }

  List<Widget> _pressButtonStep() => [
    Row(
      spacing: HubSpacing.s16,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: HubColorPalette.accent, width: 3),
            boxShadow: const [BoxShadow(color: HubColorPalette.accentTint, blurRadius: 24, spreadRadius: 4)],
          ),
          alignment: Alignment.center,
          child: const HubGlyphIcon(HubGlyph.bulb, color: HubColorPalette.text),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: HubSpacing.s4,
            children: [
              Text('Press the round button on the bridge', style: HubTextStyles.body),
              Text('At $_host · the hub waits up to a minute.', style: HubTextStyles.secondary),
            ],
          ),
        ),
      ],
    ),
    const LinearProgressIndicator(
      minHeight: 3,
      color: HubColorPalette.accent,
      backgroundColor: HubColorPalette.control,
    ),
    Align(
      alignment: Alignment.centerRight,
      child: HubButton(
        label: 'Cancel',
        variant: HubButtonVariant.secondary,
        onPressed: () => Navigator.of(context).pop(false),
      ),
    ),
  ];

  List<Widget> _failedStep() => [
    Text(
      'The bridge at $_host did not answer in time. Is the address right, and was its button pressed?',
      style: HubTextStyles.secondary,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: HubSpacing.s12,
      children: [
        HubButton(
          label: 'Cancel',
          variant: HubButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        HubButton(label: 'Try again', onPressed: () => setState(() => _step = _Step.search)),
      ],
    ),
  ];
}

class _FoundBridge extends StatelessWidget {
  const _FoundBridge({required this.host, required this.onTap});

  final String host;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Bridge at $host',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(14)),
          child: Row(
            spacing: HubSpacing.s12,
            children: [
              const HubGlyphIcon(HubGlyph.bulb, color: HubColorPalette.lightWarm),
              Expanded(child: Text('Bridge at $host', style: HubTextStyles.body.copyWith(fontSize: 16))),
              const HubGlyphIcon(HubGlyph.plus, color: HubColorPalette.text2, size: Size.square(14)),
            ],
          ),
        ),
      ),
    );
  }
}
