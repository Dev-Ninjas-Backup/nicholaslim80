import 'package:ZipBee/features/user/order/active_order_details/widgets/message_call_section.dart';
import 'package:ZipBee/features/user/order/active_order_details/widgets/order_rating_bar.dart';
import 'package:ZipBee/features/user/order/active_order_details/widgets/order_stops_list.dart';
import 'package:ZipBee/features/user/order/active_order_details/widgets/payment_and_time_info.dart';
import 'package:ZipBee/features/user/order/active_order_details/widgets/rider_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/common/widgets/custom_button.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../finding_raider/screnn/review_view.dart';
import '../../../controller/order_controller.dart';
import '../../../model/order_model.dart';

class CompletedOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const CompletedOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Controller ইনিশিয়ালাইজেশন
    final OrderController controller = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    // এপিআই কল
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetail(order.orderId);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final liveOrder = controller.singleOrder.value ?? order;

          return Column(
            children: [
              // --- ১. হেডার পার্ট ---
              _buildHeader(liveOrder),

              // --- ২. কন্টেন্ট পার্ট ---
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Reusable: রাইডার ডিটেইলস
                        RiderDetailsCard(order: liveOrder),

                        const SizedBox(height: 16),

                        // ✅ Reusable: মেসেজ এবং কল বাটন
                        MessageCallSection(order: liveOrder),

                        const SizedBox(height: 12),

                        // ✅ Reusable: স্টার রেটিং বার
                        OrderRatingBar(
                          rating: liveOrder.assignRiderRating,
                          totalReviews: liveOrder.assignRiderReviews,
                        ),

                        const Divider(height: 32),

                        // ✅ Reusable: পেমেন্ট এবং টাইম ইনফো
                        PaymentAndTimeInfo(order: liveOrder),

                        const SizedBox(height: 24),

                        // ✅ Reusable: মাল্টিপল স্টপস লিস্ট (আপনার কন্ট্রোলারের লজিক অনুযায়ী)
                        OrderStopsList(
                          pickupStops: controller.getPickupStops(liveOrder),
                          dropStops: controller.getDropStops(liveOrder),
                        ),

                        const SizedBox(height: 16),

                        // --- ৩. স্পেশাল পার্ট (Proof of Delivery) ---
                        _buildProofOfDelivery(liveOrder),

                        const SizedBox(height: 32),

                        // --- ৪. একশন বাটনস ---
                        CustomButton(
                          label: 'Share Ride Information',
                          onPressed: () {},
                          color: AppColors.primaryButtonColor,
                          textColor: AppColors.fontColor,
                        ),
                        const SizedBox(height: 12),
                        
                        // Rating & Review Button (স্পেশাল পার্ট)
                        CustomButton(
                          label: 'Rating & Review',
                          onPressed: () {
                            Get.to(
                              () => ReviewView(
                                orderId: liveOrder.orderId,
                                riderId: liveOrder.riderId,
                              ),
                            );
                          },
                          color: AppColors.primaryButtonColor,
                          textColor: AppColors.fontColor,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // হেডার উইজেট
  Widget _buildHeader(OrderModel liveOrder) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE0E0E0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Text(
                "Order #${liveOrder.orderId} is ${liveOrder.status.toLowerCase()}",
                style: getTextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  // Proof of Delivery উইজেট (আপনার অরিজিনাল লজিক)
  Widget _buildProofOfDelivery(OrderModel liveOrder) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/ProofOfDeliveryScreen2',
        arguments: liveOrder.orderId,
      ),
      child: Row(
        children: [
          const Icon(Icons.image_outlined, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          Text(
            "View Proof of Delivery",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}