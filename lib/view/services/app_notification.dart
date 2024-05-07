// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const EventChannel eventChannel = EventChannel('flutter.native/helper');

class NotificationMethods {
  // UpdateSessionViewModel updateSessionViewModel = Get.find();

  ///notification
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// notification permission
  notificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? deviceTokens = await messaging.getToken();
    print("Get FCM Token :- $deviceTokens");
    return deviceTokens;
  }

  onNotification() {
    // on notification
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;

    // print('notification data ' + jsonEncode(message.data));

    // if (notification != null && android != null) {
    //   log('notification body${notification.body}');

    // await flutterLocalNotificationsPlugin.show(notification.hashCode,
    //     notification.title, notification.body, platformChannelSpecifics(),
    //     payload: jsonEncode(message.data));

    // print('notification data ' + jsonEncode(message.data));
    // }

    // }
    // });

    /// when app is in background and user tap on it.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      if (message != null) {
        Map<String, dynamic> messageData = message.data;
        RemoteNotification? notification = message.notification;
        String screenName = messageData['notification_for'];

        // if (messageData != null) {
        //   if (notiIds.contains(messageData['entity'])) {
        //     return;
        //   } else {
        //     notiIds.add(messageData['entity']);
        //   }
        //
        //   routeScreenOnNotificationClick(
        //     context: context,
        //     data: messageData,
        //   );
        // }
      }
    });

    /// when app is in terminated and user tap on it.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {});
  }

  // ///====================get fcm token==========================
  // static Future<void> getFcmToken() async {
  //   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   // firebaseMessaging.deleteToken();
  //   try {
  //     String? token = await firebaseMessaging.getToken().catchError((e) {
  //       log("=========fcm- Error ....:$e");
  //     });
  //     log("=========FCM-TOKEN BEFORE ======${PreferenceManagerUtils.getFcmToken()}");
  //
  //     await PreferenceManagerUtils.setFcmToken(token!);
  //     log("=========FCM-TOKEN AFTER ======${PreferenceManagerUtils.getFcmToken()}");
  //   } catch (e) {
  //     // log("=========fcm- Error :$e");
  //     return;
  //   }
  // }

  static Future<void> sendMessage(
      {required String receiverFcmToken,
      required String msg,
      required String title}) async {
    log("SEND MESSAGE CALLING");
    var serverKey =
        'AAAAyOROJmw:APA91bE7ikEdNJC5iZHikM_GROakwWPRMIrJI0dRzaFycGWKQg_84MKTlV9y-YbMmIFOGYhKfV3D6O-uM9BiiKXdn0GQV2Uxa2IRtNlHihbSGIyJueWSlSBtPbEIIz2By6qTsuMcaeik';
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            "notification": <String, dynamic>{"body": msg, "title": title},
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "CHAT",
              "id": "1",
              "status": "done"
            },
            "to": receiverFcmToken,

            /// Single device send notification at the time
            //"registration_ids": [token1,token2],    /// Multi device send notification at the time     ///use only one "registration_ids" or "to" field
          },
        ),
      );
      log("RESPONSE CODE NOTI===>>>>${response.statusCode}");

      log("RESPONSE BODY ==========>>>>${response.body}");
    } catch (e) {
      log("error push notification");
    }
  }
}
