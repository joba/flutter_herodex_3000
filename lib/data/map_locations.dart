import 'package:latlong2/latlong.dart';
import 'package:flutter_herodex_3000/models/map_location.dart';

class MapLocationsData {
  static final List<MapLocation> battleLocations = [
    MapLocation(
      name: 'Battle of Metropolis',
      position: LatLng(40.7128, -74.0060),
      description: 'Superman vs Doomsday',
    ),
    MapLocation(
      name: 'Gotham City Clash',
      position: LatLng(41.8781, -87.6298),
      description: 'Batman vs Joker',
    ),
    MapLocation(
      name: 'Central City Showdown',
      position: LatLng(39.7392, -104.9903),
      description: 'Flash vs Reverse Flash',
    ),
    MapLocation(
      name: 'Atlantis Defense',
      position: LatLng(25.7617, -80.1918),
      description: 'Aquaman vs Ocean Master',
    ),
    MapLocation(
      name: 'Themyscira Invasion',
      position: LatLng(37.7749, -122.4194),
      description: 'Wonder Woman vs Ares',
    ),
  ];

  static final MapLocation defaultInitialLocation = battleLocations[0];
}
