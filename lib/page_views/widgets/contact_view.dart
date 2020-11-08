import 'package:flutter/material.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/utils/utilities.dart';
import 'package:skypealike/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  // final AuthMethods _authMethods = AuthMethods();
  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
            contact: contact,
          );
    // FutureBuilder<User>(
    //   future: _authMethods.getUserDetailsById(contact.uid),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       User user = snapshot.data;

    //       return ViewLayout(
    //         contact: user,
    //       );
    //     }
    //     return Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
  }
}

class ViewLayout extends StatefulWidget {
  final Contact contact;
  // final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({@required this.contact});

  @override
  _ViewLayoutState createState() => _ViewLayoutState();
}

class _ViewLayoutState extends State<ViewLayout> {
  int count;

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () async {
        // await _chatMethods.updateMessageSeenStatusInDb(
        //   senderId: userProvider.getUser.uid,
        //   receiverId: contact.uid,
        // );

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      receiver: widget.contact,
                    )));
        setState(() {
          
        });
      },
      title: Text(
        // ?. if contact is not null return name else return null
        // ?? if contact.name is not null return contact.name else return ..
        Utils.checkNames(widget.contact),

        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(widget.contact.message),
      // LastMessageContainer(
      //   stream: _chatMethods.fetchLastMessageBetween(
      //       senderId: userProvider.getUser.uid, receiverId: contact.uid),
      // ),
      leading: CircleAvatar(child: Text(widget.contact.initials()))
    );
  }
}
