import 'package:ZipBee/features/user/stacked/vehicle_type/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../stacked_controller/stacked_controller.dart';

class StackedVehicleTypeWidget extends StatelessWidget {
  const StackedVehicleTypeWidget({super.key, required this.controller});

  final StackedLocationController controller;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.vehicleList.asMap().entries.map((entry) {
            final index = entry.key;
            final vehicle = entry.value;

            bool isSelected = controller.selectedVehicle.value == vehicle;

            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.selectVehicle(vehicle);

                    Get.to(
                      () => const StackedVehicleSelectionPage(),
                      arguments: {
                        'initialIndex': index,
                        'initialDistanceKm': 2.0,
                      },
                    );
                  },
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
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
