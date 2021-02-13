import 'package:flutter/material.dart';
import 'package:skypealike/screens/add_contact_screen.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/screens/login_page.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/screens/splash_screen.dart';
import 'package:skypealike/utils/shared_preferences.dart';
import 'models/user.dart';
import 'utils/shared_preferences.dart';

GlobalKey mainPageGlobalKey = GlobalKey();
SharedPreference sharedPreference = SharedPreference();
User user = User();
void main() => runApp(SkypeAlike());

class SkypeAlike extends StatefulWidget {
  @override
  _SkypeAlikeState createState() => _SkypeAlikeState();
}

class _SkypeAlikeState extends State<SkypeAlike> {
  bool login = false;
  checkLogin() async {
    login = await sharedPreference.checklogin();

    setState(() {});
    return;
  }

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SkypeAlike",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/search_screen': (context) => SearchScreen(),
        '/login_screen': (context) => Login(),
        '/home_screen': (context) => HomeScreen(),
        '/add_contact_screen': (context) => AddContect(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: CustomSplashScreen(),
      ),
    );
  }
}
