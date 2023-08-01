class userAdmin {
  final String name;
  final String email;
  final String password;

  userAdmin({required this.name,required this.email,required this.password});

  Map <String, dynamic> toJson() => {

    'name' : name,
    'email' : email,
    'password' : password,
  };
}

class UserLogin {
  final String user_id;
  final String name;
  final String username;
  final String email;
  final String position;
  final String image;

  UserLogin({required this.user_id, required this.name, required this.username, required this.email, required this.position, required this.image});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = Map<String, dynamic>();
    user["user_id"] = this.user_id;
    user["name"] = this.name;
    user["username"] = this.username;
    user["email"] = this.email;
    user["username"] = this.position;
    user["email"] = this.image;
    return user;
  }
}