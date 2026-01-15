import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/user_support/chat_screen/screen/support_chat_screen.dart';
import 'package:ZipBee/features/user/user_support/model/support_option_model.dart';
import 'package:ZipBee/features/user/user_support/widget/faq/faq_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Get.to(() => ChatScreen());
        },
      ),
      SupportOption(
        title: 'Call us',
        description: '+4448949894',
        icon: IconPath.call,
        onTap: () async {
          final Uri launchUri = Uri(scheme: 'tel', path: '+4448949894');
          try {
            // Explicitly use externalApplication mode for better compatibility
            if (await canLaunchUrl(launchUri)) {
              await launchUrl(launchUri, mode: LaunchMode.externalApplication);
            } else {
              // Fallback attempt
              await launchUrl(launchUri, mode: LaunchMode.externalApplication);
            }
          } catch (e) {
            EasyLoading.showError('Could not launch dialer');
          }
        },
      ),
      SupportOption(
        title: 'Send us an email',
        description: 'nicho@gmail.com',
        icon: IconPath.email,
        onTap: () async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: 'nicho@gmail.com',
            query: 'subject=Support Request&body=Hi Support Team,',
          );
          try {
            if (await canLaunchUrl(emailLaunchUri)) {
              await launchUrl(
                emailLaunchUri,
                mode: LaunchMode.externalApplication,
              );
            } else {
              // Fallback attempt
              await launchUrl(
                emailLaunchUri,
                mode: LaunchMode.externalApplication,
              );
            }
          } catch (e) {
            EasyLoading.showError('Could not launch email client');
          }
        },
      ),
      SupportOption(
        title: 'FAQ',
        description: 'Get quick help from our frequently asked question',
        icon: IconPath.faq,
        onTap: () {
          Get.to(() => const FaqScreen());
        },
      ),
    ]);
  }
}
