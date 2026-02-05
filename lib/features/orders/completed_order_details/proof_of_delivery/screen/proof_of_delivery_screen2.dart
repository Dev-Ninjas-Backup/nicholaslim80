import 'package:ZipBee/features/orders/completed_order_details/proof_of_delivery/controller/proof_of_delivery_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProofOfDeliveryScreen2 extends StatelessWidget {
  ProofOfDeliveryScreen2({super.key});

  final controller = Get.put(ProofOfDeliveryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Proof of Delivery",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          /// Main Image
          Positioned.fill(
            child: Obx(
              () => Image.asset(
                controller.selectedImage.value,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Overlay
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Info
                  Obx(
                    () => Text(
                      "Tracking Number: ${controller.trackingNumber.value}",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Obx(
                    () => Text(
                      "Delivered on ${controller.deliveredAt.value}",
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                  ),

                  const Spacer(),

                  /// Bottom Info
                  Obx(() => _infoText(controller.deliveryDate.value)),
                  Obx(() => _infoText(controller.location.value)),
                  Obx(() => _infoText(controller.coordinates.value)),
                  Obx(() => _infoText(controller.orderId.value)),

                  SizedBox(height: 12.h),

                  /// Thumbnails
                  SizedBox(
                    height: 70.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.images.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final image = controller.images[index];

                        return GestureDetector(
                          onTap: () {
                            controller.changeImage(image);
                          },
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: controller.selectedImage.value == image
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: Image.asset(
                                  image,
                                  width: 70.w,
                                  height: 70.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}
