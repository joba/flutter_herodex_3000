import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_herodex_3000/models/map_location.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';

class MapMarkers {
  static List<Marker> buildBattleMarkers({
    required List<MapLocation> locations,
    required BuildContext context,
    required Function(BuildContext, MapLocation) onTap,
  }) {
    final theme = Theme.of(context);
    return locations
        .map(
          (battle) => Marker(
            point: battle.position,
            width: AppConstants.mapMarkerSize,
            height: AppConstants.mapMarkerSize,
            child: GestureDetector(
              onTap: () => onTap(context, battle),
              child: Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: AppConstants.mapMarkerSize,
                shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
              ),
            ),
          ),
        )
        .toList();
  }

  static Marker? buildUserMarker({
    required Position? position,
    required bool permissionGranted,
    required BuildContext context,
  }) {
    if (!permissionGranted || position == null) return null;

    final theme = Theme.of(context);
    return Marker(
      point: LatLng(position.latitude, position.longitude),
      width: AppConstants.mapMarkerSize,
      height: AppConstants.mapMarkerSize,
      child: Icon(
        Icons.person_pin_circle,
        color: theme.colorScheme.primary,
        size: AppConstants.mapMarkerSize,
        shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
      ),
    );
  }
}
