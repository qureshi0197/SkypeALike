import 'package:cloud_firestore/cloud_firestore.dart';

class Contact  {
  String uid;
  Timestamp addedOn;
  String number,first_name,last_name,address,company,email;
  var avatar;

  Contact({
    this.first_name,
    this.last_name,
    this.uid,
    this.addedOn,
    // this.suffix,
    // this.familyName,
    this.company,
    this.avatar,
    this.email,
    this.number,
    this.address,
    // this.avatar,
    // this.birthday,
    // this.androidAccountType,
    // this.androidAccountTypeRaw,
    // this.androidAccountName,
  });

  initials(){
    return ((this.first_name?.isNotEmpty == true ? this.first_name[0] : "") +
            (this.last_name?.isNotEmpty == true ? this.last_name[0] : ""))
        .toUpperCase();
  }

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.addedOn = mapData["added_on"];
    this.first_name= mapData['first_name'];
    this.last_name =  mapData['last_name'];
    this.number = mapData['number'];
    this.address = mapData['address'];
    this.company = mapData['company'];
    this.email = mapData['email'];
    this.avatar = null;
  }
}