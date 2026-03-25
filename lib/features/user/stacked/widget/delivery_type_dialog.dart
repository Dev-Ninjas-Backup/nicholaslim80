import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart'; // Import HomeController
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
    // Get delivery types from HomeController
    final homeController = Get.find<HomeController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pick your preferred delivery",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Dynamic list from HomeController
              Obx(() {
                if (homeController.isDeliveryLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (homeController.deliveryTypes.isEmpty) {
                  return const Text("No delivery options available");
                }

                return Column(
                  children: homeController.deliveryTypes.map((type) {
                    bool isSelected = orderController.deliveryType.value == type.name;
                    
                    // Logic: Multiplier to Percentage
                    // 0.75 -> 75%
                    double multiplier = double.tryParse(type.priceMultiplier ?? "0") ?? 0.0;
                    String percentage = "${(multiplier * 100).toStringAsFixed(0)}%";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryButtonColor.withOpacity(0.1) // Light highlight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.amber : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          type.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(type.formattedSubtitle),
                        trailing: Text(
                          percentage,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        onTap: () async {
                          orderController.deliveryType.value = type.name;

                          EasyLoading.show(status: 'Updating...');
                          bool success = await updateController.patchDeliveryType(
                            orderController.lastOrderId!,
                            type.id,
                          );
                          EasyLoading.dismiss();

                          if (success) {
                            Get.back();
                          } else {
                            EasyLoading.showInfo("Failed to update delivery type. Please try again");
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}