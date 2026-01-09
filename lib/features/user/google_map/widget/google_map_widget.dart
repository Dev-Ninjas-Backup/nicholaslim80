import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ZipBee/features/user/google_map/service/service_zone_service.dart';
import 'package:ZipBee/features/user/collect_form_on_express_delivery/Sender_Part/controller_sender/sender_controller.dart';
import 'package:get/get.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  // static const LatLng _source = LatLng(23.8295064, 90.5637427); // Green
  // static const LatLng _destination = LatLng(23.7806968, 90.3980995); // Ambon

  LatLng? _currentPosition;
  LatLng? _initialFocus;
  Marker? _selectedMarker;
  // Map<PolylineId, Polyline> polylines = {}; // polyline drawing is commented out per request

  // Subscription for location updates — canceled on dispose to avoid setState after dispose
  StreamSubscription<LocationData>? _locSub;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Fetch service zone center (centroid of first zone)
    final zoneCenter = await ServiceZoneService.getFirstZoneCenter();
    if (zoneCenter != null) {
      setState(() {
        _initialFocus = zoneCenter;
      });
      debugPrint('Service zone center: $_initialFocus');
    }

    // Start location tracking (keeps updating current position marker)
    await getLocationUpdate();

    // polyline generation and fitting commented out per request
    // final coordinates = await getPolyLinePoints();
    // generatePolyLinePoints(coordinates);

    // Fit camera to route (only if polyline exists and no initial focus)
    // if (_initialFocus == null) {
    //   await _fitCameraToPolyline(coordinates);
    // }

    // polyline route printing disabled (polyline generation commented out)
    // Debug: polyline debug output disabled
  }

  @override
  Widget build(BuildContext context) {
    // Show map as soon as either we have a focus or user location
    final showMap = _initialFocus != null || _currentPosition != null;

    return Scaffold(
      body: !showMap
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) async {
                if (!_mapController.isCompleted) _mapController.complete(controller);
                // Move camera to initial focus if available, otherwise to current position
                final target = _initialFocus ?? _currentPosition;
                if (target != null) {
                  await _cameraToPosition(target);
                }
              },
              initialCameraPosition: CameraPosition(
                target: _initialFocus ?? const LatLng(23.8022478, 90.3799354),
                zoom: 11,
              ),
              markers: {
                if (_currentPosition != null)
                  Marker(
                    markerId: const MarkerId('current'),
                    position: _currentPosition!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure),
                  ),
                if (_selectedMarker != null) _selectedMarker!,
                // Static source/destination markers commented out per request
                // const Marker(
                //   markerId: MarkerId('source'),
                //   position: _source,
                // ),
                // const Marker(
                //   markerId: MarkerId('destination'),
                //   position: _destination,
                // ),
              },
              // polylines are commented out per request
              // polylines: Set<Polyline>.of(polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (latlng) {
                setState(() {
                  _selectedMarker = Marker(
                    markerId: const MarkerId('selected'),
                    position: latlng,
                  );
                });

                // Update the recipient address text field with lat,lng (no geocoding)
                final sender = Get.put(SenderController());
                sender.addressController.text = '${latlng.latitude}, ${latlng.longitude}';
                debugPrint('Map tapped at: ${latlng.latitude}, ${latlng.longitude}');
              },
            ),
    );
  }

  // Move camera to given LatLng
  Future<void> _cameraToPosition(LatLng pos) async {
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 14),
      ),
    );
  }


  // Track live location
  Future<void> getLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locSub = _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (!mounted) return; // avoid calling setState after dispose
        setState(() {
          _currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
        // Do not auto-move the camera on every location update to preserve user's view
        // debugPrint("Current Location: $_currentPosition");
      }
    });
  }

  // Get polyline points using Flutter Polyline Points
  Future<List<LatLng>> getPolyLinePoints() async {
    // Polyline generation is currently disabled per request.
    debugPrint('getPolyLinePoints: polyline generation disabled');
    return [];
  }

  // Draw polyline on map (disabled)
  void generatePolyLinePoints(List<LatLng> polylineCoordinates) {
    // polyline drawing disabled per request
    debugPrint('generatePolyLinePoints: disabled');
  }

  @override
  void dispose() {
    _locSub?.cancel();
    super.dispose();
  }
}
