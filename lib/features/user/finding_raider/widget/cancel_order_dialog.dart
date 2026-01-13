import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';

Future<void> showCancelOrderDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: CancelOrderDialogBody(),
    ),
  );
}

class CancelOrderDialogBody extends StatelessWidget {
  CancelOrderDialogBody({super.key});

  final RiderController controller = Get.find<RiderController>();

  final RxString selectedReason = ''.obs;
  final RxString otherText = ''.obs;
  final TextEditingController otherController = TextEditingController();

  String getFinalReason() {
    if (selectedReason.value == 'Other') {
      return otherText.value.trim();
    }
    return selectedReason.value;
  }

  Widget reasonButton(String text) {
    return Obx(() {
      final bool isSelected = selectedReason.value == text;
      return GestureDetector(
        onTap: () => selectedReason.value = text,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black12 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure you want to cancel?",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "You may have to start all over again.",
              style: getTextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            reasonButton("Changed my mind"),
            reasonButton("Too expensive for me"),
            reasonButton("Ordered by mistake"),
            reasonButton("Other"),

            Obx(
              () => selectedReason.value == "Other"
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: otherController,
                        onChanged: (v) => otherText.value = v,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Please specify",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(height: 24),

            Obx(() {
              final bool isDisabled =
                  selectedReason.value.isEmpty ||
                  (selectedReason.value == "Other" &&
                      otherText.value.trim().isEmpty);

              return ElevatedButton(
                onPressed: isDisabled
                    ? null
                    : () {
                        controller.cancelOrder(
                          reason: getFinalReason(),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isCancelling.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Cancel order',
                            style: getTextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Image.asset(
                            IconPath.cancel,
                            height: 14,
                            width: 14,
                          ),
                        ],
                      ),
              );
            }),

            const SizedBox(height: 12),

            TextButton(
              onPressed: Get.back,
              child: const Text(
                "No, do not want to cancel the order",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
