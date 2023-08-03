
import 'package:enye_app/screens/screens.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../main.dart';
import '../widget/custom_navbar.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}


class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    navigatorKey.currentState?.pushReplacementNamed('/', arguments: message);
    //navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CustomNavBar()));
  }

  Future initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }


  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await SessionManager().set("token", fCMToken);
    print('Token: $fCMToken');
    initPushNotification();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}