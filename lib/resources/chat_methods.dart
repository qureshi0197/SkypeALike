import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/models/user.dart';


class ChatMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<void> updateMessageSeenStatusInDb({senderId, receiverId}) async {
    // var map = message.toMap();
    var temp;

    var messageList = await _messageCollection
          .document(senderId)
          .collection(receiverId)
          .where('seenStatus', isEqualTo: false)
          .getDocuments();
    
    // print(messageList.documents[0].documentID);
    
    temp = messageList.documents;

    for(var i=0 ; i < messageList.documents.length ; i++)
    await _messageCollection
        .document('$senderId/$receiverId/${messageList.documents[0].documentID}')
        .updateData({"seenStatus" : true});
        // .add(map);

    // addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    // return await _messageCollection
    //     .document(message.receiverId)
    //     .collection(message.senderId)
    //     .add(map);
  }
  
  // fetchUnseenMessages({
  //   @required String senderId,
  //   @required String receiverId,
  // }) =>
  // messageList = await _messageCollection
  //         .document(senderId)
  //         .collection(receiverId)
  //         .where('seenStatus', isEqualTo: false)
  //         .getDocuments();
  
  DocumentReference getContactsDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  // void setImageMsg(String url, String receiverId, String senderId) async {
  //   Message message;

  //   message = Message.imageMessage(
  //       message: "IMAGE",
  //       receiverId: receiverId,
  //       senderId: senderId,
  //       photoUrl: url,
  //       timestamp: Timestamp.now(),
  //       type: 'image',

  //       // seenStatus: false
  //       );

  //   // create imagemap
  //   var map = message.toImageMap();

  //   // var map = Map<String, dynamic>();
  //   await _messageCollection
  //       .document(message.senderId)
  //       .collection(message.receiverId)
  //       .add(map);

  //   _messageCollection
  //       .document(message.receiverId)
  //       .collection(message.senderId)
  //       .add(map);
  // }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}