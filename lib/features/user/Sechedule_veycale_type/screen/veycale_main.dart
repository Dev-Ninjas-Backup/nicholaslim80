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
        appBar: _buildAppBar(),
        body: TabBarView(
          children: const [
            _VehicleListContent(type: 'Courier'),
            _VehicleListContent(type: 'Car'),
            _VehicleListContent(type: 'Van'),
            _VehicleListContent(type: 'Truck'),
          ],
        ),
        bottomNavigationBar: _BottomSummaryPanel(controller: controller),
      ),
    );
  }

  AppBar _buildAppBar() {
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
        preferredSize: const Size.fromHeight(60),
        child: TabBar(
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            _buildTabIcon(IconPath.bike2),
            _buildTabIcon(IconPath.car2),
            _buildTabIcon(IconPath.shipment),
            _buildTabIcon(IconPath.shopcar),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIcon(String path) {
    return Tab(
      icon: Image.asset(path, height: 80, width: 80, fit: BoxFit.contain),
    );
  }
}

// ------------------------------------------------------------------------
// TAB CONTENT
// ------------------------------------------------------------------------
class _VehicleListContent extends StatelessWidget {
  final String type;

  const _VehicleListContent({required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleSelectionController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Vehicle',
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

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

          const SizedBox(height: 20),

          // Additional Services for selected type
          Obx(() {
            if (controller.selectedVehicle.value?.type != type) {
              return const SizedBox.shrink();
            }

            final services = controller.availableServices;
            if (services.isEmpty) return const SizedBox.shrink();

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
                const SizedBox(height: 10),
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

          const SizedBox(height: 140),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------------
// BOTTOM SUMMARY PANEL
// ------------------------------------------------------------------------
class _BottomSummaryPanel extends StatelessWidget {
  final VehicleSelectionController controller;
  const _BottomSummaryPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _showHistoryModal(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                  Text(
                    "View Breakdown",
                    style: getTextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Divider(),

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
                      padding: const EdgeInsets.symmetric(
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

  void _showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, color: Colors.grey[300]),
              ),
              const SizedBox(height: 20),
              Text(
                "Price Breakdown",
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Obx(
                () => Column(
                  children: controller.calculationHistory
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Text(item, style: getTextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const Divider(height: 30),

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
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
