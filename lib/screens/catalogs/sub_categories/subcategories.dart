//values na meron si sub categories
class subCategories {
  String id;
  String name;
  String category_id;
  String category_name;

  subCategories({required this.id, required this.name, required this.category_id, required this.category_name});

  factory subCategories.fromJson(Map<String, dynamic> json) {
    return subCategories(
      id: json['subCat_id'] as String,
      name: json['subCat_name'] as String,
      category_id: json['category_id'] as String,
      category_name: json['category_name'] as String,
    );
  }
}