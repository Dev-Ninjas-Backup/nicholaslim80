class HomeOrderModel {
  String type;
  String code;
  String pickup;
  String delivery;
  String price;
  String time;
  String status; // pending, active, completed
  String buttonText;
  int colorType; // 0=yellow,1=blue,2=gray

  HomeOrderModel({
    required this.type,
    required this.code,
    required this.pickup,
    required this.delivery,
    required this.price,
    required this.time,
    required this.status,
    required this.buttonText,
    required this.colorType,
  });
}
