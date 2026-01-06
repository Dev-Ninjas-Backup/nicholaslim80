import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/kamrul_express/controller/kamrul_express_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


final controller = Get.find<KamrulExpressController>();

Widget vehicleSelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🔥 TEXT + INFO ICON IN SAME ROW
      Row(
        children: [
          Text(
            "Vehicle type",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 6),
          Icon(Icons.info_outline, color: Colors.black87, size: 18),
        ],
      ),

      SizedBox(height: 12),

      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Row(
            children: [
              buildVehicleItem(0, IconPath.bike2),
              SizedBox(width: 12),
              buildVehicleItem(1, IconPath.car2),
              SizedBox(width: 12),
              buildVehicleItem(2, IconPath.shopcar),
              SizedBox(width: 12),
              buildVehicleItem(3, IconPath.shipment),
              SizedBox(width: 12),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildVehicleItem(int index, String iconPath) {
  return GestureDetector(
    onTap: () => controller.selectVehicle(index),
    child: Container(
      width: 91,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: controller.selectedVehicle.value == index
              ? AppColors.primaryButtonColor
              : Colors.transparent,
          width: controller.selectedVehicle.value == index ? 2 : 1,
        ),
      ),
      child: Center(
        child: Image.asset(
          iconPath,
          width: 90,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
