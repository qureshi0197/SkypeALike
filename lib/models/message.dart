import 'package:cloud_firestore/cloud_firestore.dart';


class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  String timestamp;
  // String photoUrl;
  
  bool seenStatus;

// When we handle simple text
  Message({
    this.senderId, 
    this.receiverId, 
    this.type, 
    this.message, 
    this.timestamp,
    
    this.seenStatus
    });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;

    map['seenStatus'] = this.seenStatus;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    
    this.senderId = map['sender'];
    this.receiverId = map['receiver'];
    this.type = map['type'];
    this.message = map['text'];
    this.timestamp = map['timestamp'];
    // this.photoUrl = map['photoUrl'];
    
    this.seenStatus = map['seenStatus'];
  }

// When we handle image message
  // Message.imageMessage({
  //   this.senderId, 
  //   this.receiverId, 
  //   this.message, 
  //   this.type, 
  //   this.timestamp, 
  //   this.photoUrl,

  //   this.seenStatus,
  //   });

  // Map toImageMap(){
  //   var map = Map<String, dynamic>();
  //   map['senderId'] = this.senderId;
  //   map['receiverId'] = this.receiverId;
  //   map['type'] = this.type;
  //   map['message'] = this.message;
  //   map['timestamp'] = this.timestamp;
  //   map['photoUrl'] = this.photoUrl;

  //   map['seenStatus'] = this.seenStatus;
  //   return map;
  // }


}