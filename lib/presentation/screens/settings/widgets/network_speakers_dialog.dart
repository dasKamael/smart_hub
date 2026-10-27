import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/music/network_speakers.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Adds the speakers in the home network: pick a found one or type the address of any of them – the others of the
/// system come along.
Future<void> showNetworkSpeakersDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => const NetworkSpeakersDialog(),
  );
}

class NetworkSpeakersDialog extends ConsumerStatefulWidget {
  const NetworkSpeakersDialog({super.key});

  @override
  ConsumerState<NetworkSpeakersDialog> createState() => _NetworkSpeakersDialogState();
}

class _NetworkSpeakersDialogState extends ConsumerState<NetworkSpeakersDialog> {
  List<String>? _found;
  var _address = '';
  var _busy = false;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_search());
  }

  Future<void> _search() async {
    final found = await ref.read(networkSpeakersServiceProvider.notifier).discover();
    if (mounted) setState(() => _found = found);
  }

  Future<void> _add(String host) async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final added = await ref.read(networkSpeakersServiceProvider.notifier).add(host);
    if (!mounted) return;
    if (added) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _busy = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final found = _found;
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
              const Text('Speakers in the network', style: HubTextStyles.pageTitle),
              if (found == null)
                const Center(child: SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2)))
              else
                for (final host in found) _FoundSpeaker(host: host, onTap: _busy ? null : () => unawaited(_add(host))),
              HubTextField(
                label: 'Address of a speaker',
                hint: '192.168.1.24',
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _address = value.trim()),
                onSubmitted: (value) => value.trim().isEmpty ? null : unawaited(_add(value.trim())),
              ),
              if (_failed)
                Text(
                  'No speaker answers at this address.',
                  style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: HubSpacing.s12,
                children: [
                  HubButton(
                    label: 'Cancel',
                    variant: HubButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  HubButton(
                    label: 'Add',
                    isLoading: _busy,
                    onPressed: _address.isEmpty ? null : () => unawaited(_add(_address)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoundSpeaker extends StatelessWidget {
  const _FoundSpeaker({required this.host, required this.onTap});

  final String host;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: host,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(14)),
          child: Row(
            spacing: HubSpacing.s12,
            children: [
              const HubGlyphIcon(HubGlyph.speaker, color: HubColorPalette.playing),
              Expanded(child: Text(host, style: HubTextStyles.body.copyWith(fontSize: 16))),
              const HubGlyphIcon(HubGlyph.plus, color: HubColorPalette.text2, size: Size.square(14)),
            ],
          ),
        ),
      ),
    );
  }
}
