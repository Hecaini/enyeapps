//values na meron si sub categories
class CatalogsFile {
  String id;
  String name;
  String filename;

  CatalogsFile({
    required this.id,
    required this.name,
    required this.filename});

  factory CatalogsFile.fromJson(Map<String, dynamic> json) {
    return CatalogsFile(
      id: json['filecatalog_id'] as String,
      name: json['filecatalog_name'] as String,
      filename: json['filecatalog_pdf'] as String,
    );
  }
}