import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class BottomSummary extends StatelessWidget {
  final double total;
  final bool isButtonEnabled;
  final List<String> calculationHistory;

  const BottomSummary({
    super.key,
    required this.total,
    required this.isButtonEnabled,
    required this.calculationHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Divider or shadow
        Container(height: 1, color: Colors.grey.shade300),

        /// Total + Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Total (incl. GST): ',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      Text(
                        'S\$${total.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                // Edge-to-edge button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: isButtonEnabled
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Calculation History'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: calculationHistory.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Icon(Icons.history),
                                        title: Text(calculationHistory[index]),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? Colors.amber
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(),
                    ),
                    child: Text(
                      'Review Order',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
