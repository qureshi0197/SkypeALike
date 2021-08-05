import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/screens/edit_password_screen.dart';
import 'package:skypealike/screens/login_page.dart';
import 'package:skypealike/services/http_service.dart';
import 'package:skypealike/utils/universal_variables.dart';

import '../../main.dart';

class UserDetailsContainer extends StatefulWidget {
  bool tapped;

  UserDetailsContainer(this.tapped);

  @override
  _UserDetailsContainerState createState() => _UserDetailsContainerState();
}

class _UserDetailsContainerState extends State<UserDetailsContainer> {
  HttpService httpService = HttpService();
  var loading = false;
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
        body: UserDetailsBody(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: UniversalVariables.gradientColorEnd),
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: TextStyle(color: UniversalVariables.gradientColorEnd),
          ),
          centerTitle: true,
          actions: <Widget>[
            loading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : FlatButton(
                    onPressed: () => signOut(),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                          color: UniversalVariables.gradientColorEnd,
                          fontSize: 18),
                    ),
                  ),
          ],
        ));
  }
}

class UserDetailsBody extends StatefulWidget {
  @override
  _UserDetailsBodyState createState() => _UserDetailsBodyState();
}

class _UserDetailsBodyState extends State<UserDetailsBody> {
  bool passwordCondition = false;

  String createString({String text, int length}) {
    var string = '';
    for (var i = 0; i < length; i++) {
      string = string + text;
    }
    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
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
                    user.number == null ? "No Phone Number" : "${user.number}",
                    style: TextStyle(
                        fontSize: 16, color: UniversalVariables.greyColor),
                  ),
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
                passwordCondition
                    ? user.password
                    : createString(length: user.password.length, text: '*'),
                style: TextStyle(
                    fontSize: 16, color: UniversalVariables.greyColor),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: UniversalVariables.gradientColorEnd,
                        onPressed: () {
                          passwordCondition = !passwordCondition;
                          setState(() {});
                        },
                        child: Text(
                          passwordCondition ? 'Hide Password' : 'Show Password',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: UniversalVariables.gradientColorEnd,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPassword())),
                        child: Text(
                          "Edit Password",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
