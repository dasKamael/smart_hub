import 'dart:convert';
import 'dart:io';

import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';

/// The real apartment from `assets/floorplan/floorplan.json`.
FloorPlan loadApartmentPlan() {
  final json = File('assets/floorplan/floorplan.json').readAsStringSync();
  return FloorplanRepository.parse(jsonDecode(json) as Map<String, Object?>);
}
