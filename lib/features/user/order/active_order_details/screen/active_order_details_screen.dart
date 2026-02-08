import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../controller/order_controller.dart';
import '../../model/order_model.dart';
import '../widgets/rider_details_card.dart';
import '../widgets/message_call_section.dart';
import '../widgets/order_rating_bar.dart';
import '../widgets/payment_and_time_info.dart';
import '../widgets/order_stops_list.dart';

class ActiveOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  const ActiveOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.fetchOrderDetail(order.orderId),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value)
            return const Center(child: CircularProgressIndicator());
          final liveOrder = controller.singleOrder.value ?? order;

          return Column(
            children: [
              _buildHeader(liveOrder),
              _buildMap(liveOrder),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiderDetailsCard(order: liveOrder),
                        const SizedBox(height: 16),
                        MessageCallSection(order: liveOrder),
                        const SizedBox(height: 12),
                        OrderRatingBar(
                          rating: liveOrder.assignRiderRating,
                          totalReviews: liveOrder.assignRiderReviews,
                        ),
                        const Divider(height: 32),
                        PaymentAndTimeInfo(order: liveOrder),
                        const SizedBox(height: 24),
                        OrderStopsList(
                          pickupStops: controller.getPickupStops(liveOrder),
                          dropStops: controller.getDropStops(liveOrder),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          label: 'Share Ride Information',
                          onPressed: () {},
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

  Widget _buildMap(OrderModel liveOrder) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            liveOrder.pickupLat ?? 1.3521,
            liveOrder.pickupLong ?? 103.8198,
          ),
          zoom: 12,
        ),
        markers: {
          if (liveOrder.pickupLat != null)
            Marker(
              markerId: const MarkerId('pickup'),
              position: LatLng(liveOrder.pickupLat!, liveOrder.pickupLong!),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
          if (liveOrder.dropOffLat != null)
            Marker(
              markerId: const MarkerId('dropoff'),
              position: LatLng(liveOrder.dropOffLat!, liveOrder.dropOffLong!),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
        },
        zoomControlsEnabled: false,
      ),
    );
  }
}
