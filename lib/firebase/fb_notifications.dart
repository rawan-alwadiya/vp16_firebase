import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_app/firebase_options.dart';

//typedef BackgroundMessageHandler = Future<void> Function(Remote Message);
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async{
  //Background notifications - ios & Android
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Massage: ${remoteMessage.messageId}');
}

//Global
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin localNotificationsPlugin;

mixin FbNotifications {
  /// CALLED IN main function between ensureInitialized <-> runApp(widget)
  static Future<void> initNotifications() async{
    //Connect the previous created function with onBackground to enable
    //receiving notification when app in Background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //Channel
    if(Platform.isAndroid){
      channel = const AndroidNotificationChannel(
          'vp16_flutter_channel',
          'flutter android Notification Channel',
           description: 'This channel will receive notifications specific to flutter-app',
           importance: Importance.high,
           enableLights: true,
           enableVibration: true,
           ledColor: Colors.orange,
           showBadge: true,
           playSound: true,
      );

      //Flutter Local Notifications Plugin (FOREGROUND) - ANDROID CHANNEL
      localNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    //ios Notification Setup (FOREGROUND)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //ios Notifications Permissions
  Future<void> requestNotificationPermissions() async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          carPlay: false,
          announcement: false,
          provisional: false,
          criticalAlert: false,
        );
        if(notificationSettings.authorizationStatus == AuthorizationStatus.authorized){
          print('GRANT PERMISSION');
        }else if(notificationSettings.authorizationStatus == AuthorizationStatus.denied){
          print('Permission Denied');
        }
  }

  //ANDROID
  void initializedForegroundNotificationForAndroid(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      if(Platform.isAndroid) {
        print('Message Received: ${message.messageId}');
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification = notification?.android;
        if (notification != null && androidNotification != null) {
          localNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
              ),
            ),
          );
        }
      }
    });
  }

  //GENERAL (Android & ios)
  void manageNotificationAction(){
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _controlNotificationNavigation(message.data);
    });
  }

  void _controlNotificationNavigation(Map<String,dynamic> data){
    print('Data: $data');
    if(data['page'] != null){
      switch (data['page']){
        case 'products':
          var productId = data['id'];
          print('Product Id: $productId');
          break;

        case 'settings':
          print('Navigate to settings');
          break;

        case 'profile':
          print('Navigate to Profile');
          break;
      }
    }
  }
}