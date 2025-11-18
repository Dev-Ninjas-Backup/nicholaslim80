import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

class PaymentOption {
  final String title;
  final String subtitle;
  final String? icon;
  final String? imageAsset;

  PaymentOption({
    required this.title,
    required this.subtitle,
    this.icon,
    this.imageAsset,
  });
}

class PaymentSelectionWidget extends StatefulWidget {
  final List<PaymentOption> options;
  final void Function(int selectedIndex)? onChanged;

  const PaymentSelectionWidget({
    super.key,
    required this.options,
    this.onChanged,
  });

  @override
  State<PaymentSelectionWidget> createState() => _PaymentSelectionWidgetState();
}

class _PaymentSelectionWidgetState extends State<PaymentSelectionWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.asMap().entries.map((entry) {
        int index = entry.key;
        PaymentOption option = entry.value;

        return Column(
          children: [
            ListTile(
              leading: option.imageAsset != null
                  ? Image.asset(option.imageAsset!, width: 32, height: 32)
                  : Image.asset(IconPath.arrowBackIcon),
              title: Text(
                option.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                option.subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                  widget.onChanged?.call(index);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedIndex == index
                          ? Colors.yellow
                          : Colors.black,
                      width: 2,
                    ),
                  ),
                  child: selectedIndex == index
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              onTap: () {
                setState(() => selectedIndex = index);
                widget.onChanged?.call(index);
              },
            ),
            if (index != widget.options.length - 1) Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }
}

// -------------------
// Selector Button Widget
// -------------------
class PaymentMethodSelector extends StatefulWidget {
  final List<PaymentOption> options;

  const PaymentMethodSelector({super.key, required this.options});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String selectedTitle = "Select";

  void openSelectorSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: PaymentSelectionWidget(
          options: widget.options,
          onChanged: (index) {
            setState(() {
              selectedTitle = widget.options[index].title;
            });

            Get.back(); // close sheet
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openSelectorSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              selectedTitle,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
