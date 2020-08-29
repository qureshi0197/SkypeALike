import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypealike/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // FirebaseRepository _repository = FirebaseRepository();
  final AuthMethods _authMethods = AuthMethods();


  bool isLoginButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: loginButton(),
          ),
          isLoginButtonPressed ? 
              Center(child: CircularProgressIndicator(),)
              : Container()
        ],
        ),
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: UniversalVariables.senderColor,
          child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text(
          "LOGIN",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        onPressed: () => performLogin(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void performLogin() {
    // print("Trying to perform login");

    setState(() {
      isLoginButtonPressed = true;
    });
    _authMethods.signIn().then((FirebaseUser user) {
      // print("check1");
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  // void performLogin(){
  //   _repository.signIn().then((FirebaseUser user){
  //     if(user != null) {
  //       authenticateUser(user);
  //     } else {
  //       print("There was a error");
  //     }
  //   });
  // }

  void authenticateUser(FirebaseUser user){
    _authMethods.authenticateUser(user).then((isNewUser){

      setState(() {
        isLoginButtonPressed = false;
      });

      if(isNewUser) {
        _authMethods.addDataToDb(user).then((value)
        {
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context){
              return HomeScreen();
            }));
        });
      } else {
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) {
              return HomeScreen();
      }));
    }});
  }
}