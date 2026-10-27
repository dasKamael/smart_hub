import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/dashboard/widgets/home_summary_widget.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_widget.dart';

/// The start page: widgets of all parts of the hub on the 170 px grid. More widgets join with each feature.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: WidgetSize.gap,
          children: [
            WeatherWidget(size: WidgetSize.extraLarge),
            Column(
              spacing: WidgetSize.gap,
              children: [
                HomeSummaryWidget(),
                WeatherWidget(size: WidgetSize.medium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
