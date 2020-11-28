import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/page_views/widgets/contact_view.dart';
import 'package:skypealike/page_views/widgets/floating_action_button.dart';
import 'package:skypealike/page_views/widgets/new_chat_button.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/utils/utilities.dart';
import 'package:skypealike/widgets/appbar.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  // var inbox;
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var loading = true;

  UniversalVariables uVariables = UniversalVariables();

  DatabaseHelper databaseHelper = DatabaseHelper();

  var usersInbox = [];

  List<Message> messageList = [];

  // List<Contact> contacts;

  var contacts;

  String date;

  DateTime time;

  @override
  void initState() {
    // TODO: implement initState
    _getAllDbContacts();
    // _getLastfetchTime();
  }

  _getAllDbContacts() async {
    contacts = await databaseHelper.getContacts();
    if (contacts.isEmpty) {
      contacts = await httpService.getAllContacts(null);
    }

    if (contacts != null && contacts != 401) {
      for (Contact contact in contacts) {
        Future<bool> condition = databaseHelper.contactExists(contact);
        condition.then((bool onValue) {
          if (!onValue) {
            databaseHelper.createContact(contact);
          }
        });
      }
    } else {
      contacts = [];
    }
    setState(() {
      loading = false;
    });
  }

  _convertTimeToTimeStamp(time) {
    // int timestamp;
    // time = "Thu, 24 Sep 2020 05:51:09 GMT";
    final formatter = DateFormat(r'''EEE, dd MMM yyyy hh:mm:ss''');
    // print(DateTime.);
    var val = (formatter.parse(time, true));
    // print(val);
    val = (val.toLocal());
    return val.millisecondsSinceEpoch;
  }

  _arrangeAllMessagesForInbox(List<Message> messagesList) {
    Map otherUserData = {};
    List otherUserKeys = [];
    // String name;
    usersInbox = [];
    // if (data.containsKey('data')) {
    //   Map val = data['data'];
    for (Message mesg in messagesList) {
      // print(mesg.status);
      if (mesg.status == 'deleted') {
        continue;
      }
      if (mesg.direction == "outbound") {
        if (!otherUserKeys.contains(mesg.receiver))
          otherUserKeys.add(mesg.receiver);
        otherUserData[mesg.receiver] = mesg;
      } else {
        if (!otherUserKeys.contains(mesg.sender)) otherUserKeys.add(mesg);
        otherUserData[mesg.sender] = mesg;
      }
    }
    // print(otherUserData);

    otherUserData.forEach((key, value) async {
      String name = '';
      String first_name = '', last_name = '';

      for (Contact item in contacts) {
        if (item.number == key) {
          first_name = item.first_name;
          last_name = item.last_name;
        }
      }

      usersInbox.add({
        "first_name": first_name,
        "last_name": last_name,
        "number": key,
        "message": value
      });
    });

    usersInbox.sort((a, b) {
      // print(a['message'].timestamp);
      var aTime = _convertTimeToTimeStamp(a['message'].timestamp);
      var bTime = _convertTimeToTimeStamp(b['message'].timestamp);
      return aTime.compareTo(bTime);
    });
    usersInbox = usersInbox.reversed.toList();

    return usersInbox;
    // else {
    //     return [];
    // }
    // return [];
  }

  _getLastfetchTime() async {
    date = await sharedPreference.getLastMesgFetchedTimeStamp();
    time = Utils.convertStringToDateTime(date);
    setState(() {});
  }

  Stream getPeriodicStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) async {
      // print(await httpService.getAllMessages(null));
      return await httpService.getAllMessages(null);
    }).asyncMap(
      (value) async => await value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: customAppBar(context),
      floatingActionButton: uVariables.onLongPress
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                uVariables.onLongPress
                    ? CustomFloatingActionButton(
                        onPressed: () {
                          if (Utils.selectAll(
                              usersInbox, uVariables.selectedContactsNumber)) {
                            uVariables.selectedContactsNumber = [];
                            uVariables.onLongPress = false;
                          } else {
                            uVariables.onLongPress = true;
                            for (var message in usersInbox) {
                              if (!uVariables.selectedContactsNumber
                                  .contains(message['number']))
                                uVariables.selectedContactsNumber
                                    .add(message['number']);
                            }
                          }
                          setState(() {});
                        },
                        icon: Utils.selectAll(
                                usersInbox, uVariables.selectedContactsNumber)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                CustomFloatingActionButton(
                  onPressed: () async {
                    for (String number in uVariables.selectedContactsNumber) {
                      await databaseHelper.deleteChat(number).then((value) {
                        setState(() {});
                      });
                      Fluttertoast.showToast(msg: 'Chat Deleted Successfully');
                    }
                    setState(() {});

                    uVariables.selectedContactsNumber = [];
                    uVariables.onLongPress = false;
                  },
                  icon: Icons.delete,
                ),
              ],
            )
          : NewChatButton(),
      body: StreamBuilder(
          stream: getPeriodicStream(),
          builder: (context, snapshot) {
            if (loading) {
              return Center(child: CircularProgressIndicator());
            }

            // time = DateTime.now();

            if (snapshot.data == 401) {
              Fluttertoast.showToast(msg: "Session Expired");
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login_screen', (Route route) => false);
              sharedPreference.logout();
            }

            Future databaseMessages;

            if (snapshot.data != null && snapshot.data != 401)
              for (var message in snapshot.data) {
                Future<bool> condition = databaseHelper.searchMessages(message);
                condition.then((bool onValue) {
                  if (!onValue) {
                    databaseHelper.createMessage(message);
                  }
                });
              }

            // databaseMessages = databaseHelper.getMessages();
            // usersInbox = _arrangeAllMessagesForInbox(snapshot.data);

            return FutureBuilder(
              future: databaseHelper.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState.index == 1 &&
                    messageList.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data != null) {
                  messageList = snapshot.data;
                } else {
                  messageList = [];
                }

                usersInbox = _arrangeAllMessagesForInbox(messageList);

                return chatListContainer();
              },
            );
          }),
    );
  }

  chatListContainer() {
    return Container(
        child: usersInbox.isEmpty
            ? Center(
                child:
                    // CircularProgressIndicator(),
                    Text('No Messages'),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: usersInbox.length,
                itemBuilder: (context, index) {
                  var contactInbox = {
                    "first_name": usersInbox[index]['first_name'],
                    "last_name": usersInbox[index]['last_name'],
                    "number": usersInbox[index]['number'],
                    "message": usersInbox[index]['message'].text
                  };
                  Contact contact = Contact.fromMap(contactInbox);
                  // Message = Message.fromMap(map)
                  return contactView(
                    contact: contact,
                    index: index,
                  );
                },
              ));
  }

  contactView({Contact contact, int index}) {
    return ListTile(
      // tileColor: UniversalVariables.onLongPress &&
      //         uVariables.selectedContactsNumber.contains(contact.number)
      //     ? Colors.grey
      //     : Colors.white,
      contentPadding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      onTap: () async {
        if (uVariables.onLongPress) {
          if (!uVariables.selectedContactsNumber.contains(contact.number)) {
            uVariables.selectedContactsNumber.add(contact.number);
          } else {
            uVariables.selectedContactsNumber.remove(contact.number);
          }
          if (uVariables.selectedContactsNumber.isEmpty) {
            uVariables.onLongPress = false;
          }
        } else {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        receiver: contact,
                      )));
        }
        setState(() {});
      },
      title: Text(
        Utils.checkNames(contact),
        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(
        contact.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
          backgroundColor: Utils.isSelectedTile(contact, uVariables.onLongPress,
                  uVariables.selectedContactsNumber)
              ? Colors.grey
              : UniversalVariables.blueColor,
          child: Utils.isSelectedTile(contact, uVariables.onLongPress,
                  uVariables.selectedContactsNumber)
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : contact.initials() == ''
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                    )
                  : Text(contact.initials())),
      trailing: Utils.isSelectedTile(contact, uVariables.onLongPress,
              uVariables.selectedContactsNumber)
          ? SizedBox()
          : IconButton(
              onPressed: () => Utils.call(contact.number),
              icon: Icon(Icons.call),
              color: UniversalVariables.gradientColorEnd,
            ),
      onLongPress: () => setState(() {
        uVariables.selectedContactsNumber.add(contact.number);
        uVariables.onLongPress = true;
        // Utils.onLongPress();
      }),
    );
  }
}

