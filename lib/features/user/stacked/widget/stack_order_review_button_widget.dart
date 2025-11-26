import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class StackedOrderReviwButtonStatic extends StatelessWidget {
  const StackedOrderReviwButtonStatic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 8),

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
                  'S\$00.00', // Static text
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
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey.shade400),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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

          SizedBox(width: 8),
        ],
      ),
    );
  }
}
