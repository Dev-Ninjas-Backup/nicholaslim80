import 'package:ZipBee/features/user/saved_places/add_places/controller/saved_places_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';

class AddPlaceScreen extends StatelessWidget {
  // final AddPlaceController controller = Get.put(AddPlaceController());
  final controller = Get.put(AddPlaceController());

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
              onChanged: (value) => controller.searchAddress(value),
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.suggestions.isEmpty) {
                  return Center(child: Text("No results found"));
                }

                return ListView.builder(
                  itemCount: controller.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = controller.suggestions[index];
                    return InkWell(
                      onTap: () => controller.onLocationSelected(suggestion),
                      child: Card(
                        color: Color(0XFFFFFDF5),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            suggestion['structured_formatting']?['main_text'] ??
                                "Unknown",
                            style: getTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            suggestion['description'] ?? "",
                            style: getTextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            // Use current location
          ],
        ),
      ),
    );
  }
}
