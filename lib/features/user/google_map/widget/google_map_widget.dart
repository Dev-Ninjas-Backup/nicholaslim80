import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ZipBee/features/user/google_map/service/service_zone_service.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:get/get.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_MapData>(
      future: _initializeMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return _GoogleMapContent(data: data);
      },
    );
  }

  static Future<_MapData> _initializeMap() async {
    final location = Location();
    final riderController = Get.isRegistered<RiderController>()
        ? Get.find<RiderController>()
        : Get.put(RiderController());

    final zoneCenter = await ServiceZoneService.getFirstZoneCenter();
    final initialFocus = zoneCenter ?? const LatLng(23.8022478, 90.3799354);

    LatLng? currentPosition;
    if (await location.serviceEnabled() &&
        await location.hasPermission() != PermissionStatus.denied) {
      try {
        final locData = await location.getLocation();
        if (locData.latitude != null && locData.longitude != null) {
          currentPosition = LatLng(locData.latitude!, locData.longitude!);
        }
      } catch (_) {}
    }

    return _MapData(
      riderController: riderController,
      initialFocus: initialFocus,
      currentPosition: currentPosition,
      location: location,
    );
  }
}

class _MapData {
  final RiderController riderController;
  final LatLng initialFocus;
  final LatLng? currentPosition;
  final Location location;

  _MapData({
    required this.riderController,
    required this.initialFocus,
    this.currentPosition,
    required this.location,
  });
}

class _GoogleMapContent extends StatefulWidget {
  final _MapData data;

  const _GoogleMapContent({required this.data});

  @override
  State<_GoogleMapContent> createState() => _GoogleMapContentState();
}

class _GoogleMapContentState extends State<_GoogleMapContent> {
  late final Completer<GoogleMapController> _mapController;
  late LatLng _currentPosition;
  Marker? _selectedMarker;
  StreamSubscription<LocationData>? _locSub;

  @override
  void initState() {
    super.initState();
    _mapController = Completer();
    _currentPosition = widget.data.currentPosition ?? widget.data.initialFocus;
    _listenLocation();
  }

  Future<void> _listenLocation() async {
    if (!await widget.data.location.serviceEnabled()) {
      if (!await widget.data.location.requestService()) return;
    }

    if (await widget.data.location.hasPermission() == PermissionStatus.denied) {
      if (await widget.data.location.requestPermission() !=
          PermissionStatus.granted) return;
    }

    _locSub = widget.data.location.onLocationChanged.listen((loc) {
      if (!mounted) return;

      if (loc.latitude != null && loc.longitude != null) {
        setState(() {
          _currentPosition = LatLng(loc.latitude!, loc.longitude!);
        });
      }
    });
  }

  Future<void> _moveCamera(LatLng pos) async {
    final c = await _mapController.future;
    await c.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.data.initialFocus,
        zoom: 11,
      ),
      onMapCreated: (controller) async {
        if (!_mapController.isCompleted) {
          _mapController.complete(controller);
        }
        await _moveCamera(widget.data.initialFocus);
      },
      markers: {
        if (widget.data.currentPosition != null)
          Marker(
            markerId: const MarkerId('current'),
            position: _currentPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        if (_selectedMarker != null) _selectedMarker!,
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onTap: (latLng) {
        setState(() {
          _selectedMarker = Marker(
            markerId: const MarkerId('selected'),
            position: latLng,
          );
        });

        widget.data.riderController.setPickupLocation(
          latLng.latitude,
          latLng.longitude,
        );

        debugPrint(
          '📍 Pickup set: ${latLng.latitude}, ${latLng.longitude}',
        );
      },
    );
  }

  @override
  void dispose() {
    _locSub?.cancel();
    super.dispose();
  }
}
