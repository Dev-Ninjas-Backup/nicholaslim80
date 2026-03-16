import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/update_details_controller.dart';

class DeliveryTypeDialog extends StatelessWidget {
  const DeliveryTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<StackedOrderController>();
    final updateController = Get.put(UpdateDetailsController());

    final List<Map<String, String>> deliveryOptions = [
      {'type': 'EXPRESS', 'time': '1 hour', 'price': 'S\$14.00'},
      {'type': 'STANDARD', 'time': '3 hours', 'price': 'S\$10.00'},
      {'type': 'SAVER', 'time': '6 hours', 'price': 'S\$8.00'},
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pick your preferred delivery",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...deliveryOptions.map((option) {
                return Obx(() {
                  bool isSelected =
                      orderController.deliveryType.value == option['type'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryButtonColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.grey.shade300,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        option['type']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Delivery within ${option['time']}"),
                      trailing: Text(
                        option['price']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        orderController.deliveryType.value = option['type']!;
        
                        bool success = await updateController.patchDeliveryType(
                          orderController.lastOrderId!,
                          option['type']!,
                        );
        
                        if (success) {
                          Get.back();
                        } else {
                          EasyLoading.showInfo("Failed to update delivery type. Please try again");
                        }
                      },
                    ),
                  );
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
