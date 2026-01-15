import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/cancel_order_dialog.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindingRiderPage extends StatelessWidget {
  FindingRiderPage({super.key});

  /// ✅ SAFE CONTROLLER ACCESS
  final RiderController controller = Get.isRegistered<RiderController>()
      ? Get.find<RiderController>()
      : Get.put(RiderController());

  @override
  Widget build(BuildContext context) {
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

          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        _dragHandle(),
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

                        /// STEP BAR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _stepBar(active: true),
                            _stepBar(active: false),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Text(
                            'Good Fare, Your Request Gets Priority 2:00',
                            style: getTextStyle(fontSize: 12),
                          ),
                        ),

                        SizedBox(height: 20),

                        /// 📍 PICKUP & DROP (API DRIVEN)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => LocationRowWidget(
                                  iconPath: IconPath.collectIcon,
                                  title: controller.pickupName.value.isEmpty
                                      ? 'Collected from'
                                      : 'Collected from (Sender: ${controller.pickupName.value})',
                                  address:
                                      controller.pickupAddress.value.isEmpty
                                      ? '-'
                                      : controller.pickupAddress.value,
                                ),
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.fiber_manual_record,
                                    size: 8,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 6),
                                  Icon(
                                    Icons.fiber_manual_record,
                                    size: 8,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              Obx(
                                () => LocationRowWidget(
                                  iconPath: IconPath.deliveredIcon,
                                  title: controller.dropName.value.isEmpty
                                      ? 'Deliver to'
                                      : 'Deliver to (Recipient: ${controller.dropName.value})',
                                  address: controller.dropAddress.value.isEmpty
                                      ? '-'
                                      : controller.dropAddress.value,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildFareOptions(),

                        const SizedBox(height: 20),

                        Center(child: _addAmountButton()),

                        const SizedBox(height: 20),

                        /// 🚚 PLACE ORDER
                        Button(
                          buttonText: 'Priority order',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black,
                          onPressed: controller.placeOrder,
                        ),

                        const SizedBox(height: 24),

                        /// ❌ CANCEL ORDER
                        Center(
                          child: FilledButton(
                            onPressed: () => showCancelOrderDialog(context),
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
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _dragHandle() {
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

  Widget _stepBar({required bool active}) {
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

  Widget _addAmountButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
child: TextButton(
  onPressed: () {
    
  },
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      const Icon(
        Icons.add,
        size: 13,
        color: Colors.grey,
      ),
    ],
  ),
)
,
    );
  }

  Widget _buildFareOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(controller.fareOptions.length, (index) {
        return Obx(
          () => GestureDetector(
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
                  'S\$${controller.fareOptions[index]}',
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
          ),
        );
      }),
    );
  }
}
