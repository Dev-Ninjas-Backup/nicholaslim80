import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/user/Sechedule_veycale_type/models/vehicle_data_model.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(
          vehicle.imageAsset ?? IconPath.bike,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
        title: Text(
          vehicle.name,
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vehicle.subtitle != null)
              Text(
                vehicle.subtitle!,
                style: getTextStyle(fontSize: 12, color: Colors.grey),
              ),
            const SizedBox(height: 4),
            Text(
              vehicle.details,
              style: getTextStyle(fontSize: 12, color: Colors.grey[600]!),
            ),
          ],
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : Text(
                "S\$${vehicle.price.toStringAsFixed(0)}",
                style: getTextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final AdditionalService service;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.grey[300]!,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        title: Text(
          service.name,
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          '+ S\$${service.price.toStringAsFixed(2)}',
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
