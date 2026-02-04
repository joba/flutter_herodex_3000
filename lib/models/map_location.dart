import 'package:latlong2/latlong.dart';

class MapLocation {
  final String name;
  final LatLng position;
  final String? description;

  MapLocation({required this.name, required this.position, this.description});
}
