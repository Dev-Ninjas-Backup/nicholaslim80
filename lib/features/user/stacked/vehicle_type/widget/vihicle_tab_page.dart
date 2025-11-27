import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/stacked/vehicle_type/widget/vehicle_card.dart';

import '../controller/controller.dart';
import 'additional_service.dart';
import 'bottom_summery.dart';

class StackedVehicleTabPage extends StatelessWidget {
  final String vehicleType;

  const StackedVehicleTabPage({super.key, required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    // Use the main controller instance shared with StackedScreen
    final StackedVehicleController controller = Get.put(StackedVehicleController());

    return Column(
      children: [
        // Flexible scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please select available vehicle',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // Vehicles list
                Obx(() {
                  final vehicles = controller.getVehiclesForType(vehicleType);
                  final selectedVehicle = controller.selectedVehicle.value;
                  return Column(
                    children: vehicles
                        .map(
                          (vehicle) => Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: StackedVehicleCard(
                          vehicle: vehicle,
                          isSelected: selectedVehicle?.name == vehicle.name,
                          onTap: () => controller.selectVehicle(vehicle),
                        ),
                      ),
                    )
                        .toList(),
                  );
                }),

                // Additional services list
                Obx(() {
                  final selectedVehicle = controller.selectedVehicle.value;
                  if (selectedVehicle == null) return SizedBox.shrink();
                  final services = controller.getAdditionalServicesForType(
                    selectedVehicle.type,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (services.isNotEmpty) ...[
                        SizedBox(height: 20),
                        Text(
                          'Additional Services',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...services.map(
                              (service) => Padding(
                            padding: EdgeInsets.only(bottom: 14),
                            child: StackedAdditionalServiceCard(
                              service: service,
                              isSelected: controller.selectedServices.contains(
                                service,
                              ),
                              onTap: () => controller.toggleService(service),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ),

        // Fixed BottomSummary (not inside scroll)
        StackedBottomSummary(vehicleController: controller, couriers: []),
      ],
    );
  }
}
