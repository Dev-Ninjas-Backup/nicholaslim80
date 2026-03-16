// import 'package:ZipBee/core/common/styles/global_text_style.dart';
// import 'package:ZipBee/core/utils/constants/icon_path.dart';
// import 'package:ZipBee/features/kamrul_express/controller/kamrul_express_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


// final controller = Get.find<KamrulExpressController>();

// Widget locationCard() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//     ),
//     child: Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Image.asset(IconPath.exparess, height: 20, width: 20),
//               SizedBox(width: 6),
//               Text(
//                 "Fixed route",
//                 style: getTextStyle(fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),

//           Row(
//             children: [
//               Image.asset(IconPath.locationBlue, height: 20, width: 20),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   "Collected from (Sender: ${controller.senderName.value})",
//                   style: getTextStyle(fontSize: 14),
//                 ),
//               ),
//               Icon(Icons.edit, size: 20),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 28),
//             child: Text(
//               "Sender Address",
//               style: getTextStyle(fontSize: 12, color: Colors.black45),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 6),
//             child: Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey),
//           ),
//           SizedBox(height: 6),

//           Padding(
//             padding: EdgeInsets.only(left: 6),
//             child: Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey),
//           ),
//           SizedBox(height: 6),

//           // Recipient
//           Row(
//             children: [
//               Image.asset(IconPath.locationRed, height: 20, width: 20),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   "Deliver to (Recipient: ${controller.receiverName.value})",
//                   style: getTextStyle(fontSize: 14),
//                 ),
//               ),
//               Icon(Icons.edit, size: 20),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 28),
//             child: Text(
//               "Receive address",
//               style: getTextStyle(fontSize: 12, color: Colors.black45),
//             ),
//           ),

//           SizedBox(height: 16),
//           Divider(),
//           SizedBox(height: 8),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.add, size: 18),
//               SizedBox(width: 6),
//               Text(
//                 "Add Stop",
//                 style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
