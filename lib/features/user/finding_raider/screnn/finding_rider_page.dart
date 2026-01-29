import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/cancel_order_dialog.dart';
import 'package:ZipBee/features/user/finding_raider/widget/order_location_info_widget.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/add_amount_dialog.dart'; // নতুন ডায়ালগ ইমপোর্ট
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/payment_method_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindingRiderPage extends StatelessWidget {
  FindingRiderPage({super.key});

  final RiderController controller = Get.isRegistered<RiderController>()
      ? Get.find<RiderController>()
      : Get.put(RiderController());

  final StackedOrderController orderController =
      Get.find<StackedOrderController>();

  @override
  Widget build(BuildContext context) {
    // API কল করার লজিক
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String rawId = orderController.orderNumber.value.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      int? id = int.tryParse(rawId);

      debugPrint('🔍 Attempting to fetch order with ID: $id (Raw: ${orderController.orderNumber.value})');

      if (id != null && id != 0) {
        controller.fetchOrderData(id);
      } else {
        debugPrint('⚠️ Error: Order ID is null or zero. API not called.');
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(IconPath.colorFullArrow, width: 24, height: 24),
          ),
        ),
      ),
      body: Stack(
        children: [
          const SizedBox.expand(child: GoogleMapWidget()),

          Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
                : DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.3,
                    maxChildSize: 0.7,
                    builder: (_, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dragHandle(),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    'Finding your rider',
                                    style: getTextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    stepBar(active: true),
                                    stepBar(active: false),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Obx(
                                    () => Text(
                                      'Order ${orderController.orderNumber.value}',
                                      style: getTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                OrderLocationInfoWidget(
                                  pickupName: controller.pickupName,
                                  pickupAddress: controller.pickupAddress,
                                  dropName: controller.dropName,
                                  dropAddress: controller.dropAddress,
                                ),

                                const SizedBox(height: 20),
                                buildFareOptions(),
                                const SizedBox(height: 20),
                                Center(child: addAmountButton(context)),
                                const SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Button(
                                    buttonText: 'Priority order',
                                    backgroundColor: Colors.amber,
                                    textColor: Colors.black,
                                    onPressed: controller.placeOrder,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Center(
                                  child: FilledButton(
                                    onPressed: () =>
                                        showCancelOrderDialog(context),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Cancel order',
                                          style: getTextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Image.asset(
                                          IconPath.cancel,
                                          height: 14,
                                          width: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget stepBar({required bool active}) {
    return Container(
      width: 69,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? Colors.amber : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget addAmountButton(BuildContext context) {
    StackedPaymentController paymentCtrl;
    try {
      paymentCtrl = Get.find<StackedPaymentController>();
    } catch (_) {
      paymentCtrl = Get.put(StackedPaymentController());
    }

    return GestureDetector(
      onTap: () => showAddAmountDialog(context, controller, paymentCtrl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add amount',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(Icons.add, size: 13, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget buildFareOptions() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(controller.fareOptions.length, (index) {
          return GestureDetector(
            onTap: () => controller.selectFare(index),
            child: Card(
              elevation: controller.selectedFare.value == index ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: controller.selectedFare.value == index
                  ? Colors.amber
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text(
                  '\$${controller.fareOptions[index].toStringAsFixed(1)}',
                  style: TextStyle(
                    color: controller.selectedFare.value == index
                        ? Colors.black
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}