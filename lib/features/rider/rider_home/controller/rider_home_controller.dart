import 'package:get/get.dart';
import 'package:nicholaslim80/features/rider/rider_home/model/home_order_model.dart';

class RiderHomeController extends GetxController {
  var orders = <HomeOrderModel>[].obs;
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    orders.value = [
      HomeOrderModel(
        type: "Car",
        code: "RDW13456",
        pickup: "Portugal",
        delivery: "Eritrea (27 km)",
        price: "€14.00 - 18.00",
        time: "13 min",
        status: "Pending",
        buttonText: "LIFT TO RECEIVE",
        colorType: 0,
      ),
      HomeOrderModel(
        type: "Taxi",
        code: "CLD4839",
        pickup: "Portugal",
        delivery: "Eritrea (21 km)",
        price: "€11.00 - 13.00",
        time: "9 min",
        status: "Ongoing",
        buttonText: "IN PROGRESS",
        colorType: 2,
      ),
      HomeOrderModel(
        type: "Courier",
        code: "STD4350",
        pickup: "Portugal",
        delivery: "Eritrea (19 km)",
        price: "€12.00 - 15.00",
        time: "10 min",
        status: "Active",
        buttonText: "START RIDE",
        colorType: 1,
      ),
    ];
  }

  void updateOrderStatus(int index) {
    var order = orders[index];
    if (order.colorType == 0) {
      order.colorType = 1;
      order.buttonText = "START RIDE";
      order.status = "Active";
    } else if (order.colorType == 1) {
      order.colorType = 2;
      order.buttonText = "COMPLETED";
      order.status = "Completed";
    } else {
      return;
    }
    orders[index] = order;
  }

  void toggleOnline(bool value) => isOnline.value = value;
}
