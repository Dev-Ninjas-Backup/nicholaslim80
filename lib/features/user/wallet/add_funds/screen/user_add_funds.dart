import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/common/widgets/custom_app_bar_user.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/wallet/add_funds/controller/user_add_funds_controller.dart';

class UserAddFunds extends StatelessWidget {
  final controller = Get.put(UserAddFundsController());
  UserAddFunds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBarUser(title: "Add Funds"),
            SizedBox(height: 20),

            Text(
              "How much do you want to add?",
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.subtitleFontColor,
              ),
            ),
            SizedBox(height: 12),

            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.ammount.length,
                separatorBuilder: (_, __) =>
                    SizedBox(width: 30), // equal space between
                itemBuilder: (_, index) {
       // final isSelected = controller.selectedIndex.value == index;
                  final item = controller.ammount[index];
                  return GestureDetector(

                  onTap: (){
                  
                //  controller.selectAmount=controller.ammount.value.length;
                  
                  },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryButtonColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5D5D5D).withValues(alpha: .14),
                            blurRadius: 7,
                            spreadRadius: -1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item,
                          style: getTextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // SizedBox(
            // height: 50,
            //   child: ListView.builder(

            //     // shrinkWrap: true,
            //     // padding: EdgeInsets.zero,
            //     // physics: NeverScrollableScrollPhysics(),
            //     scrollDirection: Axis.horizontal,

            //     itemCount: controller.ammount.length,
            //     itemBuilder: (_, index) {
            //       final item = controller.ammount[index];
            //       return Container(
            //         margin: EdgeInsets.only(right: 12),
            //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            //         decoration: BoxDecoration(
            //           color: AppColors.primaryButtonColor,
            //           borderRadius: BorderRadius.circular(6),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Color(0xFF5D5D5D).withValues(alpha: .14),
            //               blurRadius: 7,
            //               spreadRadius: -1,
            //               offset: Offset(0, 1),
            //             ),
            //           ],
            //         ),
            //         child: Center(
            //           child: Text(
            //             item,
            //             style: getTextStyle(fontWeight: FontWeight.w500),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
