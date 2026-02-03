import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/saved_places/add_places/screen/add_place_screen.dart';
import 'package:ZipBee/features/user/saved_places/controller/saved_places_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class SavedPlaceScreen extends StatelessWidget {
  final SavedPlaceController controller = Get.put(SavedPlaceController());

  SavedPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        title: Text(
          'Saved Place',
          style: getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.backgroungColor,
        elevation: 1,
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            final places = controller.savedPlaces;
            final loading = controller.isLoading.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add to make your booking smoother",
                  style: getTextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchPlaces,
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            children: [
                              if (places.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: Text(
                                      'No saved places yet',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ...places.map(
                                (p) => Card(
                                  color: Color(0XFFFFFDF5),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      p.name,
                                      style:
                                          getTextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      p.address,
                                      style: getTextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.add, color: Colors.amber),
                                  title: Text(
                                    "Add Place",
                                    style: getTextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () => Get.to(() => AddPlaceScreen()),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
