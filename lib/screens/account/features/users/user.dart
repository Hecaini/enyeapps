//values na meron si categories
class UsersInfo {
  String user_id;
  String name;
  String username;
  String contact;
  String email;
  String department;
  String position;
  String status;
  String image;

  UsersInfo({
    required this.user_id,
    required this.name,
    required this.username,
    required this.contact,
    required this.email,
    required this.department,
    required this.position,
    required this.status,
    required this.image,
  });

  factory UsersInfo.fromJson(Map<String, dynamic> json) {
    return UsersInfo(
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      contact: json['contact'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      position: json['position'] as String,
      status: json['status'] as String,
      image: json['image'] as String,
    );
  }
}