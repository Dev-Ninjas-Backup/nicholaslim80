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
    return FutureBuilder<MapData>(
      future: initializeMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data;
        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return GoogleMapContent(data: data);
      },
    );
  }

  static Future<MapData> initializeMap() async {
    final location = Location();
    final riderController = Get.isRegistered<RiderController>()
        ? Get.find<RiderController>()
        : Get.put(RiderController());

    final zoneCenter = await ServiceZoneService.getFirstZoneCenter();
    final initialFocus = zoneCenter ?? const LatLng(1.2805125, 103.8425995);

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

    return MapData(
      riderController: riderController,
      initialFocus: initialFocus,
      currentPosition: currentPosition,
      location: location,
    );
  }
}

class MapData {
  final RiderController riderController;
  final LatLng initialFocus;
  final LatLng? currentPosition;
  final Location location;

  MapData({
    required this.riderController,
    required this.initialFocus,
    this.currentPosition,
    required this.location,
  });
}

class GoogleMapContent extends StatefulWidget {
  final MapData data;

  GoogleMapContent({required this.data});

  @override
  State<GoogleMapContent> createState() => GoogleMapContentState();
}

class GoogleMapContentState extends State<GoogleMapContent> {
  late final Completer<GoogleMapController> mapController;
  late LatLng currentPosition;
  Marker? selectedMarker;
  StreamSubscription<LocationData>? locSub;

  @override
  void initState() {
    super.initState();
    mapController = Completer();
    currentPosition = widget.data.currentPosition ?? widget.data.initialFocus;
    listenLocation();
  }

  Future<void> listenLocation() async {
    if (!await widget.data.location.serviceEnabled()) {
      if (!await widget.data.location.requestService()) return;
    }

    if (await widget.data.location.hasPermission() == PermissionStatus.denied) {
      if (await widget.data.location.requestPermission() !=
          PermissionStatus.granted)
        return;
    }

    locSub = widget.data.location.onLocationChanged.listen((loc) {
      if (!mounted) return;

      if (loc.latitude != null && loc.longitude != null) {
        setState(() {
          currentPosition = LatLng(loc.latitude!, loc.longitude!);
        });
      }
    });
  }

  Future<void> moveCamera(LatLng pos) async {
    final c = await mapController.future;
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
        if (!mapController.isCompleted) {
          mapController.complete(controller);
        }
        await moveCamera(widget.data.initialFocus);
      },
      markers: {
        if (widget.data.currentPosition != null)
          Marker(
            markerId: const MarkerId('current'),
            position: currentPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        if (selectedMarker != null) selectedMarker!,
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onTap: (latLng) {
        setState(() {
          selectedMarker = Marker(
            markerId: MarkerId('selected'),
            position: latLng,
          );
        });

        widget.data.riderController.setPickupLocation(
          latLng.latitude,
          latLng.longitude,
        );

        debugPrint('📍 Pickup set: ${latLng.latitude}, ${latLng.longitude}');
      },
    );
  }

  @override
  void dispose() {
    locSub?.cancel();
    super.dispose();
  }
}
