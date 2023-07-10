//values na meron si categories
class Manufacturer {
  String id;
  String name;

  Manufacturer({required this.id, required this.name});

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['manufacturer_id'] as String,
      name: json['mfr_name'] as String,
    );
  }
}