import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


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
                              onPressed: () {
                                svc.selectVehicle(vehicle);
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
