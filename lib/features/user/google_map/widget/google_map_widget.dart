import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ZipBee/features/user/google_map/service/service_zone_service.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:get/get.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Location _location = Location();
  final Completer<GoogleMapController> _mapController = Completer();

  final RiderController riderController = Get.find<RiderController>();

  LatLng? _currentPosition;
  LatLng? _initialFocus;
  Marker? _selectedMarker;

  StreamSubscription<LocationData>? _locSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final zoneCenter = await ServiceZoneService.getFirstZoneCenter();
    if (!mounted) return;

    if (zoneCenter != null) {
      setState(() => _initialFocus = zoneCenter);
    }

    await _listenLocation();
  }

  @override
  Widget build(BuildContext context) {
    final showMap = _initialFocus != null || _currentPosition != null;

    return !showMap
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  _initialFocus ??
                  _currentPosition ??
                  const LatLng(23.8022478, 90.3799354),
              zoom: 11,
            ),
            onMapCreated: (controller) async {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }

              final target = _initialFocus ?? _currentPosition;
              if (target != null) {
                await _moveCamera(target);
              }
            },
            markers: {
              if (_currentPosition != null)
                Marker(
                  markerId: const MarkerId('current'),
                  position: _currentPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
              if (_selectedMarker != null) _selectedMarker!,
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,

            /// 📍 TAP → pickup lat/lng
            onTap: (latLng) {
              setState(() {
                _selectedMarker = Marker(
                  markerId: const MarkerId('selected'),
                  position: latLng,
                );
              });

              riderController.setPickupLocation(
                latLng.latitude,
                latLng.longitude,
              );

              debugPrint(
                '📍 Pickup set: ${latLng.latitude}, ${latLng.longitude}',
              );
            },
          );
  }

  Future<void> _moveCamera(LatLng pos) async {
    final c = await _mapController.future;
    await c.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 14)),
    );
  }

  Future<void> _listenLocation() async {
    if (!await _location.serviceEnabled()) {
      if (!await _location.requestService()) return;
    }

    if (await _location.hasPermission() == PermissionStatus.denied) {
      if (await _location.requestPermission() != PermissionStatus.granted)
        return;
    }

    _locSub = _location.onLocationChanged.listen((loc) {
      if (!mounted) return;

      if (loc.latitude != null && loc.longitude != null) {
        setState(() {
          _currentPosition = LatLng(loc.latitude!, loc.longitude!);
        });
      }
    });
  }

  @override
  void dispose() {
    _locSub?.cancel();
    super.dispose();
  }
}
