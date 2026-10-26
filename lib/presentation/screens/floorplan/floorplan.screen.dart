import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

class FloorplanScreen extends StatelessWidget {
  const FloorplanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageCard(
      child: Center(child: Text('Floor plan', style: HubTextStyles.secondary)),
    );
  }
}
