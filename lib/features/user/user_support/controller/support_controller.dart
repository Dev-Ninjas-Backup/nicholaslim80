import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/user_support/chat_screen/screen/support_chat_screen.dart';
import 'package:ZipBee/features/user/user_support/model/support_option_model.dart';
import 'package:get/get.dart';


class SupportController extends GetxController {
  final options = <SupportOption>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSupportOptions();
  }

  void loadSupportOptions() {
    options.assignAll([
      SupportOption(
        title: 'Chat with us',
        description:
            'Get help with orders or account related issue, available 24/7',
        icon: IconPath.send,
        onTap: () {
          Get.to(ChatScreen());
        },
      ),
      SupportOption(
        title: 'Call us',
        description:
            'Get help with orders or account related issue, available Mon–Fri 9am to 6pm',
        icon: IconPath.call,
        onTap: () => Get.snackbar('Call', 'Dialing support number...'),
      ),
      SupportOption(
        title: 'Send us an email',
        description:
            'Get help with orders or account related issue, available 24/7',
        icon: IconPath.email,
        onTap: () => Get.snackbar('Email', 'Opening email client...'),
      ),
      SupportOption(
        title: 'FAQ',
        description: 'Get quick help from our frequently asked question',
        icon: IconPath.faq,
        onTap: () => Get.snackbar('FAQ', 'Opening FAQ page...'),
      ),
    ]);
  }
}
