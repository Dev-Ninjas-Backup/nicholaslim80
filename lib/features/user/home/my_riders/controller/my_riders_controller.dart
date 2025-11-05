import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';

class MyRidersController extends GetxController {
  // Sample riders list
  var ridersList = <Map<String, String>>[].obs;

  // Map to hold love/favorite state
  var loveState = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    ridersList.addAll([
      {
        'name': 'Dylan Simpson',
        'order-id': 'ID-101',
        'image': ImagePath.profile1,
      },
      {
        'name': 'Christine Jason',
        'order-id': 'ID-102',
        'image': ImagePath.profile2,
      },
      {
        'name': 'Michael Brown',
        'order-id': 'ID-103',
        'image': ImagePath.profile3,
      },
    ]);

    // Initialize loveState with false for all riders
    for (var rider in ridersList) {
      loveState[rider['name'] ?? ''] = false;
    }
  }

  // Toggle favorite
  void toggleLove(String name) {
    if (loveState.containsKey(name)) {
      loveState[name] = !loveState[name]!;
    }
  }
}
