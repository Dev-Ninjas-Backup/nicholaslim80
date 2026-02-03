import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controller/controller.dart';
import '../widget/address_list_widget.dart';
import '../widget/build_filter_chips.dart';

class StackedCollectFormScreen extends StatefulWidget {
  final StackedCollectFormController controller;
  final String? addressType; // 'SENDER' or 'RECEIVER'

  const StackedCollectFormScreen({
    super.key,
    required this.controller,
    this.addressType,
  });

  @override
  State<StackedCollectFormScreen> createState() => _StackedCollectFormScreenState();
}

class _StackedCollectFormScreenState extends State<StackedCollectFormScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize controller with address type filter only once
    widget.controller.initializeWithAddressType(widget.addressType);
  }

  String get appBarTitle {
    // If addressType is provided, use it to determine title
    if (widget.addressType == 'RECEIVER') {
      return "Deliver To";
    }
    // Default to "Collect From" for SENDER or when not specified
    return "Collect From";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: getTextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 12),
            StackedFilterChipsWidget(controller: widget.controller),
            SizedBox(height: 20),
            Expanded(
              child: StackedAddressListWidget(
                controller: widget.controller,
                addressType: widget.addressType,
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  // Used for CustomButton 'Add' action. Don't Delete. 
  void _navigateToAddScreen(String type) {
    // This will be handled in address_list_widget by checking type
    if (type == 'RECEIVER') {
      // Navigate to recipient schedule screen
      Get.to(() {
        // Import required
        return Container(); // Placeholder
      });
    } else {
      // Navigate to sender schedule screen
      Get.to(() {
        return Container(); // Placeholder
      });
    }
  }
}
