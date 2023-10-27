import 'dart:developer';

import 'package:crm_client/Chat/chat_screen.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../Dashboard/dashboard_screen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

class NotificationHelper {


  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    var androidInitialize =
        new AndroidInitializationSettings('notification_icon');
    // var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(
      android: androidInitialize,

    );
    

    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,onDidReceiveNotificationResponse: (title) async {
      var mess= title.payload;
      print("sender onTap==========+${mess!.split("-").first.toString()}");

            print("sender onTap==========+${mess.split("-")[1].toString()}");
       String id = await SharedPreferenceClass.getSharedData("contact_id");
      Navigator.pushNamed(navState.currentState!.context, Chat_Screen.id,
          arguments: chatdata(
            myid: "client_" +id,
            friendid:
             "staff_${mess.split("-").first.toString()}",
            friendname:
                "${mess.split("-")[1].toString().replaceAll("[", "").replaceAll("]", "")}",
          )
          );
    },);// android initialize settings

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /* await flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: selectNotification);*/

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(
      //    "onMessage: ${message.notification?.body!.split("_")[1].split("-").toString()}");

      print('=========Complete message==========' + message.toMap().toString());


      print('==========Senders name++++++++++++++++++  +  ${message.notification?.title!.split("-")[1].toString()}');
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String id = await SharedPreferenceClass.getSharedData("contact_id");
      Navigator.pushNamed(navState.currentState!.context, Chat_Screen.id,
          arguments: chatdata(
            myid: "client_" + id,
             friendid:
                 "staff_${message.notification?.title!.split("-").first.toString()}",
            friendname:
                "${message.notification?.title!.split("-")[1].toString()}",
          ));

      print(
          "onOpenApp: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
      log("______Split__id_____" +
          "staff_${message.notification?.body!.split("_")[1].split("-").first.toString()}");

      // NotificationHelper.showNotification(
      //     message, flutterLocalNotificationsPlugin, false);
    });
  }

  static Future<void> showNotification(RemoteMessage message,

  
      FlutterLocalNotificationsPlugin fln, bool data) async {
    //
    await showBigTextNotification(

      //title
        
      
        "${message.notification?.title!..toString().replaceAll("[", "").replaceAll("]", "")}",
      
      //message  
      "${message.notification?.body!.toString().replaceAll("[", "").replaceAll("]", "")}",


//'alltitle',

"${message.notification?.title!.toString()}",


        fln);
    /*if(!GetPlatform.isIOS) {
      String _title;
      String _body;
      String _orderID;
      String _image;
      NotificationBody _notificationBody = convertNotification(message.data);
      if(data) {
        _title = message.data['title'];
        _body = message.data['body'];
        _orderID = message.data['order_id'];
        _image = (message.data['image'] != null && message.data['image'].isNotEmpty)
            ? message.data['image'].startsWith('http') ? message.data['image']
            : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.data['image']}' : null;
      }else {
        _title = message.notification.title;
        _body = message.notification.body;
        _orderID = message.notification.titleLocKey;
        if(GetPlatform.isAndroid) {
          _image = (message.notification.android.imageUrl != null && message.notification.android.imageUrl.isNotEmpty)
              ? message.notification.android.imageUrl.startsWith('http') ? message.notification.android.imageUrl
              : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification.android.imageUrl}' : null;
        }else if(GetPlatform.isIOS) {
          _image = (message.notification.apple.imageUrl != null && message.notification.apple.imageUrl.isNotEmpty)
              ? message.notification.apple.imageUrl.startsWith('http') ? message.notification.apple.imageUrl
              : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification.apple.imageUrl}' : null;
        }
      }

      if(_image != null && _image.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(_title, body, orderID, notificationBody, image, fln);
        }catch(e) {
          await showBigTextNotification(_title, body, orderID, _notificationBody, fln);
        }
      }else {
        await showBigTextNotification(_title, body, orderID, _notificationBody, fln);
      }
    }*/
  }

  static Future<void> showBigTextNotification(
   String title, String  body,String alltitle, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Neewww',
      'mag',
      
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,

      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload:alltitle ,);
  }

  // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   log("Back->>>>>>>>>>> ");
  // }
// static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
// // showBigTextNotification(title,  body, FlutterLocalNotificationsPlugin fln);
//   print("Handling a background message: ${message.toMap().toString()}");
// }




static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle the background message here
    print(" ::::::::::::::::Handling a background message:::::::::::: ${message.toMap().toString()}");



    String id = await SharedPreferenceClass.getSharedData("contact_id");
      Navigator.pushNamed(navState.currentState!.context, Chat_Screen.id,
          arguments: chatdata(
            myid: "client_" +id,
            friendid:
            "staff_${message.notification?.title!.split("-").first.toString()}",
            friendname:
              "staff_${message.notification?.title!.split("-").first.toString()}",
          )
          );

    // Create a FlutterLocalNotificationsPlugin instance
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize the plugin (if not already initialized)
    var androidInitialize =
        AndroidInitializationSettings('notification_icon'); // Change 'notification_icon' to your app's icon name
    var initializationsSettings = new InitializationSettings(
      android: androidInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    // Define the custom notification details
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'custom_channel_id', // Channel ID (you can define your own)
      'Custom Channel Name', // Channel Name
      importance: Importance.high, // Set the importance level
      priority: Priority.high, // Set the priority
    );

    // Define the notification details
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Extract custom notification data (modify as needed)
    final String title = "${message.notification?.title!.split("-")[1].toString()}";
    final String body =  "${message.notification?.body!.split("message -")[1].split("bodyLocArgs").toString().replaceAll("[", "").replaceAll("]", "")}";

    //Show the custom notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (you can use a unique value)
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
      payload:null,
    );
  }



}
