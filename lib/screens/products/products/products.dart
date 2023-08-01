//values na meron si sub categories
class Products {
  String id;
  String name;
  String desc;
  String category_id;
  String subcategory_id;
  String image;

  Products({
    required this.id,
    required this.name,
    required this.desc,
    required this.category_id,
    required this.subcategory_id,
    required this.image});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['product_id'] as String,
      name: json['prod_name'] as String,
      desc: json['prod_desc'] as String,
      category_id: json['category_id'] as String,
      subcategory_id: json['subCategory_id'] as String,
      image: json['image'] as String,
    );
  }
}