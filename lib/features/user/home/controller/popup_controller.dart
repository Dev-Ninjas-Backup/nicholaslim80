import 'dart:math';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/service/dashboard_popup_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupController extends GetxController {
  static bool _hasShownPopupThisSession = false;

  Future<void> checkAndShowPopup(BuildContext context) async {
    if (_hasShownPopupThisSession || Get.isDialogOpen == true) return;

    final response = await DashboardPopupService.fetchPopups();
    if (response['success'] == true && response['data'] != null) {
      List activePopups = (response['data'] as List)
          .where((p) => p['isActive'] == true)
          .toList();
      if (activePopups.isNotEmpty) {
        final selectedPopup =
            activePopups[Random().nextInt(activePopups.length)];
        _hasShownPopupThisSession = true;
        _showPopupDialog(context, selectedPopup);
      }
    }
  }

  void _showPopupDialog(BuildContext context, Map<String, dynamic> data) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD700), width: 1),
          ),
          child: GestureDetector(
            onTap: () => _launchURL(data['redirect_link']),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Description Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            data['title'] ?? "Always here for you!",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description
                          GestureDetector(
                            onTap: () => _launchURL(data['redirect_link']),
                            child: Text(
                              data['desc'] ??
                                  "600k points to share! Click here to register now!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withAlpha(60),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Image Section
                    SizedBox(
                      width: 70,
                      height: 70,
                      child:
                          data['image_link'] != null &&
                              data['image_link'].toString().isNotEmpty
                          ? Image.network(
                              data['image_link'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    IconPath.gift_Ad,
                                    fit: BoxFit.contain,
                                  ),
                            )
                          : Image.asset(IconPath.gift_Ad, fit: BoxFit.contain),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // close button
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Color.fromARGB(255, 216, 213, 213),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('❌ Could not launch $url');
    }
  }
}
