import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/finding_raider/model/payment_option_model.dart';
import '../controller/rider_controller.dart';

class PaymentOptionWidget extends StatelessWidget {
  final int index;
  final PaymentOptionModel option;

  PaymentOptionWidget({super.key, required this.index, required this.option});

  final RiderController controller = Get.find<RiderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedMethod.value == index;

      return GestureDetector(
        onTap: () => controller.selectMethod(index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          color: Colors.white,
          child: Row(
            children: [
              if (option.assetPath != null)
                Image.asset(option.assetPath!, width: 30, height: 30)
              else if (option.icon != null)
                Icon(option.icon, size: 30, color: Colors.black),

              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Right circle indicator
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? Colors.amberAccent : Colors.grey,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
