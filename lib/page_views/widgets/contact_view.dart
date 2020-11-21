import 'package:flutter/material.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/utils/utilities.dart';

import '../../main.dart';

class ContactView extends StatefulWidget {
  final Contact contact;
  final int index;

  ContactView({@required this.contact, @required this.index});

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    // if (UniversalVariables.selectedContactsNumber.isEmpty) {
    //   UniversalVariables.onLongPress = false;
    // }
    // print(UniversalVariables.selectedContacts.contains(widget.contact));
    // print(UniversalVariables.selectedContacts.first.number);
    // print(object)
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return ListTile(
      contentPadding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      onTap: () async {
        if (UniversalVariables.onLongPress) {
          if (!UniversalVariables.selectedContactsNumber
              .contains(widget.contact.number)) {
            UniversalVariables.selectedContactsNumber
                .add(widget.contact.number);
          } else {
            UniversalVariables.selectedContactsNumber
                .remove(widget.contact.number);
          }
          if (UniversalVariables.selectedContactsNumber.isEmpty) {
            UniversalVariables.onLongPress = false;
          }
        } else {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        receiver: widget.contact,
                      )));
        }
        setState(() {});
      },
      title: Text(
        Utils.checkNames(widget.contact),
        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(
        widget.contact.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
          child: widget.contact.initials() == ''
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                )
              : Text(widget.contact.initials())),
      trailing: UniversalVariables.onLongPress &&
              UniversalVariables.selectedContactsNumber
                  .contains(widget.contact.number)
          ? IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: Colors.red),
            )
          : IconButton(
              onPressed: () => Utils.call(widget.contact.number),
              icon: Icon(Icons.call),
              color: UniversalVariables.gradientColorEnd,
            ),
      onLongPress: () => setState(() {
        UniversalVariables.selectedContacts.add(widget.contact);
        UniversalVariables.selectedContactsNumber.add(widget.contact.number);
        UniversalVariables.onLongPress = true;
        Utils.onLongPress();
        // selected: true;
      }),
    );
  }
}
