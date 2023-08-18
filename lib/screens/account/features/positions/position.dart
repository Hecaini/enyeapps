//values na meron si categories
class Position {
  String id;
  String position;
  String departmentId;

  Position({
    required this.id,
    required this.position,
    required this.departmentId,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'] as String,
      position: json['position'] as String,
      departmentId: json['department_id'] as String,
    );
  }
}