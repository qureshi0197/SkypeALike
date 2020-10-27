import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/contact_view.dart';
import 'package:skypealike/page_views/widgets/new_chat_button.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/widgets/appbar.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class ChatListScreen extends StatelessWidget {
  // var inbox;
  var loading = true;

  var usersInbox = [];
  // ChatListScreen(this.inbox);
  _convertTimeToTimeStamp(time) {
    // int timestamp;
    // time = "Thu, 24 Sep 2020 05:51:09 GMT";
    final formatter = DateFormat(r'''EEE, dd MMM yyyy hh:mm:ss''');
    // print(DateTime.);
    var val = (formatter.parse(time, true));
    print(val);
    val = (val.toLocal());
    return val.millisecondsSinceEpoch;
  }

  _arrangeAllMessagesForInbox(data) {
    var otherUserData = {};
    var otherUserKeys = [];
    usersInbox = [];
    if (data.containsKey('data')) {
      Map val = data['data'];
      val.forEach((key, value) {
        if (val[key]['direction'] == "outbound") {
          if (!otherUserKeys.contains(val[key]["receiver"]))
            otherUserKeys.add(val[key]["receiver"]);
          otherUserData[val[key]["receiver"]] = val[key];
        } else {
          if (!otherUserKeys.contains(val[key]["sender"]))
            otherUserKeys.add(value);
          otherUserData[val[key]["sender"]] = val[key];
        }
      });
      print(otherUserData);

      otherUserData.forEach((key, value) {
        usersInbox.add({"number": key, "message": value});
      });
      usersInbox.sort((a, b) {
        var aTime = _convertTimeToTimeStamp(a['message']['timestamp']);
        var bTime = _convertTimeToTimeStamp(b['message']['timestamp']);
        return aTime.compareTo(bTime);
      });
      usersInbox = usersInbox.reversed.toList();
      return usersInbox;
    } else {
      return [];
    }
    // return [];
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.import_contacts,
          color: Colors.blue,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/check_services");
        },
      ),
      title: UserCircle(false),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        // PopUpMenu(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: FutureBuilder(
          future: httpService.getAllMessages(null),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (loading) {
              if (snapshot.connectionState.index == 1) {
                loading = false;
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            if (snapshot.data == 401) {
              Fluttertoast.showToast(msg: "Session Expired");
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login_screen', (Route route) => false);
              sharedPreference.logout();
            }
            if (snapshot.data == null) {
              return Center(
                child: Text("No Messages"),
              );
            }
            // inbox = snapshot.data;
            usersInbox = _arrangeAllMessagesForInbox(snapshot.data);

            return Container(child: ChatListContainer(usersInbox));
          }),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  List inbox = List();
  ChatListContainer(this.inbox);

  // final ChatMethods _chatMethods = ChatMethods();
  Stream<QuerySnapshot> check;

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
        child: inbox.isEmpty
            ? Center(
                child: Text('No Messages'),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: inbox.length,
                itemBuilder: (context, index) {
                  var contactInbox = {
                    "number": inbox[index]['number'],
                    "message": inbox[index]['message']['text']
                  };
                  Contact contact = Contact.fromMap(contactInbox);
                  // Message = Message.fromMap(map)
                  return ContactView(contact);
                },
              )
        //   }
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }),
        );
  }
}
