import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';

void showAddAmountDialog(BuildContext context, dynamic controller, dynamic paymentCtrl) {
  final TextEditingController amountController = TextEditingController();
  RxInt selectedMethod = 1.obs; // 1 for Wallet

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Amount", style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "Enter amount (Min \$5)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixText: "\$ ",
              ),
            ),
            const SizedBox(height: 20),
            
            Text("Select Payment Method", style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // Wallet Option
            Obx(() => ListTile(
              leading: Image.asset(IconPath.wallet, width: 24),
              title: const Text("Wallet"),
              subtitle: Text("\$${paymentCtrl.walletBalance.value.toStringAsFixed(2)}"),
              trailing: Radio(
                value: 1, 
                activeColor: Colors.amber,
                groupValue: selectedMethod.value, 
                onChanged: (val) => selectedMethod.value = val as int
              ),
              onTap: () => selectedMethod.value = 1,
            )),

            // Stripe Option (Inactive)
            ListTile(
              enabled: false,
              leading: Image.asset("assets/icons/stripe_icon.png", width: 24, 
                errorBuilder: (c,e,s) => const Icon(Icons.payment, color: Colors.grey)),
              title: const Text("Stripe", style: TextStyle(color: Colors.grey)),
              subtitle: const Text("Instant payment", style: TextStyle(color: Colors.grey)),
              trailing: const Radio(value: 2, groupValue: 0, onChanged: null),
            ),

            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                onPressed: () {
                  double? val = double.tryParse(amountController.text);
                  if (val != null && val >= 5) {
                    controller.addNewAmount(val);
                    EasyLoading.showSuccess('Amount Added!');
                    Get.back();
                  } else {
                    EasyLoading.showError('Minimum amount is \$5');
                  }
                },
                child: const Text("Confirm", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    ),
  );
}