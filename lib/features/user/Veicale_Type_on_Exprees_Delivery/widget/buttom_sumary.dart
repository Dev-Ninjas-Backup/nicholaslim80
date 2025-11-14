import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class BottomSummaryController extends GetxController {
  RxBool isExpanded = false.obs; // dropdown state
  RxSet<String> selectedCouriers = <String>{}.obs; // selected couriers
}

class BottomSummary extends StatelessWidget {
  final double total;
  final List<String> couriers;

  BottomSummary({
    super.key,
    required this.total,
    required this.couriers,
    required bool isButtonEnabled,
    required RxList<String> calculationHistory,
  });

  final BottomSummaryController controller = Get.put(BottomSummaryController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (controller.isExpanded.value) controller.isExpanded.value = false;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        /// Arrow icon left of total
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              controller.isExpanded.value =
                                  !controller.isExpanded.value;
                            },
                            icon: Icon(
                              controller.isExpanded.value
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        /// Total text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total (incl. GST):',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                              Text(
                                'S\$${total.toStringAsFixed(2)}',
                                style: getTextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Review Order button (dynamic color)
                        Obx(
                          () => FilledButton(
                            onPressed: controller.selectedCouriers.isNotEmpty
                                ? () {
                                    Get.toNamed(
                                      AppRoutes.getexpressSenderOrRecepment(),
                                    );
                                  }
                                : null,
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  controller.selectedCouriers.isNotEmpty
                                  ? Colors.amber
                                  : Colors.grey.shade400,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Review Order',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Dropdown section
                    Obx(
                      () => controller.isExpanded.value
                          ? Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: couriers
                                    .map(
                                      (e) => Obx(
                                        () => ListTile(
                                          onTap: () {
                                            if (controller.selectedCouriers
                                                .contains(e)) {
                                              controller.selectedCouriers
                                                  .remove(e);
                                            } else {
                                              controller.selectedCouriers.add(
                                                e,
                                              );
                                            }
                                          },
                                          leading: Icon(
                                            controller.selectedCouriers
                                                    .contains(e)
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color:
                                                controller.selectedCouriers
                                                    .contains(e)
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                          title: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
