// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/screens/edit_contact_screen.dart';
import 'package:skypealike/page_views/widgets/add_contact_button.dart';
// import 'package:skypealike/page_views/widgets/pop_up_menu.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/utils/utilities.dart';
import 'package:skypealike/widgets/appbar.dart';
import 'package:intl/intl.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {

  

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.card_membership,
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
        // PopUpMenu(),
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
  DatabaseHelper dbHelper = DatabaseHelper();
  String date;
  bool loading = true;
  DateTime time;
  @override
  void initState() {
    super.initState();

    _getLastfetchTime();
  }

  _getLastfetchTime() async {
    date = await sharedPreference.getLastContactFetchedTimeStamp();
    time = Utils.convertStringToDateTime(date);
    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator()) : FutureBuilder(
        // stream: null,
        future: httpService.getAllContacts(Utils.formatDateTime(time)),
        builder: (context, snapshot) {
          time=DateTime.now();
          // if(snapshot.connectionState.index == 1){
          //   return Center(child: CircularProgressIndicator(),);
          // }
          // if (snapshot.data == null) {
          //   return Center(child: Text('No Contacts'));
          // }
           if (snapshot.data == 401) {
            Fluttertoast.showToast(msg: "Session Expired");
            Navigator.pushNamedAndRemoveUntil(
                context, '/login_screen', (route) => false);
            sharedPreference.logout();
          }
           else
            {
            var data = snapshot.data;

            contactList = snapshot.data;
            if(snapshot.data != null && snapshot.data != 401)
            for(Contact contact in snapshot.data){
              dbHelper.createContact(contact);          
            }

            // contactList = dbHelper.getContacts();

            return FutureBuilder(
              future: dbHelper.getContacts(),
              builder: (context, snapshot) {
                // if(snapshot.data == null){
                //   return Center(child: Text("No Contacts"),);
                // }
                if (snapshot.data != null)
                contactList = snapshot.data;
                else
                contactList = [];
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    Contact contact = contactList[index];
                    // var val = contact.phones.elementAt(0);
                    // val.
                    // print(contact.phones.elementAt(0));
                    // print(contact.email);
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
            );
          }
        });
  }
}
