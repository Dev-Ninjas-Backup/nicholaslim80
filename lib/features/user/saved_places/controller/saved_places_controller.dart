import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/saved_places/model/place_model.dart';

class SavedPlaceController extends GetxController {
  final RxList<PlaceModel> savedPlaces = <PlaceModel>[
    PlaceModel(
      name: 'Compass Apartment',
      address: '50 Balestier Road, Singapore 330873',
    ),
    PlaceModel(
      name: 'Cousin -Jane Poh',
      address: '625 Sengkang Ave 6 # 10-10 Singapore 530625',
    ),
  ].obs;

  // Temporary storage for flow
  final RxString selectedAddress = ''.obs;

  void selectAddress(String address) {
    selectedAddress.value = address;
  }

  void addNewPlace(String name) {
    if (selectedAddress.value.isNotEmpty && name.isNotEmpty) {
      savedPlaces.add(PlaceModel(name: name, address: selectedAddress.value));
      selectedAddress.value = '';
    }
  }
}
