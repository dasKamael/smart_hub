import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

/// Background and border of a speaker or device tile: the active one stands out, the others stay quiet.
BoxDecoration musicTileDecoration({required bool active}) {
  return BoxDecoration(
    color: active ? Color.alphaBlend(const Color(0x14FFFFFF), HubColorPalette.elevated) : HubColorPalette.elevated,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: active ? HubColorPalette.text.withValues(alpha: 0.8) : const Color(0x14FFFFFF),
      width: 1.5,
    ),
  );
}
