import 'dart:async';

import 'package:fcm_sender/utils/notifications_utils/my_notification_service.dart';
import 'package:fcm_sender/views/screens/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String sentTime=message.data['time'];

  var sentTimeLocal=DateTime.parse(sentTime).toLocal();
  var remainingSec=DateTime.now().difference(sentTimeLocal).inSeconds;
  if(remainingSec<300) {
    showNotification(300 - remainingSec);
  }
}

showNotification(int remainingSeconds){
  int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (remainingSeconds == 0) {
      await MyNotificationService.removeSingleNotifications(id:notificationId);
      timer.cancel();
    } else {
      remainingSeconds--;
      int minLeft=(remainingSeconds~/60);
      int secLeft=remainingSeconds-(60*minLeft);

      MyNotificationService.showEventNotification("Time Notification", "Time left: ${minLeft}min ${secLeft}sec", "example_channel", notificationId);
    }
  });
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 await MyNotificationService.initializeNotification();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void didChangeDependencies() {
    FirebaseMessaging.onMessage.listen(showMessage);
    super.didChangeDependencies();
  }
  showMessage(RemoteMessage message){

    String sentTime=message.data['time'];
    var sentTimeLocal=DateTime.parse(sentTime).toLocal();
    var remainingSec=DateTime.now().difference(sentTimeLocal).inSeconds;
    if(remainingSec<300) {
      showNotification(300 - remainingSec);
    }
  }
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
      designSize: Size(375, 812),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: HomeScreen(),
      ),
    );
  }
}
