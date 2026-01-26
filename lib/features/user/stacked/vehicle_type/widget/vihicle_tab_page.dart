import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/widget/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controller/controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/update_details_controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
// additional services UI commented out
import 'bottom_summery.dart';

class StackedVehicleTabPage extends StatelessWidget {
  final String vehicleType;

  const StackedVehicleTabPage({super.key, required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    // Use the shared controller instance provided by parent screen
    final StackedVehicleController controller = Get.find<StackedVehicleController>();

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
                              // ensure object identity so same-title/type entries are independently selectable
                              isSelected: selectedVehicle == vehicle,
                              onTap: () async {
                                // Select locally
                                controller.selectVehicle(vehicle);

                                // If we have an existing order, update vehicle_type on server
                                try {
                                  final oc = Get.find<StackedOrderController>();
                                  if (oc.lastOrderId != null) {
                                    final upd = Get.put(UpdateDetailsController());
                                    final orderId = oc.lastOrderId!;
                                    final ok = await upd.patchVehicleType(orderId, vehicle.id!);
                                    if (!ok) {
                                      debugPrint('Failed to update vehicle type on server');
                                    }
                                  }
                                } catch (e) {
                                  debugPrint('Error patching vehicle_type: $e');
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),

                // Additional services UI commented out as API does not provide this data
                // If needed in future, the following block can be re-enabled and
                // the controller's `_allServices` may be replaced with API-provided data.
                /*
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
                */
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
