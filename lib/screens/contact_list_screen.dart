// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/screens/edit_contact_screen.dart';
import 'package:skypealike/page_views/widgets/add_contact_button.dart';
import 'package:skypealike/page_views/widgets/pop_up_menu.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/widgets/appbar.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.import_contacts,
          color: Colors.blue,
        ),
        onPressed: () {
          // Navigator.pushNamed(context, "/check_services");
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
      floatingActionButton: AddContactButton(),
      body: ContactListContainer(),
    );
  }
}

class ContactListContainer extends StatefulWidget {
  @override
  _ContactListContainerState createState() => _ContactListContainerState();
}

class _ContactListContainerState extends State<ContactListContainer> {
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();

    getAllContacts();
  }

  getAllContacts() async {
    List<Contact> _contacts = [];

    setState(() {
      contactList = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // stream: null,
        future: httpService.getAllContacts(null),
        builder: (context, snapshot) {
          if(snapshot.connectionState.index == 1){
            return Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.data == null) {
            return Center(child: Text('No Contacts'));
          }
           else if (snapshot.data == 401) {
            Fluttertoast.showToast(msg: "Session Expired");
            Navigator.pushNamedAndRemoveUntil(
                context, '/login_screen', (route) => false);
            sharedPreference.logout();
          }
           else {
            // var data = snapshot.data;

            contactList = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                Contact contact = contactList[index];
                // var val = contact.phones.elementAt(0);
                // val.
                // print(contact.phones.elementAt(0));
                print(contact.email);
                return ListTile(
                  trailing: IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>EditContact(contact))),
                    icon: Icon(Icons.edit),
                    // Icons.edit,
                    // color: Colors.blue,
                    ),
                    onTap: null,
                  title: Text(contact.first_name),
                  subtitle: Text(contact.number),
                  leading: (contact.avatar != null && contact.avatar.length > 0)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(child: Text(contact.initials())),
                );
              },
            );
          }
        });
  }
}
