import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class OrderReviewWidget extends StatelessWidget {
  final double total;
  final bool isButtonEnabled;
  final VoidCallback? onReview;

  const OrderReviewWidget({
    super.key,
    this.total = 0.00, // 👈 DEFAULT VALUE
    this.isButtonEnabled = false, // 👈 DEFAULT VALUE
    this.onReview, // nullable
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total (incl. GST)',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),

              Text(
                'S\$${total.toStringAsFixed(2)}', // 👈 always safe
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          Flexible(
            child: FilledButton(
              onPressed: isButtonEnabled ? onReview : null,
              style: FilledButton.styleFrom(
                backgroundColor: isButtonEnabled
                    ? Colors.black
                    : CupertinoColors.inactiveGray,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Review order',
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
