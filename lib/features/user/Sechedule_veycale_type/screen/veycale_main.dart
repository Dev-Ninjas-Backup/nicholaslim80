import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/user/Sechedule_veycale_type/controller/sechedule_vehicle_controller.dart';
import '../widget/sechedule_veycale_widget.dart';

class SecheduleVehicleSelectionPage extends StatelessWidget {
  const SecheduleVehicleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Initialize Controller ONE TIME
    final controller = Get.put(VehicleSelectionController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroungColor,
        appBar: buildAppBar(),
        body: TabBarView(
          children: [
            VehicleListContent(type: 'Courier'),
            VehicleListContent(type: 'Car'),
            VehicleListContent(type: 'Van'),
            VehicleListContent(type: 'Truck'),
          ],
        ),
        bottomNavigationBar: BottomSummaryPanel(controller: controller),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.backgroungColor,
      centerTitle: true,
      title: Text(
        'Vehicle Type',
        style: getTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TabBar(
          //indicatorColor: Colors.amber,
          //indicatorWeight: 3,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.amber.withOpacity(0.2),
            border: Border.all(color: Colors.amber, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          labelColor: Colors.black,

          tabs: [
            buildTabIcon(IconPath.bike2),
            buildTabIcon(IconPath.car2),
            buildTabIcon(IconPath.shipment),
            buildTabIcon(IconPath.shopcar),
          ],
        ),
      ),
    );
  }

  Widget buildTabIcon(String path) {
    return Tab(
      icon: Image.asset(path, height: 67, width: 67, fit: BoxFit.contain),
    );
  }
}

// ------------------------------------------------------------------------
// TAB CONTENT
// ------------------------------------------------------------------------
class VehicleListContent extends StatelessWidget {
  final String type;

  VehicleListContent({required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleSelectionController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Vehicle',
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // List of Vehicles
          ...controller.getVehiclesByType(type).map((vehicle) {
            return Obx(
              () => VehicleCard(
                vehicle: vehicle,
                isSelected:
                    controller.selectedVehicle.value?.name == vehicle.name,
                onTap: () => controller.selectVehicle(vehicle),
              ),
            );
          }),

          SizedBox(height: 20),

          // Additional Services for selected type
          Obx(() {
            if (controller.selectedVehicle.value?.type != type) {
              return SizedBox.shrink();
            }

            final services = controller.availableServices;
            if (services.isEmpty) return SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Services',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ...services.map((service) {
                  return ServiceCard(
                    service: service,
                    isSelected: controller.selectedServices.contains(service),
                    onTap: () => controller.toggleService(service),
                  );
                }),
              ],
            );
          }),

          SizedBox(height: 140),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------------
// BOTTOM SUMMARY PANEL
// ------------------------------------------------------------------------
class BottomSummaryPanel extends StatelessWidget {
  final VehicleSelectionController controller;
  const BottomSummaryPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => showHistoryModal(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                  Text(
                    "View Breakdown",
                    style: getTextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Divider(),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total:',
                        style: getTextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Obx(
                        () => Text(
                          'S\$${controller.totalAmount.toStringAsFixed(2)}',
                          style: getTextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isOrderReady
                        ? () {
                            Get.back();
                            // Get.toNamed(
                            //   AppRoutes.getexpressSenderOrRecepment(),
                            //   arguments: {
                            //     'totalAmount': controller.totalAmount,
                            //   },
                            // );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, color: Colors.grey[300]),
              ),
              SizedBox(height: 20),
              Text(
                "Price Breakdown",
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Obx(
                () => Column(
                  children: controller.calculationHistory
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.check, size: 16, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(item, style: getTextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              Divider(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "S\$${controller.totalAmount.toStringAsFixed(2)}",
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
