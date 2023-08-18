//values na meron si categories
class Department {
  String id;
  String deptName;
  String deptShname;

  Department({
    required this.id,
    required this.deptName,
    required this.deptShname,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      deptName: json['dept_name'] as String,
      deptShname: json['dept_shname'] as String,
    );
  }
}