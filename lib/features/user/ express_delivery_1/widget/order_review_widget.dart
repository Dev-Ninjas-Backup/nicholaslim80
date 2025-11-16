import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/controller/vehicle_controller.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class OrderReviewWidget extends StatelessWidget {
  final VehicleController vehicleController;

  const OrderReviewWidget({
    super.key,
    required this.vehicleController,
    required int total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _historyButton(context),
          const SizedBox(width: 12),
          Expanded(child: _totalInfo()),
          const SizedBox(width: 12),
          _reviewOrderButton(),
        ],
      ),
    );
  }

  // Static history button
  Widget _historyButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_drop_up, size: 32, color: Colors.black54),
      onPressed: () => _openHistoryPopup(context),
    );
  }

  // Static label + dynamic total
  Widget _totalInfo() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total (incl. GST):',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'S\$${vehicleController.calculateTotal().toStringAsFixed(2)}',
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Dynamic review button
  Widget _reviewOrderButton() {
    return Obx(
      () => FilledButton(
        onPressed: vehicleController.selectedVehicle.value != null
            ? () {
                final total = vehicleController.calculateTotal();
                Get.toNamed(
                  AppRoutes.getexpressSenderOrRecepment(),
                  arguments: {'totalAmount': total},
                );
              }
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: vehicleController.selectedVehicle.value != null
              ? Colors.amber
              : CupertinoColors.inactiveGray,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          'Review Order',
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // History popup
  void _openHistoryPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 50,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              "Calculation History",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Flexible(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: vehicleController.calculationHistory.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: Icon(Icons.check, color: Colors.amber),
                      title: Text(vehicleController.calculationHistory[index]),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Total Amount:",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Obx(
              () => Text(
                "S\$${vehicleController.calculateTotal().toStringAsFixed(2)}",
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
