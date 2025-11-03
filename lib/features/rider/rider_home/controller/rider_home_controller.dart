import 'package:get/get.dart';
import 'package:nicholaslim80/features/rider/rider_home/model/home_order_model.dart'
    show HomeOrderModel;

class RiderHomeController extends GetxController {
  var orders = <HomeOrderModel>[].obs;
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    // Generate 16 sample cards. You can replace with real data.
    orders.value = List.generate(16, (i) {
      return HomeOrderModel(
        type: i % 3 == 0 ? 'Car' : (i % 3 == 1 ? 'Taxi' : 'Courier'),
        code: 'RDW${10000 + i}',
        pickup: 'Pickup Place ${i + 1}',
        delivery: 'Delivery Area ${i + 1} (${20 - i} km)',
        price: '€${10 + i}.00 - ${12 + i}.00',
        time: '${5 + i} min',
        status: 'Pending',
        buttonText: 'LEFT TO DECLINE',
        colorType: 0,
      );
    });
  }

  void acceptOrder(int index) {
    final order = orders[index];
    order.status = 'Active';
    order.buttonText = 'ACCEPTED';
    order.colorType = 1; // blue or green could be used in UI
    orders[index] = order;
  }

  void declineOrder(int index) {
    final order = orders[index];
    order.status = 'Declined';
    order.buttonText = 'DECLINED';
    order.colorType = 2; // gray/red
    orders[index] = order;
  }

  void toggleOnline(bool value) => isOnline.value = value;
}
