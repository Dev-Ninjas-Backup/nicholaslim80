import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/finding_raider/screnn/finding_rider_page.dart';

import '../controller/controller.dart';

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
                  'Would you prefer to receive a confirmation call from the  assigned driver once your order is scheduled?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          wantsConfirmationCall.value =
                          true; // ট্যাপ করলেও Radio select হবে
                          Get.to(FindingRiderPage());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<bool>(
                              value: true,
                              // ignore: deprecated_member_use
                              groupValue: wantsConfirmationCall.value,
                              // ignore: deprecated_member_use
                              onChanged: (value) =>
                              wantsConfirmationCall.value = value!,
                              activeColor: Colors.blue,
                            ),
                            SizedBox(width: 4), // spacing খুব ছোট
                            Text('Yes', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<bool>(
                              value: false,
                              // ignore: deprecated_member_use
                              groupValue: wantsConfirmationCall.value,
                              // ignore: deprecated_member_use
                              onChanged: (value) =>
                              wantsConfirmationCall.value = value!,
                              activeColor: Colors.blue,
                            ),
                            SizedBox(width: 4), // spacing খুব ছোট
                            Text('No', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true, // Prevent closing on outside tap
    );
  }
}
