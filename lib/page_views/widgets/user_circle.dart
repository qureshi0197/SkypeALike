import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/user_details_container.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/utils/utilities.dart';

import '../../main.dart';

class UserCircle extends StatelessWidget {
  bool tapped;

  UserCircle(this.tapped);

  final Contact contact = Contact();

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () async {
        if (tapped == false) {
          await showModalBottomSheet(
            // tapped: true,
            context: context,
            backgroundColor: Colors.white,
            builder: (context) => UserDetailsContainer(true),
            isScrollControlled: true,
          );
        }
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: UniversalVariables.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                // '',
                Utils.getInitials(user.name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.lightBlueColor,
                  fontSize: 13,
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: OnlineDotIndicator(
            //     uid: contact.uid
            //     )
            // )
          ],
        ),
      ),
    );
  }
}
