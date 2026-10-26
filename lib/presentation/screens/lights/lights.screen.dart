import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

class LightsScreen extends StatelessWidget {
  const LightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageCard(
      child: Center(child: Text('Lights', style: HubTextStyles.secondary)),
    );
  }
}
