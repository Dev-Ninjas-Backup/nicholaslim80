import 'dart:async';

import 'package:ZipBee/features/user/google_map/widget/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _source = LatLng(23.8295064, 90.5637427); // Green
  static const LatLng _destination = LatLng(23.7806968, 90.3980995); // Ambon

  LatLng? _currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Start location tracking
    await getLocationUpdate();

    // Get polyline points
    final coordinates = await getPolyLinePoints();
    generatePolyLinePoints(coordinates);

    // Fit camera to route
    await _fitCameraToPolyline(coordinates);

    // Debug: print all route points
    for (final p in coordinates) {
      debugPrint("Route point: ${p.latitude}, ${p.longitude}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _mapController.complete(controller),
              initialCameraPosition: const CameraPosition(
                target: LatLng(23.8022478,90.3799354),
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
                const Marker(
                  markerId: MarkerId('source'),
                  position: _source,
                ),
                const Marker(
                  markerId: MarkerId('destination'),
                  position: _destination,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
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

  // Fit camera to polyline bounds
  Future<void> _fitCameraToPolyline(List<LatLng> points) async {
    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = point.latitude < minLat ? point.latitude : minLat;
      maxLat = point.latitude > maxLat ? point.latitude : maxLat;
      minLng = point.longitude < minLng ? point.longitude : minLng;
      maxLng = point.longitude > maxLng ? point.longitude : maxLng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
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

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
        // _cameraToPosition(_currentPosition!);
        // debugPrint("Current Location: $_currentPosition");
      }
    });
  }

  // Get polyline points using Flutter Polyline Points
  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    final PolylinePoints polylinePoints = PolylinePoints(apiKey: GoogleMapAPIKey);

    final PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_source.latitude, _source.longitude),
        destination: PointLatLng(_destination.latitude, _destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (final point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    } else {
      debugPrint("Polyline error: ${result.errorMessage}");
    }

    return polylineCoordinates;
  }

  // Draw polyline on map
  void generatePolyLinePoints(List<LatLng> polylineCoordinates) {
    final PolylineId id = const PolylineId("poly");
    final Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }
}
