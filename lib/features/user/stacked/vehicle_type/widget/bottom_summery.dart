import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/additional_controller.dart';
import '../controller/controller.dart';

class StackedBottomSummary extends StatelessWidget {
  final StackedVehicleController vehicleController;
  final List<String> couriers;

  const StackedBottomSummary({
    super.key,
    required this.vehicleController,
    required this.couriers,
  });

  @override
  Widget build(BuildContext context) {
    final additionalServiceController = Get.find<AdditionalServiceController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 70),
        padding: EdgeInsets.all(5),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_drop_up, size: 32),
              onPressed: () {
                openHistoryPopup(context, additionalServiceController);
              },
            ),
            SizedBox(width: 8),
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
                  Obx(() {
                    // Calculate total: vehicle cost + additional services
                    double vehicleTotal = vehicleController.calculateTotal();
                    double additionalServicesTotal = additionalServiceController
                        .getSelectedServicesTotal();
                    double subtotal = vehicleTotal + additionalServicesTotal;

                    // Prefer server total_fee, then server totalAmount, otherwise local calculation
                    try {
                      final oc = Get.find<StackedOrderController>();
                      final amountToShow = oc.totalFee.value > 0
                          ? oc.totalFee.value
                          : (oc.totalAmount.value > 0
                                ? oc.totalAmount.value
                                : subtotal);

                      return Text(
                        '\$${amountToShow.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    } catch (_) {
                      return Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
            Obx(
              () => FilledButton(
                onPressed: vehicleController.selectedVehicle.value != null
                    ? () {
                        // Pass server totals if available
                        double amountToPass = vehicleController
                            .calculateTotal();
                        try {
                          final oc = Get.find<StackedOrderController>();
                          amountToPass = oc.totalFee.value > 0
                              ? oc.totalFee.value
                              : (oc.totalAmount.value > 0
                                    ? oc.totalAmount.value
                                    : amountToPass);
                        } catch (_) {}

                        Get.toNamed(
                          AppRoutes.getstackedScreen(),
                          arguments: {'totalAmount': amountToPass},
                        );
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) => vehicleController.selectedVehicle.value != null
                        ? Colors.amber
                        : Colors.grey.shade400,
                  ),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                child: Text(
                  'Review Order',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void openHistoryPopup(
    BuildContext context,
    AdditionalServiceController additionalServiceController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                "Cost Breakdown",
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Vehicle cost section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vehicle & Delivery",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: vehicleController.calculationHistory.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              vehicleController.calculationHistory[index],
                              style: getTextStyle(fontSize: 12),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Additional services section
              Obx(() {
                if (additionalServiceController.selectedServiceIds.isEmpty) {
                  return SizedBox.shrink();
                }

                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.amber.shade50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Additional Services",
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...additionalServiceController.selectedServiceIds.map((
                        serviceId,
                      ) {
                        final service = additionalServiceController.services
                            .firstWhereOrNull((s) => s.id == serviceId);
                        if (service == null) return SizedBox.shrink();

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                service.serviceName,
                                style: getTextStyle(fontSize: 12),
                              ),
                              Text(
                                'S\$${service.value}',
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),

              Divider(height: 24),

              // Total breakdown
              Obx(() {
                double vehicleTotal = vehicleController.calculateTotal();
                double additionalServicesTotal = additionalServiceController
                    .getSelectedServicesTotal();
                double subtotal = vehicleTotal + additionalServicesTotal;
                double gst = subtotal * 0.08; // 8% GST
                double finalTotal = subtotal + gst;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal:",
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$${subtotal.toStringAsFixed(2)}",
                          style: getTextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GST (8%):",
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$${gst.toStringAsFixed(2)}",
                          style: getTextStyle(
                            fontSize: 13,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total (incl. GST):",
                            style: getTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${finalTotal.toStringAsFixed(2)}",
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
