import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/common/widgets/custom_button.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/saved_places/controller/saved_places_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class NamePlaceScreen extends StatelessWidget {
  NamePlaceScreen({super.key});

  final SavedPlaceController controller = Get.find<SavedPlaceController>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        title: Text(
          'Name this Place',
          style: getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.backgroungColor,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Place Name Input
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.favorite_border),
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

            Obx(() {
              final address = controller.selectedAddress.value;

              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.amber),
                title: Text(
                  address.isNotEmpty
                      ? address.split(',').first
                      : 'No address selected',
                  style: getTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  address.isNotEmpty ? address : '',
                  style: getTextStyle(fontSize: 12),
                ),
              );
            }),

            const Spacer(),

            CustomButton(
              label: 'Save Place',
              color: AppColors.primaryButtonColor,
              textColor: AppColors.primaryFontColor,
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final name = nameController.text.trim();

                if (name.isEmpty) {
                  EasyLoading.showError('Enter place name');
                  return;
                }

                if (controller.selectedAddress.value.isEmpty) {
                  EasyLoading.showError('Address not selected');
                  return;
                }

                await controller.savePlace(name);
              },
            ),

            SizedBox(height: 90.h),
          ],
        ),
      ),
    );
  }
}
