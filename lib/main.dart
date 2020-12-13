import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:skypealike/provider/image_upload_provider.dart';
import 'package:skypealike/screens/add_contact_screen.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/screens/login_page.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/utils/shared_preferences.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:splashscreen/splashscreen.dart';

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
  // FirebaseRepository _repository = FirebaseRepository();
  // AuthMethods _authMethods = AuthMethods();
  bool login = false;
  checkLogin() async {
    login = await sharedPreference.checklogin();

    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
    // print(login);
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
    return 
    // MultiProvider(
    //   key: mainPageGlobalKey,
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
    //     // ChangeNotifierProvider(create: (_) => UserProvider()),
    //   ],
      // child: 
      MaterialApp(
        title: "SkypeAlike",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          '/search_screen': (context) => SearchScreen(),
          '/login_screen': (context) => Login(),
          '/home_screen': (context) => HomeScreen(),
          '/add_contact_screen': (context) => AddContect(),
          // '/edit_contact_screen': (context) => EditContact(contact),
        },
        theme: ThemeData(primarySwatch: Colors.blue),
        // home: EditContact(contact)));
        home: SplashScreen(
                seconds: 4,
                navigateAfterSeconds: login ? HomeScreen() : Login(),
                // title: new Text(
                //   'INTRELLIGENT',
                //   style: new TextStyle(
                //       fontWeight: FontWeight.bold, 
                //       fontSize: 36.0, 
                //       color: Colors.white
                //       ),
                // ),
                image: new Image.asset('assets/images/SplashScreen-removebg-preview.png'),
                backgroundColor: Colors.white,
                styleTextUnderTheLoader: new TextStyle(),
                photoSize: 150.0,
                // gradientBackground: UniversalVariables.fabGradient,
                loaderColor:UniversalVariables.gradientColorEnd
                ),
      // ),
    );
  }
}

// class _CheckLogedin{
//   SharedPreference sharedPreference = SharedPreference();
//   if(sharedPreference)
// }
