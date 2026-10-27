import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_location.repository.g.dart';

/// Where the tablet is. Coarse is enough for the weather; without GPS Android locates by Wi-Fi.
class DeviceLocationRepository {
  /// `null` when location is off, not allowed or not found.
  Future<({double latitude, double longitude})?> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return null;
    // Wi-Fi first (fast, enough for the weather), then any source – some devices only know their GPS position.
    final position =
        await Geolocator.getLastKnownPosition() ??
        await _locate(LocationAccuracy.low) ??
        await _locate(LocationAccuracy.high);
    return position == null ? null : (latitude: position.latitude, longitude: position.longitude);
  }

  static Future<Position?> _locate(LocationAccuracy accuracy) async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy, timeLimit: const Duration(seconds: 15)),
      );
    } on TimeoutException {
      return null;
    }
  }
}

/// Providers
@Riverpod(keepAlive: true)
DeviceLocationRepository deviceLocationRepository(Ref ref) => DeviceLocationRepository();
