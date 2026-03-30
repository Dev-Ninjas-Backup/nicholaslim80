import 'dart:async';

import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/google_map/service/one_map_service.dart';
import 'package:ZipBee/features/user/google_map/service/service_zone_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

enum GoogleMapWidgetMode { display, addressPicker }

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    super.key,
    this.mode = GoogleMapWidgetMode.display,
    this.initialQuery,
    this.onLocationConfirmed,
  });

  final GoogleMapWidgetMode mode;
  final String? initialQuery;
  final ValueChanged<OneMapResolvedAddress>? onLocationConfirmed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MapData>(
      future: initializeMap(
        enablePickupSync: mode == GoogleMapWidgetMode.display,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return GoogleMapContent(
          data: snapshot.data!,
          mode: mode,
          initialQuery: initialQuery,
          onLocationConfirmed: onLocationConfirmed,
        );
      },
    );
  }

  static Future<MapData> initializeMap({required bool enablePickupSync}) async {
    final location = Location();
    final riderController = enablePickupSync
        ? (Get.isRegistered<RiderController>()
              ? Get.find<RiderController>()
              : Get.put(RiderController()))
        : null;

    final zoneCenter = await ServiceZoneService.getFirstZoneCenter();
    final initialFocus = zoneCenter ?? const LatLng(1.3521, 103.8198);

    LatLng? currentPosition;
    try {
      final serviceEnabled = await location.serviceEnabled();
      final permission = await location.hasPermission();
      if (serviceEnabled && permission != PermissionStatus.denied) {
        final locData = await location.getLocation();
        if (locData.latitude != null && locData.longitude != null) {
          currentPosition = LatLng(locData.latitude!, locData.longitude!);
        }
      }
    } catch (_) {}

    return MapData(
      riderController: riderController,
      initialFocus: initialFocus,
      currentPosition: currentPosition,
      location: location,
    );
  }
}

class MapData {
  final RiderController? riderController;
  final LatLng initialFocus;
  final LatLng? currentPosition;
  final Location location;

  const MapData({
    required this.riderController,
    required this.initialFocus,
    this.currentPosition,
    required this.location,
  });
}

class GoogleMapContent extends StatefulWidget {
  const GoogleMapContent({
    super.key,
    required this.data,
    required this.mode,
    this.initialQuery,
    this.onLocationConfirmed,
  });

  final MapData data;
  final GoogleMapWidgetMode mode;
  final String? initialQuery;
  final ValueChanged<OneMapResolvedAddress>? onLocationConfirmed;

  @override
  State<GoogleMapContent> createState() => GoogleMapContentState();
}

class GoogleMapContentState extends State<GoogleMapContent> {
  final Completer<GoogleMapController> mapController = Completer();
  late final TextEditingController searchController;

  final List<OneMapAddressSuggestion> suggestions = [];

  StreamSubscription<LocationData>? locSub;
  Timer? debounce;

  late LatLng currentPosition;
  Marker? selectedMarker;
  OneMapResolvedAddress? pendingSelection;

  bool hasDeviceLocation = false;
  bool isSearching = false;
  bool showSuggestions = false;
  bool didRunInitialQuery = false;
  bool isMutatingSearchField = false;

