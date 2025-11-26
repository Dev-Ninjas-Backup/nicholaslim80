import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class StackedOrderReviewButtonStatic extends StatelessWidget {
  final VoidCallback onPressed;

  const StackedOrderReviewButtonStatic({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total (incl. GST):',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                Text(
                  'S\$00.00',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          FilledButton(
            onPressed: onPressed, // <-- USE CALLBACK HERE
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.amber),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            child: Text(
              'Review Order',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
