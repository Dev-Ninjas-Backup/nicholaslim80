import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/order_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/stacked_controller.dart';
import 'package:ZipBee/routes/app_routes.dart';


class VehicleCards extends StatelessWidget {
  const VehicleCards({super.key, required this.ctrl});

  final HomeController ctrl;

  String _assetForVehicle(StackVehicle v) {
    final vt = v.type.toUpperCase();
    if (['MOTORCYCLE', 'BICYCLE', 'ELECTRIC_SCOOTER'].contains(vt)) {
      return IconPath.courierIcon;
    } else if (['CAR'].contains(vt)) {
      return IconPath.realCar;
    } else if (['SUV'].contains(vt)) {
      return IconPath.suv;
    } else if (vt == 'VAN') {
      return IconPath.trunk2;
    } else if (vt == 'TRUCK') {
      return IconPath.trunk3;
    } else if (v.imageAsset != null && v.imageAsset!.isNotEmpty) {
      return v.imageAsset!;
    } else {
      return IconPath.bike;
    }
  }

  String _prettyName(String raw) {
    return raw.replaceAll('_', ' ').toLowerCase().split(' ').map((s) => s.isEmpty ? s : (s[0].toUpperCase() + s.substring(1))).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final svc = Get.isRegistered<StackedVehicleController>() ? Get.find<StackedVehicleController>() : Get.put(StackedVehicleController());

    return SizedBox(
      height: 300,
      child: Obx(() {
        // combine the categorized lists into a single list for the home carousel
        final vehicles = <StackVehicle>[];
        vehicles.addAll(svc.t1);
        vehicles.addAll(svc.t2);
        vehicles.addAll(svc.t3);
        vehicles.addAll(svc.t4);

        if (vehicles.isEmpty) {
          // fallback to existing sample maps if API hasn't loaded yet
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ctrl.vehicles.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final v = ctrl.vehicles[index];

              return SizedBox(
                width: 220,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.subtitleFontColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (v['image'] != null)
                        Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: v['image']),
                          ),
                        ),
                      SizedBox(height: 6),
                      Text(
                        v['title'],
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        v['subtitle'],
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppColors.primaryFontColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              v['weight'],
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "\$${v['priceFrom']}",
                            style: getTextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryButtonColor,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Select Vehicle',
                            style: getTextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: vehicles.length,
          separatorBuilder: (_, __) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            final isSelected = svc.selectedVehicle.value?.id == vehicle.id;

            return SizedBox(
              width: 220,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.subtitleFontColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image + non-clickable selection tick overlay
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _assetForVehicle(vehicle),
                              fit: BoxFit.fitHeight,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 220),
                              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                              child: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      key: ValueKey('selected_${vehicle.id}'),
                                    )
                                  : SizedBox.shrink(key: ValueKey('unselected_${vehicle.id}')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),

                    // name
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _prettyName(vehicle.name),
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    SizedBox(height: 4),

                    // dimension (small subtitle)
                    // Text(
                    //   vehicle.dimension ?? '',
                    //   style: getTextStyle(
                    //     fontSize: 12,
                    //     color: AppColors.primaryFontColor,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // SizedBox(height: 8),

                    // details
                    Text(
                      vehicle.details,
                      style: getTextStyle(
                        fontSize: 12,
                        color: AppColors.primaryFontColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.maxLoad != null && vehicle.maxLoad!.isNotEmpty
                                ? 'Max load: ${vehicle.maxLoad}'
                                : '',
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Base: \$${(vehicle.basePrice ?? vehicle.price).toStringAsFixed(0)}',
                          style: getTextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 12),

                    // Per km row and button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Per km: \$${(vehicle.perKmPrice ?? 0).toStringAsFixed(2)}/km',
                            style: getTextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                    // SizedBox(height: 8),
                    Spacer(),
                    Center(
                      child: SizedBox(
                            width: 150,
                            height: 30,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryButtonColor,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            onPressed: () async {
                              debugPrint('SelectVehicle pressed -> vehicle.id=${vehicle.id} deliveryType=${ctrl.deliveryType.value}');
                              // locally mark vehicle as selected
                              svc.selectVehicle(vehicle);

                              // Build minimal order payload
                              final deliveryType = ctrl.deliveryType.value.toUpperCase();

                              // Gather destinations if we have saved sender/receiver
                              final List<Map<String, dynamic>> destinations = [];
                              try {
                                final locCtrl = Get.find<StackedLocationController>();
                                final sender = locCtrl.senderData.value;
                                final receiver = locCtrl.receiverData.value;

                                if (sender != null) {
                                  destinations.add({
                                    'address': sender.address,
                                    'floor_unit': sender.floorUnit,
                                    'contact_name': sender.contactName,
                                    'contact_number': sender.contactNumber,
                                    'note_to_driver': sender.noteToDriver,
                                    'is_saved': sender.isSaved,
                                    'type': 'SENDER',
                                  });
                                }

                                if (receiver != null) {
                                  destinations.add({
                                    'address': receiver.address,
                                    'floor_unit': receiver.floorUnit,
                                    'contact_name': receiver.contactName,
                                    'contact_number': receiver.contactNumber,
                                    'note_to_driver': receiver.noteToDriver,
                                    'is_saved': receiver.isSaved,
                                    'type': 'RECEIVER',
                                  });
                                }
                              } catch (e) {
                                debugPrint('No location controller available: $e');
                              }

                              // If there are no destinations, proceed without them (API accepts orders without destinations)
                              if (destinations.isEmpty) {
                                debugPrint('No saved sender/receiver; proceeding to create order without destinations');
                              }

                              final payload = {
                                'route_type': 'ONE_WAY',
                                'isFixed': false,
                                'delivery_type': deliveryType,
                                'vehicle_type_id': vehicle.id,
                                'collect_time': 'ASAP',
                              };

                              // only include destinations if available
                              if (destinations.isNotEmpty) {
                                payload['destinations'] = destinations;
                              }

                              // Debug print request body
                              debugPrint('CreateOrder Request payload: $payload');

                              try {
                                EasyLoading.show(status: 'Placing order...');
                              } catch (_) {}

                              // call createOrder
                              final res = await OrderService.createOrder(payload);

                              // Debug print raw response
                              debugPrint('CreateOrder Response: $res');

                              try {
                                EasyLoading.dismiss();
                              } catch (_) {}

                              final status = res['statusCode'] as int? ?? 500;
                              final body = res['body'] as Map<String, dynamic>? ?? {};

                              debugPrint('CreateOrder Response body (full): $body');

                              // If server returned success=false, treat as failure 
                              if (body['success'] != true) {
                                final serverMsg = body['error'] ?? body['message'] ?? 'Order failed';
                                debugPrint('CreateOrder server indicated failure: $serverMsg');
                                try {
                                  EasyLoading.showError(serverMsg.toString());
                                } catch (_) {}
                                return;
                              }

                              if (status == 201) {
                                final data = body['data'];

                                debugPrint('CreateOrder Response body.data: $data');

                                Map<String, dynamic>? orderMap;
                                if (data is Map<String, dynamic>) {
                                  if (data.containsKey('order') && data['order'] is Map<String, dynamic>) {
                                    orderMap = Map<String, dynamic>.from(data['order'] as Map);
                                  } else if (data.containsKey('id') || data.containsKey('order_status') || data.containsKey('total_cost')) {
                                    // sometimes API returns the order directly inside `data` instead of `data.order`
                                    orderMap = Map<String, dynamic>.from(data);
                                  }
                                }

                                if (orderMap != null) {
                                  // show server message
                                  try { EasyLoading.showSuccess(body['message']?.toString() ?? 'Order created'); } catch (_) {}

                                  // Update StackedOrderController
                                  try {
                                    final orderCtrl = Get.find<StackedOrderController>();
                                    orderCtrl.lastOrderId = orderMap['id'] as int?;
                                    orderCtrl.totalAmount.value = double.tryParse(orderMap['total_cost']?.toString() ?? '') ?? orderCtrl.totalAmount.value;
                                  } catch (_) {
                                    // ensure it's available
                                    final oc = Get.put(StackedOrderController());
                                    try {
                                      oc.lastOrderId = orderMap['id'] as int?;
                                      oc.totalAmount.value = double.tryParse(orderMap['total_cost']?.toString() ?? '') ?? oc.totalAmount.value;
                                    } catch (_) {}
                                  }

                                  // Before navigating, sync StackedScreen controllers using order fields
                                  try {
                                    final locCtrl = Get.find<StackedLocationController>();
                                    // route_type
                                    if (orderMap['route_type'] != null) {
                                      locCtrl.isRoundTrip.value = (orderMap['route_type'] == 'ROUND');
                                    }
                                    // collect_time
                                    if (orderMap['collect_time'] != null) {
                                      locCtrl.isNowSelected.value = (orderMap['collect_time'] == 'ASAP');
                                    }
                                  } catch (_) {}

                                  try {
                                    final vehCtrl = Get.find<StackedVehicleController>();
                                    final vid = orderMap['vehicle_type_id'] is int ? orderMap['vehicle_type_id'] as int : int.tryParse(orderMap['vehicle_type_id']?.toString() ?? '');
                                    if (vid != null) {
                                      // find vehicle in loaded lists
                                      final all = <StackVehicle>[]..addAll(vehCtrl.t1)..addAll(vehCtrl.t2)..addAll(vehCtrl.t3)..addAll(vehCtrl.t4);
                                      StackVehicle? found;
                                      try {
                                        found = all.firstWhere((v) => v.id == vid);
                                      } catch (_) {
                                        found = null;
                                      }
                                      if (found != null) vehCtrl.selectedVehicle.value = found;
                                    }
                                  } catch (_) {}

                                  // Navigate to stacked screen with order data
                                  Get.toNamed(AppRoutes.getstackedScreen(), arguments: {'order': orderMap});
                                } else {
                                  debugPrint('CreateOrder: order details missing in response body');
                                  try {
                                    EasyLoading.showSuccess('Order created but no details found');
                                  } catch (_) {}
                                }
                              } else {
                                final msgRaw = body['message'] ?? 'Failed to create order';
                                final String msg;
                                if (msgRaw is List) {
                                  msg = msgRaw.join('\n');
                                } else {
                                  msg = msgRaw.toString();
                                }
                                debugPrint('CreateOrder failed: status=$status msg=$msg res=${res}');
                                try {
                                  EasyLoading.showError(msg);
                                } catch (_) {}
                              }
                            },
                              child: Text(
                                'Select Vehicle',
                                style: getTextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
