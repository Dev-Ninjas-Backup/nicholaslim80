import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/rider/rider_home/controller/rider_home_controller.dart';
import 'package:nicholaslim80/features/rider/rider_home/widgets/rider_card_widget.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiderHomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Online', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          Obx(
            () => Switch(
              value: ctrl.isOnline.value,
              onChanged: ctrl.toggleOnline,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        if (ctrl.orders.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: ctrl.orders.length,
          itemBuilder: (context, index) {
            final order = ctrl.orders[index];
            return RiderCardWidget(order: order, index: index, ctrl: ctrl);
          },
        );
      }),
    );
  }
}
