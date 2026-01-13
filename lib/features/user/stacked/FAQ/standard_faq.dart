import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StandardFaqScreen extends StatelessWidget {
  const StandardFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Standard Delivery',
          style: getTextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _StandardFaqTile(
                title: '1. Delivery Type',
                description:
                    'Standard delivery allows you to choose a flexible delivery time window with affordable charges.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '2. Pickup & Drop-off Addresses',
                description:
                    'Add your sender and receiver addresses. You will have the option to modify or update them before confirming.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '3. Scheduled Time Slot',
                description:
                    'Select a preferred delivery slot. Delivery will be completed within the selected time window.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '4. Charges',
                description:
                    'Standard delivery charges vary based on: • Distance • Delivery time slot • Item weight & type.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '5. Tracking',
                description:
                    'Track your package in real time. Updates will be shown once the rider picks up your item.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '6. Communication',
                description:
                    'You can chat or call the rider from inside the app once the delivery is assigned.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '7. Vehicle Type',
                description:
                    'Choose your preferred vehicle based on the package size and weight.',
              ),
              SizedBox(height: 20),

              _StandardFaqTile(
                title: '8. Cancellation',
                description:
                    'You may cancel before the rider is assigned or picked up the item (cancellation fees may apply).',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StandardFaqTile extends StatelessWidget {
  final String title;
  final String description;

  const _StandardFaqTile({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: getTextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
