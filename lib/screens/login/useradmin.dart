class userAdmin {
  final String name;
  final String contact;
  final String email;
  final String password;
  final String department;
  final String position;

  userAdmin({
    required this.name,
    required this.contact,
    required this.email,
    required this.password,
    required this.department,
    required this.position
  });

  Map <String, dynamic> toJson() => {

    'name' : name,
    'contact' : contact,
    'email' : email,
    'password' : password,
    'department' : department,
    'position' : position,
  };
}

class UserLogin {
  String userId;
  String name;
  String contact;
  String username;
  String email;
  String department;
  String position;
  String image;

  UserLogin({
    required this.userId,
    required this.name,
    required this.contact,
    required this.username,
    required this.email,
    required this.department,
    required this.position,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["user_id"] = userId;
    user["name"] = name;
    user["contact"] = contact;
    user["username"] = username;
    user["email"] = email;
    user["department"] = department;
    user["position"] = position;
    user["image"] = image;
    return user;
  }

  static UserLogin fromJson(Map<String, dynamic> json) {
    return UserLogin(
      userId: json['user_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      department: json['department'] as String? ?? '',
      position: json['position'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}