//values na meron si sub categories
class Catalogs {
  String id;
  String model_name;
  String sized;
  String sale_price;
  String category_id;
  String subCat_id;
  String products_id;
  String manufacturer_id;

  Catalogs({
    required this.id,
    required this.model_name,
    required this.sized,
    required this.sale_price,
    required this.category_id,
    required this.subCat_id,
    required this.products_id,
    required this.manufacturer_id,
  });

  factory Catalogs.fromJson(Map<String, dynamic> json) {
    return Catalogs(
      id: json['catalog_id'] as String,
      model_name: json['model_name'] as String,
      sized: json['sized'] as String,
      sale_price: json['sale_price'] as String,
      category_id: json['category_id'] as String,
      subCat_id: json['subCat_id'] as String,
      products_id: json['products_id'] as String,
      manufacturer_id: json['manufacturer_id'] as String,
    );
  }
}