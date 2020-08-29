import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/contact_view.dart';
import 'package:skypealike/page_views/widgets/new_chat_button.dart';
import 'package:skypealike/page_views/widgets/quiet_box.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/resources/chat_methods.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/appbar.dart';

class ChatListScreen extends StatelessWidget {

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
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
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      // floatingActionButton: 
      
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {

  final ChatMethods _chatMethods = ChatMethods();
  Stream<QuerySnapshot> check;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: userProvider.getUser == null ? check : _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;
              print(docList);

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
              },
          );
        }
        return Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}


