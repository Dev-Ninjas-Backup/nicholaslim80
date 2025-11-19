import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class TipAleartDialog extends StatelessWidget {
  const TipAleartDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber, width: 2),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 300, // minimum width
          maxWidth: 400, // maximum width, change as needed
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+3 Points',
                style: getTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.amberAccent,
                ),
              ),
              SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    '',
                    '',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.amber.withOpacity(0.8),
                    colorText: Colors.white,
                    margin: EdgeInsets.all(10),
                    duration: Duration(seconds: 2),
                    titleText: SizedBox.shrink(),
                    messageText: Text(
                      '60 Points Now',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },

                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
