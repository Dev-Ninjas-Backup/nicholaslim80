import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/saved_places/controller/saved_places_controller.dart';
import 'package:nicholaslim80/features/user/saved_places/name_places/screen/name_places_screen.dart';

class AddPlaceScreen extends StatelessWidget {
  final SavedPlaceController controller = Get.find();

  final List<String> dummyResults = [
    "778 Sengkang Ave 7, Singapore 530778",
    "560 Balestier Road, Singapore 329876",
  ];

  AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        title: Text('Add Place', style: getTextStyle(fontSize: 20.sp)),
        backgroundColor: AppColors.backgroungColor,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search an address',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: dummyResults.length,
                itemBuilder: (context, index) {
                  final addr = dummyResults[index];
                  return InkWell(
                    onTap: () {
                      controller.selectAddress(addr);
                      Get.to(() => NamePlaceScreen());
                    },
                    child: Card(
                      color: Color(0XFFFFFDF5),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          addr.split(',')[0],
                          style: getTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(addr, style: getTextStyle(fontSize: 12)),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.near_me_outlined, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Use my current location",
                  style: getTextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
