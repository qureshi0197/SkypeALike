import 'package:flutter/material.dart';
import 'package:skypealike/utils/universal_variables.dart';


class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {},
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