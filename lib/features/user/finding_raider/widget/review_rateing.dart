import 'package:flutter/material.dart';

class ReviewRating extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingSelected;
  final double size;

  const ReviewRating({
    super.key,
    this.initialRating = 0,
    required this.onRatingSelected,
    this.size = 24,
  });

  @override
  State<ReviewRating> createState() => _ReviewRatingState();
}

class _ReviewRatingState extends State<ReviewRating> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isSelected = index < rating;

        return GestureDetector(
          onTap: () {
            setState(() => rating = index + 1);
            widget.onRatingSelected(rating);
          },
          child: Icon(
            Icons.star,
            size: widget.size,
            color: isSelected ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }
}
