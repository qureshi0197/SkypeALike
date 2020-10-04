class User {
  String uid = '';
  String name = '';
  String number = '';
  String email = '';
  String username = '';
  String status = '';
  String password = '';
  String profilePhoto = '';

  User({
    this.uid,
    this.name,
    this.number,
    this.email,
    this.username,
    this.password,
    this.status,
    // this.state,
    this.profilePhoto,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['number'] = user.number;
    data['email'] = user.email;
    data['username'] = user.username;
    data['password'] = user.password;
    data["status"] = user.status;
    // data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    // this
    // this.uid = mapData['uid'];
    this.name = mapData['username'];
    this.password = mapData['password'];
    // this.username = mapData['username'];
    // this.status = mapData['status'];
    // this.state = mapData['state'];
    // this.profilePhoto = mapData['profile_photo'];
  }
}
