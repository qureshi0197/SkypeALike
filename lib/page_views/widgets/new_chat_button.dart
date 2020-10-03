import 'package:flutter/material.dart';
import 'package:skypealike/utils/local_notification.dart';
import 'package:skypealike/utils/universal_variables.dart';


class NewChatButton extends StatelessWidget {

  final LocalNotifications localNotifications = LocalNotifications();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          // localNotifications.showNotifications();
          // Navigator.pushNamed(context, '/db_test_page');
          Navigator.pushNamed(context, '/login_screen');
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: UniversalVariables.fabGradient, 
            shape: BoxShape.circle
            ),
          child: Icon(Icons.edit, color: Colors.white,)),
        // backgroundColor: Colors.blue,
        );
  }
}