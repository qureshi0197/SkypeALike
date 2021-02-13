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
  UniversalVariables uVariables = UniversalVariables();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      onTap: () async {
        if (uVariables.onLongPress) {
          if (!uVariables.selectedContactsNumber
              .contains(widget.contact.number)) {
            uVariables.selectedContactsNumber.add(widget.contact.number);
          } else {
            uVariables.selectedContactsNumber.remove(widget.contact.number);
          }
          if (uVariables.selectedContactsNumber.isEmpty) {
            uVariables.onLongPress = false;
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
      trailing: uVariables.onLongPress &&
              uVariables.selectedContactsNumber.contains(widget.contact.number)
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
        uVariables.selectedContacts.add(widget.contact);
        uVariables.selectedContactsNumber.add(widget.contact.number);
        uVariables.onLongPress = true;
        Utils.onLongPress();
      }),
    );
  }
}
