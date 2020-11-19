import 'package:flutter/material.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/utils/utilities.dart';

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
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return ListTile(
      // mini: false,
      contentPadding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      
      onTap: () async {
        if (UniversalVariables.onLongPress == true) {
          UniversalVariables.selectedContacts.add(widget.contact);
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

      trailing: UniversalVariables.onLongPress
          ? Icon(Icons.check_box)
          : IconButton(
              onPressed: () => Utils.call(widget.contact.number),
              icon: Icon(Icons.call),
              color: UniversalVariables.gradientColorEnd,
            ),

      onLongPress: () => setState(() {
        UniversalVariables.selectedContacts.add(widget.contact);
        UniversalVariables.onLongPress = true;
        Utils.onLongPress();
        // selected: true;
      }),
    );
  }
}
