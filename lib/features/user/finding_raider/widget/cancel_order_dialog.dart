import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<void> showCancelOrderDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: CancelOrderDialogBody(),
      );
    },
  );
}

class CancelOrderDialogBody extends StatelessWidget {
  CancelOrderDialogBody({super.key});

  final RxString selectedReason = "".obs;
  final TextEditingController otherController = TextEditingController();

  Widget reasonButton(String text) {
    return Obx(() {
      final bool isSelected = selectedReason.value == text;
      return GestureDetector(
        onTap: () => selectedReason.value = text,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                // ignore: deprecated_member_use
                ? Colors.black.withOpacity(0.05)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.black,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you sure you want to cancel?",
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryFontColor,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                "You may have to start all over again.",
                style: getTextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),

            reasonButton("Changed my mind"),
            SizedBox(height: 12),
            reasonButton("Too expensive for me"),
            SizedBox(height: 12),
            reasonButton("Ordered by mistake"),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Other",
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: otherController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Please Specify",
                  hintStyle: getTextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  side: BorderSide(color: Colors.red),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cancel order',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 3),
                    Image.asset(IconPath.cencell, height: 14, width: 14),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "No, do not want to cancel the order",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
