import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/screens/edit_un_pw_screen.dart';
import 'package:skypealike/screens/login_page.dart';
import 'package:skypealike/services/http_service.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/appbar.dart';

import '../../main.dart';

class UserDetailsContainer extends StatefulWidget {
  bool tapped;

  UserDetailsContainer(this.tapped);

  @override
  _UserDetailsContainerState createState() => _UserDetailsContainerState();
}

class _UserDetailsContainerState extends State<UserDetailsContainer> {
  // final AuthMethods authMethods = AuthMethods();

  HttpService httpService = HttpService();
  var loading = false;
  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    signOut() async {
      setState(() {
        loading = true;
      });
      bool response = await httpService.logout();
      if (response) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
        );
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(msg: 'Logout Successfull');
      } else {
        Fluttertoast.showToast(msg: 'Logout Failed');
      }
      setState(() {
        loading = false;
      });
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
            title: UserCircle(true),
            centerTitle: true,
            actions: <Widget>[
              loading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Wrap(
                      // spacing: 2.0,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditUsernamePassword())),
                          icon: Icon(
                            Icons.edit,
                            color: UniversalVariables.gradientColorEnd,
                          ),
                        ),
                        FlatButton(
                          onPressed: () => signOut(),
                          child: Text(
                            "Sign Out",
                            style: TextStyle(
                                color: UniversalVariables.gradientColorEnd,
                                fontSize: 18),
                          ),
                        ),
                      ],
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
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    // final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          // CachedImage(
          //   user.profilePhoto,
          //   isRound: true,
          //   radius: 50,
          // ),
          // SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UniversalVariables.blackColor,
                ),
              ),
              Text(
                user.name,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: UniversalVariables.greyColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Phone Number",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UniversalVariables.blackColor,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "${user.number}",
                    style: TextStyle(
                        fontSize: 16, color: UniversalVariables.greyColor),
                  ),
                  // IconButton(icon: Icon(Icons.edit), onPressed: null)
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UniversalVariables.blackColor,
                ),
              ),
              Text(
                user.password,
                style: TextStyle(
                    fontSize: 16, color: UniversalVariables.greyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
