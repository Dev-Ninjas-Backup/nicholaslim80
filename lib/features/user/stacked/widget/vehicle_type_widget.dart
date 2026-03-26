import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/vehicle_type/screen/screen.dart';
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
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            vehicle.iconPath,
                            fit: BoxFit.cover,
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.18,
                          ),
                        ),
                        Text(
                          vehicle.vehicleType,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
