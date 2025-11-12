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
    // Generate 16 sample cards (you can replace with real API data)
    orders.value = List.generate(16, (i) {
      String type;
      if (i % 3 == 0) {
        type = 'Car';
      } else if (i % 3 == 1) {
        type = 'Taxi';
      } else {
        type = 'Courier';
      }

      return HomeOrderModel(
        type: type,
        code: 'REXPRESS',
        pickup: 'Punggol',
        delivery: 'Bishan${i + 1} (${20 - i} km)',
        price: '€${10 + i}.00 - ${12 + i}.00',
        time: '(${20 - i} km) ${5 + i} min',
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
    order.colorType = 1; // accepted color
    orders[index] = order;
  }

  void declineOrder(int index) {
    final order = orders[index];
    order.status = 'Declined';
    order.buttonText = 'DECLINED';
    order.colorType = 2; // declined color
    orders[index] = order;
  }

  void toggleOnline(bool value) => isOnline.value = value;
}
