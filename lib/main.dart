import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nicholaslim80/app.dart';

import 'firebase_msg.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 VehicleController globally initialize
  // Get.put(VehicleController());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMsg().initFCM();
  runApp(const Nicholaslim());
}
