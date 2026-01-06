import 'package:ZipBee/v/controller/vehicle_v1_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleTypeScreen extends StatelessWidget {
  // Dependency Injection of Controller
  final VehicleV1Controller controller = Get.put(VehicleV1Controller());

  // Colors
  final Color primaryYellow = const Color(0xFFFFD54F);
  final Color selectedBg = const Color(0xFFFFFDE7);
  final Color textDark = const Color(0xFF333333);
  final Color textGrey = const Color(0xFF757575);
  final Color bgCream = const Color(0xFFFFFCF2);

  VehicleTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'Vehicle Type',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Please select available vehicle",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildVehicleList(),
                  const SizedBox(height: 24),
                  const Text(
                    "Additional Services",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildServicesList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- SUB WIDGETS ---

  Widget _buildCategoryTabs() {
    List<IconData> icons = [
      Icons.two_wheeler,
      Icons.directions_car,
      Icons.airport_shuttle,
      Icons.local_shipping,
    ];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          return Obx(() {
            bool isSelected = controller.selectedCategoryIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectCategory(index),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? primaryYellow : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  icons[index],
                  color: isSelected ? primaryYellow : Colors.grey[400],
                  size: 30,
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  Widget _buildVehicleList() {
    return Obx(() {
      var vehicles =
          controller.vehicleCategories[controller.selectedCategoryIndex.value];

      return Column(
        children: vehicles.map((vehicle) {
          bool isSelected = controller.selectedVehicleId.value == vehicle.id;

          return GestureDetector(
            onTap: () => controller.selectedVehicleId.value = vehicle.id,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? primaryYellow : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      width: 80,
      height: 60,
      margin: const EdgeInsets.only(right: 12),
      child: vehicle.imagePath.isNotEmpty
          ? Image.asset(
              vehicle.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.local_shipping,
                color: Colors.amber,
                size: 40,
              ),
            )
          : const Icon(
              Icons.local_shipping,
              color: Colors.amber,
              size: 40,
            ),
    ),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  vehicle.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle_outline
                    : Icons.radio_button_off,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            vehicle.description,
            style: TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vehicle.dimensions,
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    ),
  ],
)

            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildServicesList() {
    return Obx(
      () => Column(
        children: controller.services.map((service) {
          bool isSelected = service.isSelected.value;
          return GestureDetector(
            onTap: () => service.isSelected.toggle(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: primaryYellow, width: 1.5)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: TextStyle(color: textDark, fontSize: 14),
                    ),
                  ),
                  Text(
                    "+S\$${service.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.keyboard_arrow_up),
                    Text("Total (incl.GST)", style: TextStyle(color: textGrey)),
                  ],
                ),
                Obx(
                  () => Text(
                    "S\$${controller.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Action for Review Order
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: textDark,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Review order"),
            ),
          ],
        ),
      ),
    );
  }
}