  String? helperMessage;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery ?? '');
    currentPosition = widget.data.currentPosition ?? widget.data.initialFocus;
    hasDeviceLocation = widget.data.currentPosition != null;
    listenLocation();
  }

  @override
  void didUpdateWidget(covariant GoogleMapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery &&
        (widget.initialQuery?.isNotEmpty ?? false) &&
        searchController.text.trim().isEmpty) {
      _setSearchField(widget.initialQuery!);
    }
  }

  Future<void> listenLocation() async {
    if (!await widget.data.location.serviceEnabled()) {
      final enabled = await widget.data.location.requestService();
      if (!enabled) return;
    }

    final permission = await widget.data.location.hasPermission();
    if (permission == PermissionStatus.denied) {
      final requested = await widget.data.location.requestPermission();
      if (requested != PermissionStatus.granted &&
          requested != PermissionStatus.grantedLimited) {
        return;
      }
    }

    locSub = widget.data.location.onLocationChanged.listen((loc) {
      if (!mounted || loc.latitude == null || loc.longitude == null) return;

      setState(() {
        hasDeviceLocation = true;
        currentPosition = LatLng(loc.latitude!, loc.longitude!);
      });
    });
  }

  Future<void> moveCamera(LatLng position, {double zoom = 16}) async {
    final controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );
  }

  void dropPin(LatLng position) {
    setState(() {
      selectedMarker = Marker(
        markerId: const MarkerId('selected'),
        position: position,
      );
    });
  }

  Future<void> handleMapTap(LatLng latLng) async {
    dropPin(latLng);

    if (widget.mode == GoogleMapWidgetMode.display) {
      widget.data.riderController?.setPickupLocation(
        latLng.latitude,
        latLng.longitude,
      );
      return;
    }

    await _resolveFromTap(latLng);
  }

  Future<void> _resolveFromTap(LatLng latLng) async {
    setState(() {
      isSearching = true;
      helperMessage = null;
      showSuggestions = false;
    });

    final resolved = await OneMapService.reverseGeocode(
      latLng.latitude,
      latLng.longitude,
    );

    if (!mounted) return;

    setState(() {
      isSearching = false;
      if (resolved == null) {
        pendingSelection = null;
        helperMessage = "Couldn't detect address here. Try clicking nearby.";
        return;
      }

      pendingSelection = resolved;
      helperMessage = null;
      _setSearchField(
        resolved.postalCode.isNotEmpty ? resolved.postalCode : resolved.address,
      );
    });

    await moveCamera(latLng);
  }

  Future<void> _runSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 3) return;

    setState(() {
      isSearching = true;
      helperMessage = null;
      showSuggestions = false;
      suggestions.clear();
    });

    final currentQuery = trimmed;
    final results = await OneMapService.searchSuggestions(trimmed);

    if (!mounted || searchController.text.trim() != currentQuery) {
      return;
    }

    if (results.isEmpty) {
      setState(() {
        isSearching = false;
        pendingSelection = null;
        helperMessage =
            'No location found. Try a building name, road, or postal code.';
      });
      return;
    }

    setState(() {
      isSearching = false;
      helperMessage = null;
      suggestions
        ..clear()
        ..addAll(results);
      showSuggestions = true;
    });

    await _selectSuggestion(results.first, updateSearchField: false);
  }

  Future<void> _selectSuggestion(
    OneMapAddressSuggestion suggestion, {
    bool updateSearchField = true,
  }) async {
    final resolved = suggestion.toResolvedAddress();
    final target = LatLng(suggestion.lat, suggestion.lng);

    setState(() {
      pendingSelection = resolved;
      helperMessage = null;
      if (updateSearchField) {
        _setSearchField(suggestion.postalCode);
      }
      selectedMarker = Marker(
        markerId: const MarkerId('selected'),
        position: target,
      );
    });

    await moveCamera(target, zoom: 17);
  }

  void _setSearchField(String value) {
    isMutatingSearchField = true;
    searchController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
    isMutatingSearchField = false;
  }

  void _handleSearchInputChanged(String value) {
    if (isMutatingSearchField) return;

    debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() {
        showSuggestions = false;
        suggestions.clear();
        helperMessage = null;
      });
      return;
    }

    debounce = Timer(
      const Duration(milliseconds: 700),
      () => _runSearch(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == GoogleMapWidgetMode.addressPicker &&
        !didRunInitialQuery &&
        (widget.initialQuery?.trim().length ?? 0) >= 3) {
      didRunInitialQuery = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _runSearch(widget.initialQuery!.trim());
        }
      });
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.data.currentPosition ?? widget.data.initialFocus,
            zoom: widget.mode == GoogleMapWidgetMode.addressPicker ? 13 : 11,
          ),
          onMapCreated: (controller) async {
            if (!mapController.isCompleted) {
              mapController.complete(controller);
            }
            await moveCamera(
              widget.data.currentPosition ?? widget.data.initialFocus,
              zoom: widget.mode == GoogleMapWidgetMode.addressPicker ? 13 : 11,
            );
          },
          myLocationEnabled: hasDeviceLocation,
          myLocationButtonEnabled: true,
          onTap: handleMapTap,
          markers: {
            if (hasDeviceLocation)
              Marker(
                markerId: const MarkerId('current'),
                position: currentPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            if (selectedMarker != null) selectedMarker!,
          },
        ),
        if (widget.mode == GoogleMapWidgetMode.addressPicker) ...[
          _buildSearchOverlay(),
          if (showSuggestions && suggestions.isNotEmpty)
            _buildSuggestionsOverlay(),
          if (isSearching) _buildLoadingOverlay(),
          _buildBottomSelectionCard(),
        ],
      ],
    );
  }

  Widget _buildSearchOverlay() {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Column(
        children: [
          Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: TextField(
              controller: searchController,
              onChanged: _handleSearchInputChanged,
              onSubmitted: _runSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search postal code, building, or road',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.my_location_outlined),
                        onPressed: hasDeviceLocation
                            ? () => moveCamera(currentPosition, zoom: 16)
                            : null,
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
          if (helperMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                helperMessage!,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      helperMessage!.startsWith('No') ||
                          helperMessage!.startsWith("Couldn't")
                      ? Colors.red.shade600
                      : Colors.grey.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      top: 74,
      left: 12,
      right: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              final isSelected =
                  pendingSelection?.postalCode == suggestion.postalCode &&
                  pendingSelection?.address == suggestion.label;

              return ListTile(
                dense: true,
                leading: Icon(
                  Icons.location_on_outlined,
                  color: isSelected ? Colors.amber.shade700 : Colors.grey,
                ),
                title: Text(
                  suggestion.building.isNotEmpty
                      ? suggestion.building
                      : suggestion.road,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  suggestion.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 18,
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () async {
                  setState(() {
                    showSuggestions = false;
                  });
                  await _selectSuggestion(suggestion);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text('Finding address...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSelectionCard() {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.97),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: pendingSelection == null
              ? Row(
                  children: [
                    Icon(Icons.place_outlined, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Search or tap the map to select a location.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected Address',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pendingSelection!.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Postal Code: ${pendingSelection!.postalCode.isEmpty ? 'N/A' : pendingSelection!.postalCode}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: widget.onLocationConfirmed == null
                          ? null
                          : () =>
                                widget.onLocationConfirmed!(pendingSelection!),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Use',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debounce?.cancel();
    locSub?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
