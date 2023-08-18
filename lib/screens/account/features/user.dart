//values na meron si categories
class UsersInfo {
  String user_id;
  String name;
  String username;
  String contact;
  String email;
  String position;
  String image;

  UsersInfo({
    required this.user_id,
    required this.name,
    required this.username,
    required this.contact,
    required this.email,
    required this.position,
    required this.image,
  });

  factory UsersInfo.fromJson(Map<String, dynamic> json) {
    return UsersInfo(
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      contact: json['contact'] as String,
      email: json['email'] as String,
      position: json['position'] as String,
      image: json['image'] as String,
    );
  }
}