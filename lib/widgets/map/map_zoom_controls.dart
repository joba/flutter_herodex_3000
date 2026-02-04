import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';

class MapZoomControls extends StatelessWidget {
  final MapController mapController;
  final LatLng initialCenter;

  const MapZoomControls({
    super.key,
    required this.mapController,
    required this.initialCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppConstants.appPaddingBase / 2,
      bottom: AppConstants.appPaddingBase / 2,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'center',
            onPressed: () {
              mapController.move(initialCenter, AppConstants.defaultMapMaxZoom);
            },
            child: const Icon(Icons.center_focus_strong),
          ),
          const SizedBox(height: AppConstants.appPaddingBase / 4),
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () {
              final currentZoom = mapController.camera.zoom;
              mapController.move(mapController.camera.center, currentZoom + 1);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: AppConstants.appPaddingBase / 4),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () {
              final currentZoom = mapController.camera.zoom;
              mapController.move(mapController.camera.center, currentZoom - 1);
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
