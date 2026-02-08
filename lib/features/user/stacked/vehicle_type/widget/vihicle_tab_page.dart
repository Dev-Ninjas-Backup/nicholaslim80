import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/widget/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../order_stacked_delivery/controller/stacked_order_controller.dart';
import '../controller/additional_controller.dart';
import '../controller/controller.dart';
import 'bottom_summery.dart';

class StackedVehicleTabPage extends StatelessWidget {
  final String vehicleType;

  const StackedVehicleTabPage({super.key, required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    final vehicleController = Get.put(StackedVehicleController());
    final serviceController = Get.put(AdditionalServiceController());
    final orderController = Get.put(StackedOrderController());

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// VEHICLES
                Obx(() {
                  final vehicles = vehicleController.getVehiclesForType(
                    vehicleType,
                  );

                  return Column(
                    children: vehicles
                        .map(
                          (v) => StackedVehicleCard(
                            vehicle: v,
                            isSelected:
                                vehicleController.selectedVehicle.value == v,
                            onTap: () => vehicleController.selectVehicle(v),
                          ),
                        )
                        .toList(),
                  );
                }),

                const SizedBox(height: 20),

                /// ADDITIONAL SERVICES
                Obx(() {
                  final orderId = orderController.lastOrderId?.toString();
                  if (orderId == null) return const SizedBox.shrink();

                  final services = serviceController.services;

                  return Column(
                    children: services.map((service) {
                      final selected = serviceController.isServiceSelected(
                        service.id,
                      );

                      return GestureDetector(
                        onTap: () async {
                          await serviceController.toggleService(
                            service.id,
                            orderId,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.onboardingIndicatorNotActive,
                            border: Border.all(
                              color: selected
                                  ? AppColors.primaryButtonColor
                                  : AppColors.backgroungColor,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(service.serviceName),
                              Text("S\$${service.value}"),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),

        /// BOTTOM SUMMARY
        StackedBottomSummary(
          vehicleController: vehicleController,
          couriers: [],
        ),
      ],
    );
  }
}
