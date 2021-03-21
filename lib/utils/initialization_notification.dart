import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  void firebaseMessageConfiguration() {
    firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage invoked");
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          enableVibration: true,
          playSound: true,
        );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          presentBadge: true,
          presentSound: true,
          presentAlert: true
        );
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics,
        );

        flutterLocalNotificationsPlugin.show(0, 'New Message',
            'There are new messages', platformChannelSpecifics);
      },
    );
  }

  // This function is required to run everytime app resumes.
  Future<void> initNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: false,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // This Funtion is required to run on every notification received.
  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Message', 'There are new messages', platformChannelSpecifics,
        payload: 'New Messages');
  }
  // initializeLocalNotification() async {
  //   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   final IOSInitializationSettings initializationSettingsIOS =
  //       IOSInitializationSettings(
  //     requestSoundPermission: false,
  //     requestBadgePermission: false,
  //     requestAlertPermission: true,
  //     onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
  //       didReceiveLocalNotificationSubject.add(ReceivedNotification(
  //           id: id, title: title, body: body, payload: payload));
  //   );

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           iOS: initializationSettingsIOS);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}