import 'package:flutter/material.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/user_details_container.dart';

class UserCircle extends StatelessWidget {
  bool tapped;

  UserCircle(this.tapped);

  final Contact contact = Contact();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (tapped == false) {
          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            builder: (context) => UserDetailsContainer(true),
            isScrollControlled: true,
          );
        }
      },
      child: Container(),
    );
  }
}
