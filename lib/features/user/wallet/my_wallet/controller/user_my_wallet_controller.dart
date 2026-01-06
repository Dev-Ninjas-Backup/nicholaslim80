import 'package:ZipBee/features/user/wallet/my_wallet/model/wallet_recent_transactions_model.dart';
import 'package:get/get.dart';

class UserMyWalletController extends GetxController {
  var selectFundsOrRedeen = 0.obs;

  final RxList<WalletRecentTransactionsModel> recentTransactionList =
      <WalletRecentTransactionsModel>[].obs;

  @override
  void onInit() {
    recentTransactionItem();
    super.onInit();
  }

  void recentTransactionItem() {
    recentTransactionList.addAll([
      WalletRecentTransactionsModel(
        title: "Parcel",
        orderID: "Order ID- Al 69696",
        ammount: "+\$40.00",
      ),

      WalletRecentTransactionsModel(
        title: "Top Up",
        orderID: "Using Mastercard *456",
        ammount: "+\$20.00",
      ),
    ]);
  }
}
