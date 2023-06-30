class Categories {
  String id;
  String name;

  Categories({required this.id, required this.name});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['category_id'] as String,
      name: json['cat_name'] as String,
    );
  }
}