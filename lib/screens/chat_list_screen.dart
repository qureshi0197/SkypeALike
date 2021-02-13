import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/page_views/widgets/floating_action_button.dart';
import 'package:skypealike/page_views/widgets/new_chat_button.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/utils/utilities.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var loading = true;

  UniversalVariables uVariables = UniversalVariables();

  DatabaseHelper databaseHelper = DatabaseHelper();

  var usersInbox = [];

  List<Message> messageList = [];

  var contacts;

  String date;

  DateTime time;

  List<Contact> chatContactList = [];

  @override
  void initState() {
    // TODO: implement initState
    _getAllDbContacts();
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
    final formatter = DateFormat(r'''EEE, dd MMM yyyy hh:mm:ss''');
    var val = (formatter.parse(time, true));
    val = (val.toLocal());
    return val.millisecondsSinceEpoch;
  }

  _arrangeAllMessagesForInbox(List<Message> messagesList) {
    UniversalVariables.chatList = [];
    Map otherUserData = {};
    List otherUserKeys = [];
    usersInbox = [];
    for (Message mesg in messagesList) {
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

    otherUserData.forEach((key, value) async {
      String name = '';
      String first_name = '', last_name = '';

      for (Contact item in contacts) {
        if (item.number == key) {
          first_name = item.first_name;
          last_name = item.last_name;
        }
      }
      if (first_name.isEmpty && last_name.isEmpty) {
        Contact tempContact =
            Contact(number: key, first_name: '', last_name: '');
        UniversalVariables.chatList.add(tempContact);
      }

      usersInbox.add({
        "first_name": first_name,
        "last_name": last_name,
        "number": key,
        "message": value
      });
    });

    usersInbox.sort((a, b) {
      var aTime = _convertTimeToTimeStamp(a['message'].timestamp);
      var bTime = _convertTimeToTimeStamp(b['message'].timestamp);
      return aTime.compareTo(bTime);
    });
    usersInbox = usersInbox.reversed.toList();

    return usersInbox;
  }

  _getLastfetchTime() async {
    date = await sharedPreference.getLastMesgFetchedTimeStamp();
    time = Utils.convertStringToDateTime(date);
    setState(() {});
  }

  Stream getPeriodicStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) async {
      return await httpService.getAllMessages(null);
    }).asyncMap(
      (value) async => await value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            uVariables.selectedUserInbox = [];
                            uVariables.onLongPress = false;
                          } else {
                            uVariables.onLongPress = true;
                            for (var userinbox in usersInbox) {
                              if (!uVariables.selectedContactsNumber
                                  .contains(userinbox['number']))
                                uVariables.selectedContactsNumber
                                    .add(userinbox['number']);
                              uVariables.selectedUserInbox
                                  .add(userinbox['message']);
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
                    setState(() {
                      loading = true;
                    });
                    for (String number in uVariables.selectedContactsNumber) {
                      await httpService.deleteChat(number.substring(1));
                      await databaseHelper.deleteChat(number);
                      Fluttertoast.showToast(msg: 'Chat Deleted Successfully');
                    }
                    setState(() {
                      loading = false;
                    });

                    uVariables.selectedContactsNumber = [];
                    uVariables.selectedUserInbox = [];
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

            if (snapshot.data == 401) {
              Fluttertoast.showToast(msg: "Session Expired");
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login_screen', (Route route) => false);
              sharedPreference.logout();
            }

            if (snapshot.data != null && snapshot.data != 401)
              for (var message in snapshot.data) {
                Future<bool> condition = databaseHelper.searchMessages(message);
                condition.then((bool onValue) {
                  if (!onValue) {
                    databaseHelper.createMessage(message);
                  }
                });
              }

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
                child: Text('No Messages'),
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
                  return contactView(
                    contact: contact,
                    index: index,
                  );
                },
              ));
  }

  contactView({Contact contact, int index}) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      onTap: () async {
        if (uVariables.onLongPress) {
          if (!uVariables.selectedContactsNumber.contains(contact.number)) {
            uVariables.selectedContactsNumber.add(contact.number);
            uVariables.selectedUserInbox.addAll(usersInbox[index]);
          } else {
            uVariables.selectedContactsNumber.remove(contact.number);
            uVariables.selectedUserInbox.remove(usersInbox[index]);
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
              : UniversalVariables.gradientColorEnd,
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
        uVariables.selectedUserInbox.add(usersInbox[index]);
        uVariables.onLongPress = true;
      }),
    );
  }
}
