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

class ActiveOrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const ActiveOrderDetailsScreen({super.key, required this.order});

  @override
  State<ActiveOrderDetailsScreen> createState() =>
      _ActiveOrderDetailsScreenState();
}

class _ActiveOrderDetailsScreenState extends State<ActiveOrderDetailsScreen> {
  late final OrderController controller;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    if (widget.order.riderId != null) {
      controller.fetchRiderInfoById(widget.order.riderId!);
    }
    _addMarkers();
  }

  void _addMarkers() {
    if (widget.order.pickupLat != null && widget.order.pickupLong != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: LatLng(widget.order.pickupLat!, widget.order.pickupLong!),
          infoWindow: InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    if (widget.order.dropOffLat != null && widget.order.dropOffLong != null) {
      _markers.add(
        Marker(
          markerId:  MarkerId('dropoff'),
          position: LatLng(widget.order.dropOffLat!, widget.order.dropOffLong!),
          infoWindow: InfoWindow(title: 'Drop-off Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitBounds();
  }

  void _fitBounds() {
    if (widget.order.pickupLat == null || widget.order.dropOffLat == null)
      return;

    LatLngBounds bounds;
    LatLng pickup = LatLng(widget.order.pickupLat!, widget.order.pickupLong!);
    LatLng dropoff = LatLng(
      widget.order.dropOffLat!,
      widget.order.dropOffLong!,
    );

    if (pickup.latitude > dropoff.latitude) {
      bounds = LatLngBounds(southwest: dropoff, northeast: pickup);
    } else {
      bounds = LatLngBounds(southwest: pickup, northeast: dropoff);
    }
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  String formatDateTime(String dateTime) {
    try {
      if (dateTime.isEmpty) return "N/A";
      final dt = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: Obx(() {
          final liveOrder = controller.orderList.firstWhere(
            (o) => o.orderId == widget.order.orderId,
            orElse: () => widget.order,
          );

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Color(0xFFFFCC00),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    ),
                     SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Order #${liveOrder.orderId} is pending",
                        style: getTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                width: double.infinity,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.order.pickupLat ?? 1.3521,
                      widget.order.pickupLong ?? 103.8198,
                    ),
                    zoom: 12,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding:  EdgeInsets.all(16),
                    decoration:  BoxDecoration(
                      color: AppColors.backgroungColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiderDetails(order: liveOrder),
                         SizedBox(height: 12),
                        MessageCallButtons(
                          phoneNumber: liveOrder.assignRiderPhone,
                        ),

                         SizedBox(height: 12),
                        RatingsSection(
                          rating: liveOrder.assignRiderRating,
                          totalReviews: liveOrder.assignRiderReviews,
                        ),
                         SizedBox(height: 16),
                        PriceAndPayment(order: liveOrder),

                         SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Pickup Date & Time: ",
                              style: getTextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formatDateTime(liveOrder.scheduledTime),
                              style: getTextStyle(),
                            ),
                          ],
                        ),
                         SizedBox(height: 20),
                        StopItem(
                          iconPath: IconPath.locationBlue,
                          title: "Collected from (${liveOrder.senderName})",
                          address: liveOrder.pickupAddress,
                        ),
                        StopItem(
                          iconPath: IconPath.locationRed,
                          title: "Deliver to",
                          address: liveOrder.dropOffAddress,
                        ),
                         SizedBox(height: 20),

                        CustomButton(
                          label: 'Share Ride Information',
                          onPressed: () {},
                          color: AppColors.primaryButtonColor,
                          textColor: AppColors.fontColor,
                        ),
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
          radius: 28,
          backgroundImage: order.assignRiderImage.isNotEmpty
              ? NetworkImage(order.assignRiderImage) as ImageProvider
              : AssetImage(ImagePath.profileImage),
        ),
         SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.assignRiderName,
                style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "Vehicle type: ${order.vehicleType}",
                style: getTextStyle(fontSize: 13),
              ),
              Text(
                "Order #${order.orderId}",
                style: getTextStyle(fontSize: 13),
              ),
              Text(
                "Scheduled Pickup: ${order.date}",
                style: getTextStyle(fontSize: 13),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          onPressed: _messageRider,
          icon: const Icon(Icons.message, size: 20),
          label: Text(
            "Message",
            style: getTextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _callRider,
          icon: const Icon(Icons.call, size: 20),
          label: Text("Call", style: getTextStyle(fontWeight: FontWeight.w500)),
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
            size: 18,
          ),
        const SizedBox(width: 6),
        Text("${rating.toStringAsFixed(1)}/5", style: getTextStyle()),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            '($totalReviews Reviews)',
            style: getTextStyle(color: Colors.lightBlue),
          ),
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
      children: [
        Column(
          children: [
            Text("Total", style: getTextStyle(fontWeight: FontWeight.w600)),
            Text(
              "S\$${order.total.toStringAsFixed(2)}",
              style: getTextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        Image.asset(IconPath.visa, height: 22, width: 24),
        const SizedBox(width: 4),
        Text("****456", style: getTextStyle(fontSize: 13)),
      ],
    );
  }
}

class StopItem extends StatelessWidget {
  final String title;
  final String address;
  final String iconPath;

  const StopItem({
    super.key,
    required this.title,
    required this.address,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconPath.isNotEmpty
              ? Image.asset(iconPath, height: 18, width: 18)
              : const Icon(Icons.location_on, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: getTextStyle(fontWeight: FontWeight.w600)),
                Text(address, style: getTextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
