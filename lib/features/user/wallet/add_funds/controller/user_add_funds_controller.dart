import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UserAddFundsController extends GetxController {
  final List<double> presetAmounts = [10, 20, 40, 100];

  final RxInt selectedIndex = 1.obs;

  final TextEditingController customAmountController = TextEditingController();
  final RxDouble selectedAmount = 20.0.obs;

  final RxBool isStripeSelected = true.obs;

  bool get isAddButtonEnabled =>
      selectedAmount.value > 0 && isStripeSelected.value;

  void onPresetTap(int index) {
    selectedIndex.value = index;
    customAmountController.clear();
    selectedAmount.value = presetAmounts[index];
  }

  void onCustomAmountChanged(String value) {
    selectedIndex.value = -1;
    double amount = double.tryParse(value) ?? 0;
    selectedAmount.value = amount;
  }

  void onToggleStripe() {
    isStripeSelected.toggle();
  }

  void onAddFunds() {
    if (!isAddButtonEnabled) return;

    EasyLoading.showSuccess('S\$${selectedAmount.value.toStringAsFixed(2)} added to your wallet.');
  }

  @override
  void onClose() {
    customAmountController.dispose();
    super.onClose();
  }
}
