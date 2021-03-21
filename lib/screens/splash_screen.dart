import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skypealike/main.dart';

import 'home_screen.dart';
import 'login_page.dart';

class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  bool login = false;

  checkLogin() async {
    login = await sharedPreference.checklogin();

    print(login);

    Timer(
        Duration(seconds: 3),
        login
            ? () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()))
            : () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => Login())));

    setState(() {});
    return;
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: new InkWell(
        child: new Stack(fit: StackFit.expand, children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              new Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: new Container(
                      child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: new Container(
                          child: new Image.asset('assets/images/icon.png'),
                        ),
                        radius: 70,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              new Container(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: new Container(
                      alignment: Alignment.bottomCenter,
                      child: new Image.asset('assets/images/Intrelligent.png'),
                    ),
                    radius: 70,
                  ),
                ],
              )),
            ],
          ),
        ]),
      ),
    ));
  }
}
