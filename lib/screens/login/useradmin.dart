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
  String empIdNo;
  String name;
  String contact;
  String username;
  String email;
  String position;
  String status;
  String image;
  String signature;

  UserLogin({
    required this.userId,
    required this.empIdNo,
    required this.name,
    required this.contact,
    required this.username,
    required this.email,
    required this.position,
    required this.status,
    required this.image,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["user_id"] = userId;
    user["emp_id_no"] = empIdNo;
    user["name"] = name;
    user["contact"] = contact;
    user["username"] = username;
    user["email"] = email;
    user["position"] = position;
    user["status"] = status;
    user["image"] = image;
    user["signature"] = signature;
    return user;
  }

  static UserLogin fromJson(Map<String, dynamic> json) {
    return UserLogin(
      userId: json['user_id'] as String? ?? '',
      empIdNo: json['emp_id_no'] as String? ?? '',
      name: json['name'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      position: json['position'] as String? ?? '',
      status: json['status'] as String? ?? '',
      image: json['image'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
    );
  }
}