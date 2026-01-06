import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';

class DeleteRiderDialog extends StatelessWidget {
  final String riderName;
  final VoidCallback? onConfirm; // ✅ add onConfirm

  const DeleteRiderDialog({
    super.key,
    required this.riderName,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Rider',
        style: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to delete $riderName?',
        style: getTextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false), // Cancel
          child: Text(
            'Cancel',
            style: getTextStyle(
              fontSize: 14,
              color: AppColors.primaryButtonColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButtonColor,
          ),
          onPressed: () {
            if (onConfirm != null) onConfirm!(); // ✅ Call callback
          },
          child: Text(
            'Delete',
            style: getTextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
