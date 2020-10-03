import 'dart:math';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
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
      // floatingActionButton: 
      
      floatingActionButton: AddContactButton(),
      body: ContactListContainer(),
    );
  }
}

class ContactListContainer extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {

  }
}