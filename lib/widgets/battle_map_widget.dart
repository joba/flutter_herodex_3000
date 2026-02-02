import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_herodex_3000/managers/location_manager.dart';

class BattleMapWidget extends StatefulWidget {
  final LocationManager locationManager;

  const BattleMapWidget({super.key, required this.locationManager});

  @override
  State<BattleMapWidget> createState() => _BattleMapWidgetState();
}

class _BattleMapWidgetState extends State<BattleMapWidget> {
  Position? _userPosition;
  bool _locationPermissionGranted = false;

  // Made-up battle locations
  final List<BattleLocation> _battleLocations = [
    BattleLocation(
      name: 'Battle of Metropolis',
      position: LatLng(40.7128, -74.0060), // New York
      description: 'Superman vs Doomsday',
    ),
    BattleLocation(
      name: 'Gotham City Clash',
      position: LatLng(41.8781, -87.6298), // Chicago
      description: 'Batman vs Joker',
    ),
    BattleLocation(
      name: 'Central City Showdown',
      position: LatLng(39.7392, -104.9903), // Denver
      description: 'Flash vs Reverse Flash',
    ),
    BattleLocation(
      name: 'Atlantis Defense',
      position: LatLng(25.7617, -80.1918), // Miami
      description: 'Aquaman vs Ocean Master',
    ),
    BattleLocation(
      name: 'Themyscira Invasion',
      position: LatLng(37.7749, -122.4194), // San Francisco
      description: 'Wonder Woman vs Ares',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final position = await widget.locationManager.getCurrentPosition();
    if (position != null) {
      setState(() {
        _userPosition = position;
        _locationPermissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(30),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(57.25592, 16.47252),
          initialZoom: 10.0,
          minZoom: 3.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_herodex_3000',
          ),
          MarkerLayer(
            markers: [
              // Battle location markers
              ..._battleLocations.map(
                (battle) => Marker(
                  point: battle.position,
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      _showBattleInfo(context, battle);
                    },
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: theme.colorScheme.error,
                      size: 30,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
              // User location marker (if available)
              if (_locationPermissionGranted && _userPosition != null)
                Marker(
                  point: LatLng(
                    _userPosition!.latitude,
                    _userPosition!.longitude,
                  ),
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.person_pin_circle,
                    color: theme.colorScheme.primary,
                    size: 40,
                    shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBattleInfo(BuildContext context, BattleLocation battle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(battle.name),
        content: Text(battle.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class BattleLocation {
  final String name;
  final LatLng position;
  final String description;

  BattleLocation({
    required this.name,
    required this.position,
    required this.description,
  });
}
