import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/order/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: Column(
          children: [
            Text("Orders", style: getTextStyle()),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryButtonColor),
                  ),
                  child: Row(
                    children: List.generate(controller.orderTabs.length, (
                      index,
                    ) {
                      final isSelected =
                          controller.selectOrderListIndex.value == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectOrderListIndex.value = index;
                            controller.fetchOrders();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? AppColors.primaryButtonColor
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              controller.orderTabs[index],
                              style: getTextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            /// Order List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.orderList.isEmpty) {
                  return const Center(child: Text("No Orders Found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.orderList.length,
                  itemBuilder: (_, index) {
                    final item = controller.orderList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroungColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.subtitleFontColor,
                          width: 0.6,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Date + Reorder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.date,
                                style: getTextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.refresh, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Re-Order",
                                    style: getTextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Divider(height: 24),

                          /// Pickup
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.radio_button_unchecked),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.pickupAddress,
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// Dropoff
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.dropOffAddress,
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// Vehicle + Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.vehicleType, style: getTextStyle()),
                              Text(
                                "S\$${item.total.toStringAsFixed(2)}",
                                style: getTextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// Delivery
                          Row(
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Delivery",
                                style: getTextStyle(
                                  color: AppColors.subtitleFontColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
