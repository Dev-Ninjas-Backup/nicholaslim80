import 'package:ZipBee/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_msg.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 VehicleController globally initialize
  // Get.put(VehicleController());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMsg().initFCM();
  runApp(Nicholaslim());
}
