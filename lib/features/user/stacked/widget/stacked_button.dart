import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/screen/collect_from.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/stacked_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/controller.dart';
import '../stacked_controller/update_details_controller.dart';

class StackedButtonWidget extends StatelessWidget {
  const StackedButtonWidget({super.key, required this.controller});

  final StackedLocationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use controller.isRoundTrip.value directly where needed; avoid copying to a local variable to keep behavior dynamic

      return Column(
        children: [
          /// =================== TOP TOGGLE (ONE WAY + ROUND) ===================
          Card(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final previous = controller.isRoundTrip.value;
                      controller.toggleTripType(false); // optimistic

                      try {
                        final upd = Get.put(UpdateDetailsController());
                        final oc = Get.find<StackedOrderController>();
                        if (oc.lastOrderId != null) {
                          final ok = await upd.patchRouteType(oc.lastOrderId!, 'ONE_WAY');
                          if (!ok) controller.toggleTripType(previous);
                        }
                      } catch (e) {
                        controller.toggleTripType(previous);
                        debugPrint('patchRouteType ONE_WAY error: $e');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !controller.isRoundTrip.value
                            ? AppColors.primaryButtonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        "One way",
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final previous = controller.isRoundTrip.value;
                      controller.toggleTripType(true); // optimistic

                      try {
                        final upd = Get.put(UpdateDetailsController());
                        final oc = Get.find<StackedOrderController>();
                        if (oc.lastOrderId != null) {
                          final ok = await upd.patchRouteType(oc.lastOrderId!, 'ROUND');
                          if (!ok) controller.toggleTripType(previous);
                        }
                      } catch (e) {
                        controller.toggleTripType(previous);
                        debugPrint('patchRouteType ROUND error: $e');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isRoundTrip.value
                            ? AppColors.primaryButtonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        "Round",
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// =================== MAIN CONTAINER ===================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),

            /// =================== ROUND TRIP UI ===================
            // Use round-trip structure for both one-way and round visually
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    /// -------- FIXED ROUTE BUTTON --------
                    Obx(() {
                      final orderController = Get.put(StackedOrderController());
                      final isSelected = orderController.isFixed.value;

                      return GestureDetector(
                        onTap: () async {
                          final newVal = !isSelected;
                          // Optimistically toggle UI
                          orderController.isFixed.value = newVal;

                          try {
                            final upd = Get.put(UpdateDetailsController());
                            if (orderController.lastOrderId != null) {
                              await upd.patchIsFixed(orderController.lastOrderId!, newVal);
                            }
                          } catch (_) {
                            // revert on error
                            orderController.isFixed.value = isSelected;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.amber
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.amber : Colors.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                IconPath.exparess,
                                width: 24,
                                height: 24,
                              ),
                              Text(
                                "Fixed route",
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 16),

                /// =================== SENDER LIST (works for both round and one-way) ===================
                Obx(() {
                  final count = controller.collectedStops.isNotEmpty
                      ? controller.collectedStops.length
                      : 1;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: count,
                    itemBuilder: (context, index) {
                      final hasData =
                          controller.collectedStops.isNotEmpty &&
                          index < controller.collectedStops.length;

                      final name = hasData
                          ? controller.collectedStops[index].contactName
                          : controller.senderDisplayName;

                      final addr = hasData
                          ? controller.collectedStops[index].addressFromApr
                          : controller.senderDisplayAddress;

                      return Column(
                        children: [
                          Row(
                            children: [
                              /// NEW ICON ADDED LIKE ONEWAY
                              Image.asset(
                                IconPath.collectIcon,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Collected from (Sender: $name)',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      addr,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  Get.to(
                                    () => StackedCollectFormScreen(
                                      controller: Get.put(
                                        StackedCollectFormController(),
                                      ),
                                      addressType: 'SENDER',
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  );
                }),

                /// =================== RECEIVER LIST (works for both round and one-way) ===================
                Obx(() {
                  final count = controller.recipientStops.isNotEmpty
                      ? controller.recipientStops.length
                      : 1;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: count,
                    itemBuilder: (context, index) {
                      final hasData =
                          controller.recipientStops.isNotEmpty &&
                          index < controller.recipientStops.length;

                      final name = hasData
                          ? controller.recipientStops[index].contactName
                          : controller.receiverDisplayName;

                      final addr = hasData
                          ? controller.recipientStops[index].addressFromApr
                          : controller.receiverDisplayAddress;

                      return Column(
                        children: [
                          Row(
                            children: [
                              /// NEW ICON ADDED LIKE ONEWAY
                              Image.asset(
                                IconPath.deliveredIcon,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivered to (Recipient: $name)',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      addr,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  Get.to(
                                    () => StackedCollectFormScreen(
                                      controller: Get.put(
                                        StackedCollectFormController(),
                                      ),
                                      addressType: 'RECEIVER',
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      );
    });
  }
}
