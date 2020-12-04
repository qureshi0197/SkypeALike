// import 'package:cloud_firestore/cloud_firestore.dart';

class Contact  {
  String uid;
  // Timestamp addedOn;
  String number,first_name,last_name,address,company,email,message;
  var avatar;
  int id;
  String status;

  Contact({
    this.id,
    // this.message,
    this.first_name,
    this.last_name,
    this.email,
    this.number,
    this.address,
    this.company,
    this.status
    // this.uid,
    // this.addedOn,
    // this.suffix,
    // this.familyName,
    
    // this.avatar,
    
    // this.avatar,
    // this.birthday,
    // this.androidAccountType,
    // this.androidAccountTypeRaw,
    // this.androidAccountName,
  });

  initials(){
    if(this.first_name.isNotEmpty || this.last_name.isNotEmpty)
      return ((this.first_name?.isNotEmpty == true ? this.first_name[0] : "") +
            (this.last_name?.isNotEmpty == true ? this.last_name[0] : ""))
        .toUpperCase();
    // else if(this.first_name.isEmpty && this.last_name.isEmpty){
      return ''; 
      // ((this.number?.isNotEmpty == true ? this.number[0]+this.number[1]+this.number[2] : ""));
    // }
    // else{
    //   return "";
    // }
  }

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    // data['contact_id'] = contact.uid;
    // data['added_on'] = contact.addedOn;

    data['id'] = contact.id;
    data['first_name'] = contact.first_name;
    data['last_name'] = contact.last_name;
    data['number'] = contact.number;
    data['address'] = contact.address;
    data['company'] = contact.company;
    data['email'] = contact.email;
    data['status'] = contact.status;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    
    // this.uid = mapData['contact_id'];
    // this.addedOn = mapData["added_on"];
    
    this.id = mapData['id'];
    this.message = mapData['message'];
    this.first_name= mapData['first_name'];
    this.last_name =  mapData['last_name'];
    this.number = mapData['number'];
    this.address = mapData['address'];
    this.company = mapData['company'];
    this.email = mapData['email'];
    if(mapData.containsKey('status')){
      this.status = mapData['status'];
    }
    else{
      this.status = 'active';
    }
    this.avatar = null;
  }
}