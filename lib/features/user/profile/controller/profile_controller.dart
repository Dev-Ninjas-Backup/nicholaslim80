import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  var profileItem = [].obs;
  @override
  void onInit() {
    profileItem.addAll([
      ProfileModel(title: "Name", subtitle: "Daniel Tan"),

      ProfileModel(title: "Phone number", subtitle: "+65 9977 6666"),

      ProfileModel(title: "Email address", subtitle: "daniel.tan@gmail.com"),
    ]);
    super.onInit();
  }
}
