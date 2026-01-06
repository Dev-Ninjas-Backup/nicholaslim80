import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controller/controller.dart';

class StackedBottomSummary extends StatelessWidget {
  final StackedVehicleController vehicleController;
  final List<String> couriers;

  const StackedBottomSummary({
    super.key,
    required this.vehicleController,
    required this.couriers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 70),
        padding: EdgeInsets.all(5),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_drop_up, size: 32),
              onPressed: () {
                openHistoryPopup(context);
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total (incl. GST):',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  Obx(
                        () => Text(
                      'S\$${vehicleController.calculateTotal().toStringAsFixed(2)}',
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
                  () => FilledButton(
                onPressed: vehicleController.selectedVehicle.value != null
                    ? () {
                  double total = vehicleController.calculateTotal();
                  Get.toNamed(
                    AppRoutes.getstackedScreen(),
                    arguments: {'totalAmount': total},
                  );
                }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) => vehicleController.selectedVehicle.value != null
                        ? Colors.amber
                        : Colors.grey.shade400,
                  ),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
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

            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void openHistoryPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
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
                      () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: vehicleController.calculationHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.check, color: Colors.amber),
                        title: Text(
                          vehicleController.calculationHistory[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Divider(),
              Text(
                "Total Amount:",
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Obx(
                    () => Text(
                  "S\$${vehicleController.calculateTotal().toStringAsFixed(2)}",
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
