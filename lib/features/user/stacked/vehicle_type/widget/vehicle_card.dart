import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';

class StackedVehicleCard extends StatelessWidget {
  final StackVehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const StackedVehicleCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.amberAccent : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Vehicle image: choose icon based on API vehicle type grouping
              Image.asset(
                (() {
                  final vt = vehicle.type.toUpperCase();
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
                  } else if (vehicle.imageAsset != null && vehicle.imageAsset!.isNotEmpty) {
                    return vehicle.imageAsset!;
                  } else {
                    return IconPath.bike;
                  }
                })(),
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 12),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // format vehicle_type from API: e.g. 'ELECTRIC_SCOOTER' -> 'Electric Scooter'
                      vehicle.name.replaceAll('_', ' ').toLowerCase().split(' ').map((s) => s.isEmpty ? s : (s[0].toUpperCase() + s.substring(1))).join(' '),
                      style: getTextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (vehicle.dimension != null && vehicle.dimension!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        vehicle.dimension!,
                        style: getTextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                    if (vehicle.maxLoad != null && vehicle.maxLoad!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        'Max load: ${vehicle.maxLoad}',
                        style: getTextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      vehicle.details,
                      style: getTextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    // Pricing row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base: S\$${(vehicle.basePrice ?? vehicle.price).toStringAsFixed(0)}',
                          style: getTextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Per km: S\$${(vehicle.perKmPrice ?? 0).toStringAsFixed(2)}/km',
                          style: getTextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Check icon if selected
              if (isSelected) Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
