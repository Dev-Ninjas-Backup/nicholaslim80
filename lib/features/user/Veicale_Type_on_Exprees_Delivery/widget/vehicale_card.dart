import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/models/data_model.dart';

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
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Vehicle image
              Image.asset(
                (vehicle.imageAsset != null && vehicle.imageAsset!.isNotEmpty)
                    ? vehicle.imageAsset!
                    : IconPath.bike,
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
                      vehicle.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      vehicle.subtitle ?? '',
                      style: getTextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vehicle.details,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Check icon if selected
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalServiceCard extends StatelessWidget {
  final AdditionalService service;
  final bool isSelected;
  final VoidCallback onTap;

  const AdditionalServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.yellow[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? Colors.yellow : Colors.grey[300]!),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          service.name,
          style: getTextStyle(
            fontWeight: FontWeight.w500, // Medium weight
            fontSize: 14, // Adjust size as needed
            color: Colors.black87, // Change color if needed
          ),
        ),

        trailing: Text(
          '+S\$${service.price.toStringAsFixed(2)}',
          style: getTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class BottomSummary extends StatelessWidget {
  final double total;
  final bool isButtonEnabled;
  final List<String> calculationHistory;

  const BottomSummary({
    super.key,
    required this.total,
    required this.isButtonEnabled,
    required this.calculationHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Divider or shadow
        Container(height: 1, color: Colors.grey.shade300),

        /// Total + Button
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Total (incl. GST): ',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      Text(
                        'S\$${total.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Edge-to-edge button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: isButtonEnabled
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Calculation History'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: calculationHistory.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: const Icon(Icons.history),
                                        title: Text(calculationHistory[index]),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? Colors.amber
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text(
                      'Review Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
