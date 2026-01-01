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
      final data = await service.getPlaces();
      savedPlaces.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Load Failed',
        'Could not load saved places',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(String address) {
    selectedAddress.value = address;
  }

  Future<bool> savePlace(String name) async {
    if (selectedAddress.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Address not selected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;

      await service.addPlace(name: name, address: selectedAddress.value);

      Get.snackbar(
        'Success',
        'Place saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      selectedAddress.value = '';

      fetchPlaces();

      return true;
    } catch (e) {
      Get.snackbar(
        'Save Failed',
        'Unable to save place',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removePlace(int id) async {
    try {
      await service.deletePlace(id);
      savedPlaces.removeWhere((e) => e.id == id);

      Get.snackbar(
        'Deleted',
        'Place removed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Delete Failed',
        'Unable to delete place',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
