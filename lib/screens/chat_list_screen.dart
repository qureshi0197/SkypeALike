import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/enum/pop_up_menu_list.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/contact_view.dart';
import 'package:skypealike/page_views/widgets/new_chat_button.dart';
import 'package:skypealike/page_views/widgets/pop_up_menu.dart';
import 'package:skypealike/page_views/widgets/quiet_box.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/resources/chat_methods.dart';
// import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/appbar.dart';

import '../models/message.dart';

class ChatListScreen extends StatelessWidget {
  var inbox;
  ChatListScreen(this.inbox);

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
        PopUpMenu(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body:
      //  inbox == 'loading'
          // ? Center(child: CircularProgressIndicator())
          // : 
          inbox == null
              ? Center(
                  child: Text('Please Retry'),
                )
              : ChatListContainer(inbox),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  List inbox = List();
  ChatListContainer(this.inbox);

  final ChatMethods _chatMethods = ChatMethods();
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
                    "number":inbox[index]['number'],
                    "message":inbox[index]['message']['text']
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
