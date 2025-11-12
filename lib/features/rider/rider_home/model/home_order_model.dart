class HomeOrderModel {
  String type;
  String code;
  String pickup;
  String delivery;
  String price;
  String time;
  String status;
  String buttonText;
  int colorType;

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
