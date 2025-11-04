import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/rider/rider_home/controller/rider_home_controller.dart';
import 'package:nicholaslim80/features/rider/rider_home/widgets/rider_card_widget.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiderHomeController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => AppBar(
            backgroundColor: Colors.white,
            elevation: 6,
            shadowColor: Colors.grey.withOpacity(0.4),
            centerTitle: true,

            // ✅ Dynamic title color based on online status
            title: Text(
              ctrl.isOnline.value ? 'Online' : 'Offline',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),

            // ✅ Dynamic back icon color
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              splashRadius: 24,
              // ignore: deprecated_member_use
              highlightColor: AppColors.primaryButtonColor.withOpacity(0.2),
              onPressed: () {
                Get.back();
              },
            ),

            // ✅ Online/Offline Switch
            actions: [
              Switch(
                value: ctrl.isOnline.value,
                onChanged: ctrl.toggleOnline,
                activeThumbColor: AppColors.primaryButtonColor,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),

      backgroundColor: Colors.white,

      // ✅ Reactive body for order list
      body: Obx(() {
        if (ctrl.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
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
