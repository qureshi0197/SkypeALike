import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/chat_screens/widgets/cached_image.dart';
import 'package:skypealike/enum/user_state.dart';
import 'package:skypealike/models/user.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/screens/login_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/appbar.dart';

class UserDetailsContainer extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        authMethods.setUserState(
          userId: userProvider.getUser.uid,
          userState: UserState.Offline,
        );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: UniversalVariables.blackColor,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: UserCircle(),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: UniversalVariables.blueColor, fontSize: 18),
                ),
              )
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UniversalVariables.blackColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(fontSize: 14, color: UniversalVariables.greyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}