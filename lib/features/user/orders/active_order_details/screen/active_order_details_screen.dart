import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';

class ActiveOrderDetailsScreen extends StatelessWidget {
  const ActiveOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              width: double.infinity,
              color: Colors.amber,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Order #1266 is pending for collection",
                    style: getTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: Text("Map View", style: getTextStyle()),
            ),

            // Details Section
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              'assets/images/profile_placeholder.png',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Christine Jason",
                                  style: getTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Vehicle type: Motorbike",
                                  style: getTextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Order 1266",
                                  style: getTextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Scheduled to your pick-up time",
                                  style: getTextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.message_outlined),
                            label: Text("Message", style: getTextStyle()),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.call_outlined),
                            label: Text("Call", style: getTextStyle()),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 6),
                          Text("5/5", style: getTextStyle()),
                          SizedBox(width: 6),
                          Text(
                            "(243 Reviews)",
                            style: getTextStyle(color: Colors.blue),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: getTextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "\$24.00",
                            style: getTextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text("VISA ****456", style: getTextStyle(fontSize: 13)),

                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Date & Time: ",
                            style: getTextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "25 August 2025 / 12:10 pm",
                            style: getTextStyle(),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      _buildStop(
                        color: Colors.blue,
                        title: "Collected from (Sender: Athena Lin)",
                        address: "Blk 657 Ang Mo Kio Ave 9, S560657",
                      ),
                      _buildStop(
                        color: Colors.red,
                        title: "Deliver to (Joseph Low)",
                        address: "Blk 222 Sengkang Ave 2, S530222",
                      ),
                      _buildStop(
                        color: Colors.red,
                        title: "Deliver to (Annie Tan)",
                        address: "Blk 447 Sengkang Ave 4, S530447",
                      ),
                      _buildStop(
                        color: Colors.red,
                        title: "Deliver to (Tony Toh)",
                        address: "Blk 244 Jurong East St 61, S600244",
                      ),

                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Share Ride Information",
                            style: getTextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStop({
    required Color color,
    required String title,
    required String address,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: getTextStyle(fontWeight: FontWeight.w600)),
                Text(address, style: getTextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