// class ChatListContainer extends StatefulWidget {
//   List inbox = List();
//   ChatListContainer(this.inbox);

//   @override
//   _ChatListContainerState createState() => _ChatListContainerState();
// }

// class _ChatListContainerState extends State<ChatListContainer> {
//   Stream<QuerySnapshot> check;

//   @override
//   Widget build(BuildContext context) {
//     // final UserProvider userProvider = Provider.of<UserProvider>(context);
//     return Container(
//         child: widget.inbox.isEmpty
//             ? Center(
//                 child:
//                     // CircularProgressIndicator(),
//                     Text('No Messages'),
//               )
//             : ListView.builder(
//                 padding: EdgeInsets.all(10),
//                 itemCount: widget.inbox.length,
//                 itemBuilder: (context, index) {
//                   var contactInbox = {
//                     "first_name": widget.inbox[index]['first_name'],
//                     "last_name": widget.inbox[index]['last_name'],
//                     "number": widget.inbox[index]['number'],
//                     "message": widget.inbox[index]['message'].text
//                   };
//                   Contact contact = Contact.fromMap(contactInbox);
//                   // Message = Message.fromMap(map)
//                   return ContactView(
//                     contact: contact,
//                     index: index,
//                   );
//                 },
//               )
//         //   }
//         //   return Center(
//         //     child: CircularProgressIndicator(),
//         //   );
//         // }),
//         );
//   }
// }
