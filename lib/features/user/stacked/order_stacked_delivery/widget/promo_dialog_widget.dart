import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class StackedPromoDialogContent extends StatelessWidget {
  final TextEditingController promoController = TextEditingController();

  StackedPromoDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: promoController,
          decoration: InputDecoration(
            hintText: "Type your code",
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        SizedBox(height: 40),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            'Apply',
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
