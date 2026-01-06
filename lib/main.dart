import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nicholaslim80/app.dart';

void main() {
  runApp(const Nicholaslim());
  WidgetsFlutterBinding.ensureInitialized();
  _configEasyLoading();
  runApp(const Nicholaslim());
}

void _configEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.black.withValues(alpha: .5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
