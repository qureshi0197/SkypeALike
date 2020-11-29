// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/floating_action_button.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/screens/edit_contact_screen.dart';
import 'package:skypealike/page_views/widgets/add_contact_button.dart';
import 'package:skypealike/utils/universal_variables.dart';
// import 'package:skypealike/page_views/widgets/pop_up_menu.dart';
import 'package:skypealike/utils/utilities.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contactList = [];
  UniversalVariables uVariables = UniversalVariables();
  DatabaseHelper dbHelper = DatabaseHelper();
  String date;
  bool loading = true;
  DateTime time;

  @override
  void initState() {
    super.initState();
    UniversalVariables.chatList = [];

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
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: customAppBar(context),
      floatingActionButton: uVariables.onLongPress
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                uVariables.onLongPress
                    ? CustomFloatingActionButton(
                        onPressed: () {
                          if (Utils.selectAll(
                              contactList, uVariables.selectedContactsNumber)) {
                            uVariables.selectedContactsNumber = [];
                            uVariables.onLongPress = false;
                          } else {
                            uVariables.onLongPress = true;
                            for (var contact in contactList) {
                              if (!uVariables.selectedContactsNumber
                                  .contains(contact.number))
                                uVariables.selectedContactsNumber
                                    .add(contact.number);
                            }
                          }
                          setState(() {});
                        },
                        icon: Utils.selectAll(
                                contactList, uVariables.selectedContactsNumber)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                CustomFloatingActionButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    for (String number in uVariables.selectedContactsNumber) {
                      Contact tempContact = Contact(number: number);
                      var response =
                          // true;
                          await httpService.deleteContact(tempContact);
                      // if (response) {
                      await dbHelper.deleteContact(tempContact);
                      // }
                    }

                    setState(() {
                      loading = false;
                    });

                    uVariables.selectedContactsNumber = [];
                    uVariables.onLongPress = false;
                    setState(() {});
                  },
                  icon: Icons.delete,
                ),
              ],
            )
          : AddContactButton(),
      body: contactListContainer(),
    );
  }

  contactListContainer() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder(
            // stream: null,
            future: httpService.getAllContacts(Utils.formatDateTime(time)),
            builder: (context, snapshot) {
              time = DateTime.now();
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
              } else {
                // var data = snapshot.data;

                contactList = snapshot.data;
                if (snapshot.data != null && snapshot.data != 401)
                  for (Contact contact in snapshot.data) {
                    dbHelper.contactExists(contact).then((value) {
                      if (!value) {
                        dbHelper.createContact(contact);
                      }
                    });
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
                            trailing: Utils.isSelectedTile(
                                    contact,
                                    uVariables.onLongPress,
                                    uVariables.selectedContactsNumber)
                                ? SizedBox()
                                // Icon(
                                //     Icons.delete,
                                //     color: Colors.grey,
                                //   )
                                : Wrap(
                                    spacing: 6,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () =>
                                            Utils.call(contact.number),
                                        icon: Icon(Icons.call),
                                        // Icons.edit,
                                        // color: Colors.blue,
                                      ),

                                      IconButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      receiver: contact,
                                                    ))),
                                        icon: Icon(Icons.message),
                                        // Icons.edit,
                                        // color: Colors.blue,
                                      ),

                                      //   IconButton(
                                      //     onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>EditContact(contact))),
                                      //     icon: Icon(Icons.edit),
                                      // // Icons.edit,
                                      // // color: Colors.blue,
                                      //     ),
                                    ],
                                  ),
                            onTap: () async {
                              if (uVariables.onLongPress) {
                                if (!uVariables.selectedContactsNumber
                                    .contains(contact.number)) {
                                  uVariables.selectedContactsNumber
                                      .add(contact.number);
                                } else {
                                  uVariables.selectedContactsNumber
                                      .remove(contact.number);
                                }
                                if (uVariables.selectedContactsNumber.isEmpty) {
                                  uVariables.onLongPress = false;
                                }
                              } else {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditContact(
                                              contact,
                                            )));
                              }
                              setState(() {});
                            },
                            title: Text(contact.first_name),
                            subtitle: Text(contact.number),
                            leading: CircleAvatar(
                                backgroundColor: Utils.isSelectedTile(
                                        contact,
                                        uVariables.onLongPress,
                                        uVariables.selectedContactsNumber)
                                    ? Colors.grey
                                    : null,
                                child: Utils.isSelectedTile(
                                        contact,
                                        uVariables.onLongPress,
                                        uVariables.selectedContactsNumber)
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : contact.initials() == ''
                                        ? Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          )
                                        : Text(contact.initials())),
                            onLongPress: () => setState(() {
                              uVariables.selectedContacts.add(contact);
                              uVariables.selectedContactsNumber
                                  .add(contact.number);
                              uVariables.onLongPress = true;
                              // Utils.onLongPress();
                            }),
                          );
                        },
                      );
                    });
              }
            });
  }
}

