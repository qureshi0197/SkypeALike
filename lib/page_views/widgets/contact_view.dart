import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/chat_screens/chat_screen.dart';
import 'package:skypealike/chat_screens/widgets/cached_image.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/user.dart';
import 'package:skypealike/page_views/widgets/last_message_container.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/resources/chat_methods.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();
  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();
  int count;

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () async {
        await _chatMethods.updateMessageSeenStatusInDb(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        );

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      receiver: contact,
                    )));
      },
      title: Text(
        // ?. if contact is not null return name else return null
        // ?? if contact.name is not null return contact.name else return ..
        contact?.name ?? "..",
        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.uid, receiverId: contact.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
          ],
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: UniversalVariables.blueColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$count",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
