class User {
  String uid = '';
  String name = '';
  String number = '';
  String email = '';
  String username = '';
  String status = '';
  String password = '';
  String profilePhoto = '';
  String welcome_message = '';

  User(
      {this.uid,
      this.name,
      this.number,
      this.email,
      this.username,
      this.password,
      this.status,
      this.profilePhoto,
      this.welcome_message});

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['number'] = user.number;
    data['email'] = user.email;
    data['username'] = user.username;
    data['password'] = user.password;
    data["status"] = user.status;
    data["profile_photo"] = user.profilePhoto;
    data['welcome_message'] = user.welcome_message;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['username'];
    this.password = mapData['password'];
    this.number = mapData['number'];
    this.welcome_message = mapData['welcome_message'];
  }
}
