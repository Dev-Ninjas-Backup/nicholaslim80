import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/controller/vehicle_Controller.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/models/data_model.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/widget/additional_service_card.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/widget/buttom_sumary.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/widget/vehicale_card.dart';

class VehicleTabPage extends StatelessWidget {
  final String vehicleType;

  const VehicleTabPage({super.key, required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    final VehicleController controller = Get.put(
      VehicleController(),
      tag: vehicleType,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Obx(() {
                final vehicles = controller.getVehiclesForType(vehicleType);
                final selectedVehicle = controller.selectedVehicle.value;
                final services = selectedVehicle != null
                    ? controller.getAdditionalServicesForType(
                        selectedVehicle.type,
                      )
                    : <AdditionalService>[];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please select available vehicle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...vehicles.map(
                      (vehicle) => Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: VehicleCard(
                          vehicle: vehicle,
                          isSelected: selectedVehicle?.name == vehicle.name,
                          onTap: () => controller.selectVehicle(vehicle),
                        ),
                      ),
                    ),
                    if (services.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        'Additional Services',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...services.map(
                        (service) => Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: AdditionalServiceCard(
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
            ),
          ),
        ),

        Obx(
          () => BottomSummary(
            total: controller.calculateTotal(),
            isButtonEnabled: controller.isOrderReady,
            calculationHistory: controller.calculationHistory,
          ),
        ),
      ],
    );
  }
}
