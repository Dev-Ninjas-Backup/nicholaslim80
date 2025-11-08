import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/controller/express_controller_1.dart';

class VehicleTypeWidget extends StatelessWidget {
  const VehicleTypeWidget({super.key, required this.controller});

  final LocationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: controller.vehicleList.map((vehicle) {
            bool isSelected = controller.selectedVehicle.value == vehicle;
            return GestureDetector(
              onTap: () => controller.selectVehicle(vehicle),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Colors.amber.shade600
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    vehicle.iconPath,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 70,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
