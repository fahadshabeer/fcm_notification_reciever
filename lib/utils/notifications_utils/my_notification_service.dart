import 'dart:convert';
import 'dart:developer';


import 'package:fcm_sender/main.dart';
import 'package:fcm_sender/views/screens/home_screen/home_screen.dart';
import 'package:fcm_sender/views/screens/notification_screen/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notifications_constants.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class MyNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings? initializationSettingsDarwin =
      DarwinInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) {});
  final LinuxInitializationSettings initializationSettingsLinux =
      const LinuxInitializationSettings(defaultActionName: 'Open notification');
  static final InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: NotificationConstants.initializationSettingsDarwin,
  );

  static void onBackgroundSelectNotification(
      NotificationResponse response) async {
    log("notification clicked");

      Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>const NotificationScreen()));

  }

  static initializeNotification() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      log("notification clicked");

            Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>const NotificationScreen()));

        },
        onDidReceiveBackgroundNotificationResponse:
            onBackgroundSelectNotification);
  }

  static Future removeSingleNotifications({required int? id}) async =>
      await flutterLocalNotificationsPlugin.cancel(id!);

  static void showEventNotification(String title, String description,String channel,int id) {
    flutterLocalNotificationsPlugin.show(
        id,
        title,
        description,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "channel",
            "event",
            channelDescription:
                "this channel is used to alert the user for new events",
            icon: '@mipmap/ic_launcher',
            ongoing: true
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: jsonEncode({"payload": "value"}));
  }
}
