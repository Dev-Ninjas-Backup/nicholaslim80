import 'package:ZipBee/features/user/google_map/service/one_map_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../model/place_model.dart';
import '../service/saved_places_service.dart';

class SavedPlaceController extends GetxController {
  final SavedPlacesService service = SavedPlacesService();

  final RxList<PlaceModel> savedPlaces = <PlaceModel>[].obs;
  final RxString selectedAddress = ''.obs;
  final RxString selectedPostalCode = ''.obs;
  final RxDouble selectedLatitude = 0.0.obs;
  final RxDouble selectedLongitude = 0.0.obs;
  final RxString selectedType = 'SENDER'.obs;
  final RxInt editingPlaceId = 0.obs;
  final RxString editingPlaceName = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchPlaces();
    super.onInit();
  }

  Future<void> fetchPlaces() async {
    try {
      isLoading.value = true;
      print('DEBUG SavedPlaceController.fetchPlaces -> called');
      final data = await service.getPlaces();
      print(
        'DEBUG SavedPlaceController.fetchPlaces -> fetched ${data.length} items',
      );
      savedPlaces.assignAll(data);
    } catch (e, st) {
      print('DEBUG SavedPlaceController.fetchPlaces -> error: $e');
      print(st);
      EasyLoading.showError('Could not load saved places: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool get isEditing => editingPlaceId.value != 0;

  void selectLocation(
    OneMapResolvedAddress location, {
    String type = 'SENDER',
  }) {
    selectedAddress.value = location.address;
    selectedPostalCode.value = location.postalCode;
    selectedLatitude.value = location.lat;
    selectedLongitude.value = location.lng;
    selectedType.value = type;
  }

  void startEditing(PlaceModel place) {
    editingPlaceId.value = place.id;
    editingPlaceName.value = place.name;
    selectedAddress.value = place.address;
    selectedPostalCode.value = place.postalCode;
    selectedLatitude.value = place.latitude;
    selectedLongitude.value = place.longitude;
    selectedType.value = place.type.isEmpty ? 'SENDER' : place.type;
  }

  void clearSelectedPlace() {
    selectedAddress.value = '';
    selectedPostalCode.value = '';
    selectedLatitude.value = 0.0;
    selectedLongitude.value = 0.0;
    selectedType.value = 'SENDER';
    editingPlaceId.value = 0;
    editingPlaceName.value = '';
  }

  Future<bool> savePlace(String name) async {
    if (selectedAddress.value.isEmpty) {
      EasyLoading.showError('Address not selected');
      return false;
    }

    if (selectedPostalCode.value.isEmpty) {
      EasyLoading.showError('Postal code not selected');
      return false;
    }

    try {
      isLoading.value = true;

      if (isEditing) {
        await service.updatePlace(
          id: editingPlaceId.value,
          name: name,
          address: selectedAddress.value,
          postalCode: selectedPostalCode.value,
          latitude: selectedLatitude.value,
          longitude: selectedLongitude.value,
          type: selectedType.value,
        );
      } else {
        await service.addPlace(
          name: name,
          address: selectedAddress.value,
          postalCode: selectedPostalCode.value,
          latitude: selectedLatitude.value,
          longitude: selectedLongitude.value,
          type: selectedType.value,
        );
      }

      EasyLoading.showSuccess(
        isEditing ? 'Place updated successfully' : 'Place saved successfully',
      );

      clearSelectedPlace();
      await fetchPlaces();

      return true;
    } catch (e) {
      EasyLoading.showError('Unable to save place');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removePlace(int id) async {
    try {
      await service.deletePlace(id);
      savedPlaces.removeWhere((e) => e.id == id);

      EasyLoading.showSuccess('Place removed');
    } catch (e) {
      EasyLoading.showError('Unable to delete place');
    }
  }
}
