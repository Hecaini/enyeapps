class userAdmin {
  final String name;
  final String contact;
  final String position;
  final String email;
  final String password;

  userAdmin({required this.name, required this.contact, required this.position, required this.email, required this.password});

  Map <String, dynamic> toJson() => {

    'name' : name,
    'contact' : contact,
    'position' : position,
    'email' : email,
    'password' : password,
  };
}

class UserLogin {
  String userId;
  String name;
  String contact;
  String username;
  String email;
  String position;
  String image;

  UserLogin({
    required this.userId,
    required this.name,
    required this.contact,
    required this.username,
    required this.email,
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
      position: json['username'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}