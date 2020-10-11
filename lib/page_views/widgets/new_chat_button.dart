import 'package:flutter/material.dart';
import 'package:skypealike/page_views/widgets/floating_action_button.dart';
import 'package:skypealike/utils/local_notification.dart';
import 'package:skypealike/utils/universal_variables.dart';


class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search_screen');
        },
        icon: Icons.edit
        );
  }
}