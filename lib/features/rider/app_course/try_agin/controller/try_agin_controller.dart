import 'dart:ui';

import 'package:get/get.dart';

class TryAginController extends GetxController {
  var score = '8/10'.obs;
  var message = 'Please try again'.obs;

  VoidCallback? get tryAgain => null;
}
