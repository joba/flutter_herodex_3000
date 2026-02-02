import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager {
  bool _locationEnabled = false;
  bool _isInitialized = false;

  LocationManager();

  /// Initialize and load saved preference
  Future<void> initialize() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _locationEnabled = prefs.getBool('location_enabled') ?? false;
    _isInitialized = true;
  }

  /// Check if location is enabled
  Future<bool> get isEnabled async {
    if (!_isInitialized) await initialize();
    return _locationEnabled;
  }

  /// Enable or disable location
  Future<void> setLocationEnabled(bool enabled) async {
    _locationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_enabled', enabled);
  }

  /// Check if location services are enabled on the device
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission from the user
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Check and request location permission if needed
  /// Returns true if permission is granted
  Future<bool> checkAndRequestPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check permission status
    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current position if permission is granted
  Future<Position?> getCurrentPosition() async {
    if (!_locationEnabled) return null;

    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }
}
