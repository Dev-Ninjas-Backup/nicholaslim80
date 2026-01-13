import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StackedFAQScreen extends StatelessWidget {
  const StackedFAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        title: const Text(
          'Stacked',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.backgroungColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Services Typically Not Available with Pooling
            _buildSection(
              title: '1. Services Typically Not Available with Pooling',
              items: const [
                'Multiple stops or round trips',
                'Cash on delivery (COD)',
                'Return trips',
                'Special handling (e.g., fragile or bulky items)',
                'Purchase service (driver buys item on your behalf)',
              ],
              titleColor: Colors.red,
            ),

            const SizedBox(height: 32),

            // Section 2: What Might Be Allowed
            _buildSection(
              title: '2. What Might Be Allowed',
              items: const [
                'Basic item transport (documents, parcels, small goods)',
                'Scheduled pickup time (with a flexible 2 hour window)',
                'In-app communication with driver',
                'Real-time tracking',
              ],
              titleColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required Color titleColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 16),
        // ignore: unnecessary_to_list_in_spreads
        ...items.map((item) => _buildListItem(item)).toList(),
      ],
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
