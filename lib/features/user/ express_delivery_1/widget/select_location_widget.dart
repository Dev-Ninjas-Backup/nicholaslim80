import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/controller/express_controller_1.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/express_button_widget.dart';

class SelectLocationWidget extends StatelessWidget {
  const SelectLocationWidget({super.key, required this.controller});

  final LocationController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ExpressButtonWidget(controller: controller),
          SizedBox(height: 10),
          Divider(),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.black,

                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.add),
              label: Text(
                "Add Stop",
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
