import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:skypealike/screens/add_contact_screen.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/screens/login_page.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/screens/splash_screen.dart';
import 'package:skypealike/utils/initialization_notification.dart';
import 'package:skypealike/utils/shared_preferences.dart';
import 'models/user.dart';
import 'utils/shared_preferences.dart';

GlobalKey mainPageGlobalKey = GlobalKey();
SharedPreference sharedPreference = SharedPreference();
User user = User();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.notification.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(SkypeAlike());
}

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
      super.initState();
      LocalNotifications localNotifications = LocalNotifications();
      localNotifications.firebaseMessageConfiguration();
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Intrelligent",
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
