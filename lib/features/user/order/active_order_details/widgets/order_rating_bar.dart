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
        for (int i = 1; i <= 5; i++)
          Icon(i <= rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 24),
        const SizedBox(width: 8),
        Text("${rating.toStringAsFixed(0)}/5", style: getTextStyle(fontSize: 14)),
        const Spacer(),
        Text('($totalReviews Reviews)', style: getTextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}