// class ContactListContainer extends StatefulWidget {
//   @override
//   _ContactListContainerState createState() => _ContactListContainerState();
// }

// class _ContactListContainerState extends State<ContactListContainer> {
//   List<Contact> contactList = [];
//   DatabaseHelper dbHelper = DatabaseHelper();
//   String date;
//   bool loading = true;
//   DateTime time;
//   @override
//   void initState() {
//     super.initState();

//     _getLastfetchTime();
//   }

//   _getLastfetchTime() async {
//     date = await sharedPreference.getLastContactFetchedTimeStamp();
//     time = Utils.convertStringToDateTime(date);
//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? Center(child: CircularProgressIndicator())
//         : FutureBuilder(
//             // stream: null,
//             future: httpService.getAllContacts(Utils.formatDateTime(time)),
//             builder: (context, snapshot) {
//               time = DateTime.now();
//               // if(snapshot.connectionState.index == 1){
//               //   return Center(child: CircularProgressIndicator(),);
//               // }
//               // if (snapshot.data == null) {
//               //   return Center(child: Text('No Contacts'));
//               // }
//               if (snapshot.data == 401) {
//                 Fluttertoast.showToast(msg: "Session Expired");
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, '/login_screen', (route) => false);
//                 sharedPreference.logout();
//               } else {
//                 // var data = snapshot.data;

//                 contactList = snapshot.data;
//                 if (snapshot.data != null && snapshot.data != 401)
//                   for (Contact contact in snapshot.data) {
//                     dbHelper.createContact(contact);
//                   }

//                 // contactList = dbHelper.getContacts();

//                 return FutureBuilder(
//                     future: dbHelper.getContacts(),
//                     builder: (context, snapshot) {
//                       // if(snapshot.data == null){
//                       //   return Center(child: Text("No Contacts"),);
//                       // }
//                       if (snapshot.data != null)
//                         contactList = snapshot.data;
//                       else
//                         contactList = [];
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: contactList.length,
//                         itemBuilder: (context, index) {
//                           Contact contact = contactList[index];
//                           // var val = contact.phones.elementAt(0);
//                           // val.
//                           // print(contact.phones.elementAt(0));
//                           // print(contact.email);
//                           return ListTile(
//                             trailing: Wrap(
//                               spacing: 6,
//                               children: <Widget>[
//                                 IconButton(
//                                   onPressed: () => Utils.call(contact.number),
//                                   icon: Icon(Icons.call),
//                                   // Icons.edit,
//                                   // color: Colors.blue,
//                                 ),

//                                 IconButton(
//                                   onPressed: () => Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ChatScreen(
//                                                 receiver: contact,
//                                               ))),
//                                   icon: Icon(Icons.message),
//                                   // Icons.edit,
//                                   // color: Colors.blue,
//                                 ),

//                                 //   IconButton(
//                                 //     onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>EditContact(contact))),
//                                 //     icon: Icon(Icons.edit),
//                                 // // Icons.edit,
//                                 // // color: Colors.blue,
//                                 //     ),
//                               ],
//                             ),
//                             onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         EditContact(contact))),
//                             title: Text(contact.first_name),
//                             subtitle: Text(contact.number),
//                             leading: (contact.avatar != null &&
//                                     contact.avatar.length > 0)
//                                 ? CircleAvatar(
//                                     backgroundImage:
//                                         MemoryImage(contact.avatar),
//                                   )
//                                 : CircleAvatar(child: Text(contact.initials())),
//                             onLongPress: () => setState(() {
//                               UniversalVariables.selectedContacts
//                                   .add(contact);
//                               UniversalVariables.onLongPress_chatList = true;
//                               Utils.onLongPress();
//                             }),
//                           );
//                         },
//                       );
//                     });
//               }
//             });
//   }
// }
