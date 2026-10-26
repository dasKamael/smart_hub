import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

abstract final class HubTheme {
  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: HubColorPalette.bg,
      canvasColor: HubColorPalette.bg,
      colorScheme: const ColorScheme.dark(
        surface: HubColorPalette.surface,
        primary: HubColorPalette.accent,
        error: HubColorPalette.danger,
        onSurface: HubColorPalette.text,
      ),
      dividerColor: HubColorPalette.separator,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textTheme: base.textTheme.copyWith(
        displayLarge: HubTextStyles.display,
        headlineMedium: HubTextStyles.pageTitle,
        headlineSmall: HubTextStyles.sectionTitle,
        titleLarge: HubTextStyles.widgetTitle,
        bodyLarge: HubTextStyles.body,
        bodyMedium: HubTextStyles.secondary,
        labelLarge: HubTextStyles.label,
        labelSmall: HubTextStyles.micro,
      ),
    );
  }
}
