import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class ProofOfDeliveryController extends GetxController {
  final trackingNumber = "SPXSG057083664199".obs;
  final deliveredAt = "23-09-2025 13:47".obs;

  final deliveryDate = "23-September-2025".obs;
  final location = "Singapore".obs;
  final coordinates = "1.0178°N | 103.051° | 0.8028°E".obs;
  final orderId = "SPXSG057083664199 | 186651CBD4-Main-SMR".obs;

  /// Images
  final images = <String>[
    ImagePath.deliveryBox,
    ImagePath.deliveryBox,
    ImagePath.deliveryBox,
    ImagePath.deliveryBox,
  ];

  late RxString selectedImage;

  @override
  void onInit() {
    selectedImage = images.first.obs; 
    super.onInit();
  }

  void changeImage(String imagePath) {
    selectedImage.value = imagePath;
  }
}
