import 'package:flutter/material.dart';
import 'package:skypealike/page_views/widgets/floating_action_button.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(
                        chatList: UniversalVariables.chatList,
                      )));
        },
        icon: Icons.edit);
  }
}
