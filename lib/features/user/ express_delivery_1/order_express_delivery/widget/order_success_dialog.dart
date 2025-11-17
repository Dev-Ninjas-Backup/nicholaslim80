import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/controller/order_controller.dart';

class OrderSuccessDialog {
  static final OrderController controller = Get.find<OrderController>();
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
                      Expanded(
                        child: GestureDetector(
                          child: ListTile(
                            leading: Radio<bool>(
                              value: true,
                              groupValue: wantsConfirmationCall.value,
                              onChanged: (value) =>
                                  wantsConfirmationCall.value = value!,
                              activeColor: Colors.blue,
                            ),
                            title: const Text(
                              'Yes',
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () => wantsConfirmationCall.value = true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: ListTile(
                            leading: Radio<bool>(
                              value: false,
                              groupValue: wantsConfirmationCall.value,
                              onChanged: (value) =>
                                  wantsConfirmationCall.value = value!,
                              activeColor: Colors.blue,
                            ),
                            title: const Text(
                              'No',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
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
