class PlaceModel {
  final int id;
  final String name;
  final String address;

  PlaceModel({required this.id, required this.name, required this.address});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? 0,
      name: json['contact_name'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
