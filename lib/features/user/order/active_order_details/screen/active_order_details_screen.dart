import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../controller/order_controller.dart';
import '../../model/order_model.dart';

class ActiveOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  const ActiveOrderDetailsScreen({super.key, required this.order});

  String formatDateTime(String dateTime) {
    try {
      if (dateTime.isEmpty) return "N/A";
      final dt = DateTime.parse(dateTime);
      return DateFormat('dd MMM yy / hh:mm a').format(dt);
    } catch (e) {
      return dateTime;
    }
  }

  Set<Marker> _getMarkers(OrderModel order) {
    final Set<Marker> markers = {};
    if (order.pickupLat != null && order.pickupLong != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(order.pickupLat!, order.pickupLong!),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    if (order.dropOffLat != null && order.dropOffLong != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: LatLng(order.dropOffLat!, order.dropOffLong!),
          infoWindow: const InfoWindow(title: 'Drop-off Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    // Trigger fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetail(order.orderId);
    });

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final liveOrder = controller.singleOrder.value ?? order;

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFFE0E0E0),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Order #${liveOrder.orderId} is ${liveOrder.status.toLowerCase()}",
                          style: getTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ),
              SizedBox(
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
                  markers: _getMarkers(liveOrder),
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (mapController) {
                    if (liveOrder.pickupLat != null &&
                        liveOrder.dropOffLat != null) {
                      LatLng pickup = LatLng(
                        liveOrder.pickupLat!,
                        liveOrder.pickupLong!,
                      );
                      LatLng dropoff = LatLng(
                        liveOrder.dropOffLat!,
                        liveOrder.dropOffLong!,
                      );
                      LatLngBounds bounds;
                      if (pickup.latitude > dropoff.latitude) {
                        bounds = LatLngBounds(
                          southwest: dropoff,
                          northeast: pickup,
                        );
                      } else {
                        bounds = LatLngBounds(
                          southwest: pickup,
                          northeast: dropoff,
                        );
                      }
                      mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(bounds, 50),
                      );
                    }
                  },
                ),
              ),

              // Details
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiderDetails(order: liveOrder),

                        const SizedBox(height: 16),

                        // Message & Call
                        MessageCallButtons(
                          phoneNumber: liveOrder.assignRiderPhone,
                        ),

                        SizedBox(height: 12),
                        RatingsSection(
                          rating: liveOrder.assignRiderRating,
                          totalReviews: liveOrder.assignRiderReviews,
                        ),

                        const Divider(height: 32),

                        // Price & Payment
                        PriceAndPayment(order: liveOrder),

                        const Divider(height: 32),

                        // Date & Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date & Time",
                              style: getTextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              formatDateTime(liveOrder.scheduledTime),
                              style: getTextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Stops
                        StopItem(
                          isPickup: true,
                          title:
                              "Collected from (Sender: ${liveOrder.senderName})",
                          address: liveOrder.pickupAddress,
                        ),
                        StopItem(
                          isPickup: false,
                          title:
                              "Deliver to (Recipient: ${liveOrder.recipientName})",
                          address: liveOrder.dropOffAddress,
                        ),

                        const SizedBox(height: 16),

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
}

class RiderDetails extends StatelessWidget {
  final OrderModel order;
  const RiderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: order.assignRiderImage.isNotEmpty
              ? NetworkImage(order.assignRiderImage) as ImageProvider
              : AssetImage(ImagePath.profileImage),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.assignRiderName,
                style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                "Vehicle type: ${order.vehicleType}",
                style: getTextStyle(fontSize: 14),
              ),
              Text("Order ${order.orderId}", style: getTextStyle(fontSize: 14)),
              Text(
                "Est. Delivery time: 30 min",
                style: getTextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageCallButtons extends StatelessWidget {
  final String? phoneNumber;
  const MessageCallButtons({super.key, this.phoneNumber});

  void _callRider() async {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      final url = Uri.parse("tel:$phoneNumber");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  void _messageRider() async {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      final url = Uri.parse("sms:$phoneNumber");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _messageRider,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.message_outlined,
                  size: 20,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  "Message",
                  style: getTextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: _callRider,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call_outlined, size: 20, color: Colors.black),
                const SizedBox(width: 8),
                Text("Call", style: getTextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RatingsSection extends StatelessWidget {
  final double rating;
  final int totalReviews;

  const RatingsSection({
    super.key,
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 24,
          ),
        const SizedBox(width: 8),
        Text(
          "${rating.toStringAsFixed(0)}/5",
          style: getTextStyle(fontSize: 14),
        ),
        const Spacer(),
        Text(
          '($totalReviews Reviews)',
          style: getTextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}

class PriceAndPayment extends StatelessWidget {
  final OrderModel order;
  const PriceAndPayment({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total",
              style: getTextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Text(
              "S\$${order.total.toStringAsFixed(2)}",
              style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(IconPath.visa, height: 24),
            const SizedBox(width: 8),
            Text(
              "****456",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}

class StopItem extends StatelessWidget {
  final String title;
  final String address;
  final bool isPickup;

  const StopItem({
    super.key,
    required this.title,
    required this.address,
    required this.isPickup,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPickup ? Colors.blue : Colors.red,
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPickup ? Colors.blue : Colors.red,
                  ),
                ),
              ),
            ),
            if (isPickup)
              Container(height: 30, width: 2, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  if (isPickup)
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
              Text(address, style: getTextStyle(fontSize: 13)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
