class userAdmin {
  String name;
  String email;
  String password;

  userAdmin(this.name, this.email, this.password);

  Map <String, dynamic> toJson() => {

    'name' : name,
    'email' : email,
    'password' : password,
  };
}