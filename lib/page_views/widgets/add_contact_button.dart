import 'package:flutter/material.dart';
import 'package:skypealike/page_views/widgets/floating_action_button.dart';

class AddContactButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_contact_screen');
        },
        icon: Icons.person_add);
  }
}
