import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/common/widgets/custom_button.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/saved_places/controller/saved_places_controller.dart';
import 'package:nicholaslim80/features/user/saved_places/screen/saved_place_screenn.dart';

class NamePlaceScreen extends StatelessWidget {
  final SavedPlaceController controller = Get.find();
  final TextEditingController nameController = TextEditingController();

  NamePlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final address = controller.selectedAddress.value;

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        title: Text('Name this Place', style: getTextStyle(fontSize: 20.sp)),
        backgroundColor: AppColors.backgroungColor,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.favorite_border),
                hintText: 'Name this place',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.amber),
              title: Text(
                address.split(',')[0],
                style: getTextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(address, style: getTextStyle(fontSize: 12)),
            ),
            Spacer(),
            CustomButton(
              label: 'Save Place',
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  controller.addNewPlace(nameController.text.trim());
                  Get.offAll(() => SavedPlaceScreen());
                }
              },
              color: AppColors.primaryButtonColor,
              textColor: AppColors.primaryFontColor,
            ),
          ],
        ),
      ),
    );
  }
}
