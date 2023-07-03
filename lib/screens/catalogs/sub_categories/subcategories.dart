//values na meron si categories
class subCategories {
  String id;
  String name;
  String category_id;

  subCategories({required this.id, required this.name, required this.category_id});

  factory subCategories.fromJson(Map<String, dynamic> json) {
    return subCategories(
      id: json['subCat_id'] as String,
      name: json['subCat_name'] as String,
      category_id: json['category_id'] as String,
    );
  }
}