import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:skypealike/constants/styles.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/services/http_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  String userNotFonund = 'Incorrect username';
  String passwordIncorrect = 'Incorrect password';
  HttpService httpService = HttpService();
  String username = '';
  String password = '';
  int response;

  Widget _usernameForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            cursorColor: Colors.white,
            onChanged: (String val) {
              username = val;
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              // errorText: response == 102 ? userNotFonund:null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter Your Username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            cursorColor: Colors.white,
            onChanged: (String val) {
              password = val;
              // setState(() {
              // });
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              // errorText: response == 109 ? passwordIncorrect:null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter Your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginButton() {
    return loading
        ? Padding(
            padding: const EdgeInsets.all(35.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () async {
                if ((username.isEmpty) && password.isEmpty) {
                  Fluttertoast.showToast(msg: 'Fields are Empty');
                  return;
                }
                if (username.isEmpty) {
                  Fluttertoast.showToast(msg: 'Username is Empty');
                  return;
                }
                if (password.isEmpty) {
                  Fluttertoast.showToast(msg: 'Password is Empty');
                  return;
                }

                await sharedPreference.clearAllStrings();

                setState(() {
                  loading = true;
                });

                response = await httpService.login(
                    username, password); //? Will Uncomment Later
                // response = 0;  //! Will delete Later

                if (response == 0) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home_screen', (route) => false);
                } else if (response == 102) {
                  Fluttertoast.showToast(msg: 'Username Incorrect');
                } else if (response == 109) {
                  Fluttertoast.showToast(msg: 'Password Incorrect');
                } else {
                  Fluttertoast.showToast(msg: 'Login Failed');
                }
                setState(() {
                  loading = false;
                });
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            )),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30.0),
                  _usernameForm(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _passwordForm(),
                  _loginButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
