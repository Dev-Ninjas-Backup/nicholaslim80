import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Icon? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key, // <-- super parameter
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
