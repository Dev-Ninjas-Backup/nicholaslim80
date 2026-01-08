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
            const SizedBox(height: 12),
            Text("Orders", style: getTextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            /// Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            controller.fetchOrders(isRefresh: true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryButtonColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
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

            const SizedBox(height: 16),

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
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.subtitleFontColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.date,
                            style: getTextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Divider(height: 20),

                          Text(item.pickupAddress, style: getTextStyle()),
                          const SizedBox(height: 8),

                          Text(item.dropOffAddress, style: getTextStyle()),
                          const SizedBox(height: 12),

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
