import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
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

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  firebaseMessageConfigration() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('your channel id', 'your channel name',
                'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                showWhen: false);
        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        flutterLocalNotificationsPlugin.show(0, 'New Message',
            'There are new messages', platformChannelSpecifics);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeLocalNotification();
    firebaseMessageConfigration();
    firebaseMessaging.getToken().then((value) => print(value));
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

initializeLocalNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: true,
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification(),
  );
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //     AndroidNotificationDetails(
  //         'your channel id', 'your channel name', 'your channel description',
  //         importance: Importance.max, priority: Priority.high, showWhen: false);
  // const NotificationDetails platformChannelSpecifics =
  //     NotificationDetails(android: androidPlatformChannelSpecifics);

  // flutterLocalNotificationsPlugin.show(
  //     0, 'title', 'body', platformChannelSpecifics);
}
