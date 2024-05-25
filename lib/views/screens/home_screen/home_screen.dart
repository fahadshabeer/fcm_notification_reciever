import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic("all");
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    var isGranted=await Permission.notification.request();
    if(isGranted!=PermissionStatus.granted){
      Fluttertoast.showToast(msg: "You will not receive any notification until you grant permission",toastLength: Toast.LENGTH_LONG);
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:const Text("Notification Task"),
      ),
      body: const Center(
        child: Text("Waiting for notifications...",style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}
