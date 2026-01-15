import 'package:ZipBee/features/user/home/my_riders/controller/my_riders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAddRiderDialog() {
  final MyRidersController controller = Get.find<MyRidersController>();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              "Add a favorite rider",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
             SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),

             SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.addRider,
                child: Text("Add"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
