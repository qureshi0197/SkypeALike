import 'package:flutter/material.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';

class UniversalVariables {
// GLOBAL COLORS
  List<Contact> selectedContacts = [];
  List<String> selectedContactsNumber = [];
  List selectedUserInbox = [];
  bool onLongPress = false;
  List<String> selectedMessagesIds = [];
  // bool onLongPress_chat = false;
  // bool onLongPress_contact = false;
  static String generalMessage = '';
  static List<Contact> chatList = [];
  static final Color sendMessageColor = Colors.blue[200];
  static final Color receiveMessageColor = Colors.blue[100];

  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Color(0xff19191b);
  static final Color lightGreyColor = Colors.grey.shade300;
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Color(0xff00b6f3);
  static final Color gradientColorEnd = Color(0xff0184dc);

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);

  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
