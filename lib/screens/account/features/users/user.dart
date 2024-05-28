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
  String signImg;

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
    required this.signImg,
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
      signImg: json['signature_img'] as String,
    );
  }
}

class EngUsers {
  String id;
  String empNo;
  String firstname;
  String lastname;
  String username;
  String email;
  String mobile;
  String landline;
  String roleType;
  String picture;
  String signature;

  EngUsers({
    required this.id,
    required this.empNo,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.mobile,
    required this.landline,
    required this.roleType,
    required this.picture,
    required this.signature,
  });

  factory EngUsers.fromJson(Map<String, dynamic> json) {
    return EngUsers(
      id: json['id'] as String? ?? '',
      empNo: json['emp_id_no'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      landline: json['landline'] as String? ?? '',
      roleType: json['role_type'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
    );
  }
}