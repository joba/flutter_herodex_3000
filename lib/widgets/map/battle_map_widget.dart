import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_herodex_3000/managers/location_manager.dart';
import 'package:flutter_herodex_3000/data/map_locations.dart';
import 'package:flutter_herodex_3000/widgets/map/battle_info_dialog.dart';
import 'package:flutter_herodex_3000/widgets/map/map_markers.dart';
import 'package:flutter_herodex_3000/widgets/map/map_zoom_controls.dart';

class BattleMapWidget extends StatefulWidget {
  final LocationManager locationManager;

  const BattleMapWidget({super.key, required this.locationManager});

  @override
  State<BattleMapWidget> createState() => _BattleMapWidgetState();
}

class _BattleMapWidgetState extends State<BattleMapWidget> {
  Position? _userPosition;
  bool _locationPermissionGranted = false;
  final MapController _mapController = MapController();

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
    } else {
      setState(() {
        _userPosition = null;
        _locationPermissionGranted = false;
      });
    }
    _mapController.move(
      LatLng(position?.latitude ?? 40.7128, position?.longitude ?? -74.0060),
      AppConstants.defaultMapMaxZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(AppTexts.home.mapTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppConstants.appPaddingBase),
        Container(
          height: AppConstants.mapHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(30),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialZoom: AppConstants.defaultMapZoom,
                  minZoom: AppConstants.defaultMapMinZoom,
                  maxZoom: AppConstants.defaultMapMaxZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.flutter_herodex_3000',
                  ),
                  MarkerLayer(
                    markers: [
                      ...MapMarkers.buildBattleMarkers(
                        locations: MapLocationsData.battleLocations,
                        context: context,
                        onTap: BattleInfoDialog.show,
                      ),
                      if (MapMarkers.buildUserMarker(
                            position: _userPosition,
                            permissionGranted: _locationPermissionGranted,
                            context: context,
                          ) !=
                          null)
                        MapMarkers.buildUserMarker(
                          position: _userPosition,
                          permissionGranted: _locationPermissionGranted,
                          context: context,
                        )!,
                    ],
                  ),
                ],
              ),
              MapZoomControls(
                mapController: _mapController,
                initialCenter: LatLng(
                  _userPosition?.latitude ??
                      MapLocationsData.defaultInitialLocation.position.latitude,
                  _userPosition?.longitude ??
                      MapLocationsData
                          .defaultInitialLocation
                          .position
                          .longitude,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
