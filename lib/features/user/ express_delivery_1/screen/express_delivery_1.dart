import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/controller/express_controller_1.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/collect_time_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/express_button_widget.dart';

class ExpressDelivery1 extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());

  ExpressDelivery1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Express Delivery',
              style: getTextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4.0),
            Icon(Icons.info_outline, color: Colors.black87, size: 20),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Select Location',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Card(
              child: Column(
                children: [
                  ExpressButtonWidget(controller: controller),
                  SizedBox(height: 20),
                  Divider(),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(Icons.add),
                      label: Text("Add Step"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Collect time',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CollectTimeOption(
                    title: "Now",
                    selected: controller.isNowSelected.value,
                    onTap: controller.selectNow,
                  ),
                  const SizedBox(width: 16),
                  CollectTimeOption(
                    title: "Schedule",
                    subtitle: "Pick Date and Time",
                    selected: !controller.isNowSelected.value,
                    onTap: controller.selectSchedule,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
