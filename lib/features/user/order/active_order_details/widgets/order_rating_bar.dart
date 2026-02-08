import 'package:flutter/material.dart';
import '../../../../../../core/common/styles/global_text_style.dart';

class OrderRatingBar extends StatelessWidget {
  final double rating;
  final int totalReviews;

  const OrderRatingBar({super.key, required this.rating, required this.totalReviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ৫টি স্টার জেনারেট করা
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
        const SizedBox(width: 8),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : "0.0", 
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          '($totalReviews Reviews)',
          style: getTextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}