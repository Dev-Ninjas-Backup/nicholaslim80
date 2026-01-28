import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/finding_rider_page.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/notify_rider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../controller/stacked_order_controller.dart';

class StackedOrderSuccessDialog {
  static final StackedOrderController controller = Get.find<StackedOrderController>();
  static final RxBool wantsConfirmationCall = true.obs;

  static void show() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    'Your order ${controller.orderNumber.value} is confirmed!',
                    style: getTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 24),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF789F56),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                SizedBox(height: 24),

                Text(
                  'There is confirmation call from the assigned driver once your order is scheduled. \nThanks.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // Show UI based on collect_time and isAutoConfirmation
                Obx(
                  () {
                    final isAsap = controller.collectTime.value == 'ASAP';
                    final isAuto = controller.isAutoConfirmation.value;
                    
                    // If ASAP or auto confirmation: show progress bar (no buttons, auto navigate)
                    if (isAsap || isAuto) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              minHeight: 50,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // SCHEDULED: show Yes/No buttons
                      return Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                wantsConfirmationCall.value = true;
                                await _handleConfirmation(true);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: wantsConfirmationCall.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        wantsConfirmationCall.value = value;
                                      }
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  SizedBox(width: 4),
                                  Text('Yes', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                wantsConfirmationCall.value = false;
                                await _handleConfirmation(false);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: wantsConfirmationCall.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        wantsConfirmationCall.value = value;
                                      }
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  SizedBox(width: 4),
                                  Text('No', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing on outside tap
    );

    // Auto navigate if ASAP or auto confirmation (no API call needed)
    if (controller.isAutoConfirmation.value || controller.collectTime.value == 'ASAP') {
      Future.delayed(Duration(seconds: 3), () {
        Get.back(); // Close dialog
        Get.to(() => FindingRiderPage());
      });
    }
  }

  static Future<void> _handleConfirmation(bool wantsCall) async {
    try {
      final orderId = controller.lastOrderId?.toString();
      if (orderId == null) {
        EasyLoading.showError('Order ID not found');
        return;
      }

      EasyLoading.show(status: 'Processing...');

      final res = await NotifyRider.notifyRider(
        orderId: orderId,
        notifyRider: wantsCall,
      );

      EasyLoading.dismiss();

      final success = res['success'] as bool? ?? false;
      if (success) {
        debugPrint('✅ Rider notification sent: $wantsCall');
        Get.back(); // Close dialog
        Get.to(() => FindingRiderPage());
      } else {
        EasyLoading.showError('Failed to process your response');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Error in _handleConfirmation: $e');
      EasyLoading.showError('An error occurred');
    }
  }
}
