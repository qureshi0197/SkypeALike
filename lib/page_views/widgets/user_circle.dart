import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/page_views/widgets/online_dot_indicator.dart';
import 'package:skypealike/page_views/widgets/user_details_container.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/utils/utilities.dart';


class UserCircle extends StatelessWidget {
  
  final Contact contact = Contact();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => UserDetailsContainer(),
        isScrollControlled: true,
        ),
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
                (userProvider.getUser) == null ? '' : Utils.getInitials(userProvider.getUser.name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.lightBlueColor,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: OnlineDotIndicator(
                uid: contact.uid
                )
            )
          ],
        ),
      ),
    );
  }
}