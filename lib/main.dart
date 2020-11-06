
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/provider/image_upload_provider.dart';
import 'package:skypealike/screens/add_contact_screen.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/screens/login_page.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/utils/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'models/user.dart';
import 'utils/shared_preferences.dart';

SharedPreference sharedPreference = SharedPreference();
User user = User();
void main() => runApp(SkypeAlike());

class SkypeAlike extends StatefulWidget {
  @override
  _SkypeAlikeState createState() => _SkypeAlikeState();
}

class _SkypeAlikeState extends State<SkypeAlike> {
  // FirebaseRepository _repository = FirebaseRepository();
  // AuthMethods _authMethods = AuthMethods();
  bool login = null;
  checkLogin() async {
    login = await sharedPreference.checklogin();
    print(login);
    setState(() {});
    return;
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    // .then((a) {
    //   print(login);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Contact contact = Contact(first_name: 'Abdullah Qureshi');
    // SharedPreference sharedPreference = SharedPreference();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "SkypeAlike",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          '/search_screen': (context) => SearchScreen(),
          '/login_screen': (context) => Login(),
          '/home_screen': (context) => HomeScreen(),
          '/add_contact_screen':(context) => AddContect(),
          // '/edit_contact_screen': (context) => EditContact(contact),
        },
        theme: ThemeData(primarySwatch: Colors.blue),
        // home: EditContact(contact)));
        home: login == null
            ? Scaffold(
                backgroundColor: Colors.white,
              )
            : SplashScreen(
                seconds: 2,
                navigateAfterSeconds: login ? HomeScreen() : Login(),
                title: new Text(
                  'Welcome In SplashScreen',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
                backgroundColor: Colors.white,
                styleTextUnderTheLoader: new TextStyle(),
                photoSize: 100.0,
                loaderColor: Colors.red),
      ),
    );
  }
}

// class _CheckLogedin{
//   SharedPreference sharedPreference = SharedPreference();
//   if(sharedPreference)
// }
