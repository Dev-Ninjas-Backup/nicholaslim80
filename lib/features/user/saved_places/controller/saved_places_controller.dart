import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../model/place_model.dart';
import '../service/saved_places_service.dart';

class SavedPlaceController extends GetxController {
  final SavedPlacesService service = SavedPlacesService();

  final RxList<PlaceModel> savedPlaces = <PlaceModel>[].obs;
  final RxString selectedAddress = ''.obs;
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

  void selectAddress(String address) {
    selectedAddress.value = address;
  }

  Future<bool> savePlace(String name) async {
    if (selectedAddress.value.isEmpty) {
      EasyLoading.showError('Address not selected');
      return false;
    }

    try {
      isLoading.value = true;

      await service.addPlace(name: name, address: selectedAddress.value);

      EasyLoading.showSuccess('Place saved successfully');

      selectedAddress.value = '';

      fetchPlaces();

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
