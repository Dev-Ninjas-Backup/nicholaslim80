// import 'package:ZipBee/core/common/styles/global_text_style.dart';
// import 'package:ZipBee/core/utils/constants/app_colors.dart';
// import 'package:ZipBee/features/user/Express_Delivary_Faq/widget/express_faq_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';



// class ExpressFaq extends StatelessWidget {
//   const ExpressFaq({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroungColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Get.back(),
//         ),
//         centerTitle: true,
//         title: Text(
//           'Express Delivery',
//           style: getTextStyle(
//             fontSize: 20,
//             color: Colors.black87,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ExpressFaqWidget(
//                 title: '1.  One way or Round',
//                 description:
//                     'One way: Delivery from point A to point B. Round trip: Delivery and return to the original  location.',
//               ),
//               SizedBox(height: 20),
//               ExpressFaqWidget(
//                 title: '2. Addresses',
//                 description:
//                     'Sender Address: Enter the pickup location Receive Address: Enter the destination',
//               ),
//               SizedBox(height: 20),
//               ExpressFaqWidget(
//                 title: '3. Route Preference',
//                 description:
//                     'Fixed route: Choose this if you want deliveries to follow a specific order. Optimized route: Let the rider choose the most efficient route based on the traffic and stops.',
//               ),
//               SizedBox(height: 20),
//               ExpressFaqWidget(
//                 title: '4. Add Stops',
//                 description: 'Include additional delivery stops if needed.',
//               ),
//               SizedBox(height: 20),
//               ExpressFaqWidget(
//                 title: '5. Delivery Speed',
//                 description:
//                     'Express: Pickup within 10-20 minutes, delivery  within 1-2 hours (depending on the traffic and  number of stops).',
//               ),
//               SizedBox(height: 20),
//               ExpressFaqWidget(
//                 title: '6. Scheduled',
//                 description:
//                     'Choose a specific date and time for pickup and  delivery',
//               ),
//               SizedBox(height: 20),
//               ExpressFaqWidget(
//                 title: '7. Vehicle Type',
//                 description:
//                     'Select your preferred vehicle Click Back to confirm your last selection',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
