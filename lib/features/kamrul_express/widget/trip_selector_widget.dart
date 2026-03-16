// import 'package:ZipBee/core/common/styles/global_text_style.dart';
// import 'package:ZipBee/core/utils/constants/app_colors.dart';
// import 'package:ZipBee/features/kamrul_express/controller/kamrul_express_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


// final controller = Get.find<KamrulExpressController>();

// Widget tripSelector() {
//   return Obx(
//     () => Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () => controller.toggleTrip(false),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: controller.isRoundTrip.value
//                     ? Colors.white
//                     : AppColors.onboardingIndicatorActive,
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 "One way",
//                 style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => controller.toggleTrip(true),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: controller.isRoundTrip.value
//                     ? AppColors.onboardingIndicatorActive
//                     : Colors.white,
//                 borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 "Round",
//                 style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
