// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use
//lll
import 'dart:developer';
import 'dart:io';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/splashWidget.dart';
import 'package:crm_client/util/RouteGenerator.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Chat/chat_screen.dart';
import 'Chat/clientlisting.dart';

import 'util/constants.dart';
import 'util/storage_manger.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}






// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

//   log("Handling a background message: ${message.messageId}/n ${message.toMap().toString()}");

//   // PushNotification notification = PushNotification(
//   //   title: message.notification?.title,
//   //   body: message.notification?.body,
//   //   dataTitle: message.data['title'],
//   //   dataBody: message.data['body'],
//   // );

//   // final _notificationInfo = notification;


// //  showSimpleNotification(
// //             Text(_notificationInfo.title ?? 'CRM'),
// //              leading: Text("a background message"),
// //             subtitle: Text(_notificationInfo.body ?? '-'),
// //            // context: CommanClass.navState.currentContext,
// //         //    background: ColorCollection.backColor,
// //             duration: Duration(seconds: 3),
// //             slideDismissDirection: DismissDirection.startToEnd,
// //             elevation: 5,
// //           );

//   // showOverlayNotification(
//   //   (context) {
//   //     return Material(
//   //       shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(10),
//   //           side: BorderSide(color: Colors.white, width: 0.3)),
//   //       // elevation: 1,
//   //       color: Colors.transparent,
//   //       child: Padding(
//   //         padding: EdgeInsets.all(10),
//   //         child: ListTile(
//   //           onTap: () async {
//   //             String id =
//   //                 await SharedPreferenceClass.getSharedData("contact_id");
//   //             Navigator.pushNamed(context, Chat_Screen.id,
//   //                 arguments: chatdata(
//   //                     myid: "client_" + id,
//   //                     friendid:
//   //                         "staff_${message.notification?.body!.split("_")[1].split("-").first.toString()}",
//   //                     friendname: "lbmsupport"));
//   //           },
//   //           selected: true,
//   //           selectedTileColor: Colors.white,
//   //           selectedColor: Theme.of(context).primaryColor,
//   //           title: SizedBox(
//   //               width: MediaQuery.of(context).size.width - 50,
//   //               child: Text(
//   //                 _notificationInfo.title ?? 'CRM',
//   //                 style: TextStyle(fontWeight: FontWeight.w700),
//   //                 overflow: TextOverflow.ellipsis,
//   //               )),
//   //           subtitle: SizedBox(
//   //               width: MediaQuery.of(context).size.width - 50,
//   //               child: Text(
//   //                 _notificationInfo.body ?? '',
//   //                 style: TextStyle(fontWeight: FontWeight.w600),
//   //                 overflow: TextOverflow.ellipsis,
//   //               )),
//   //           leading: Image.asset(
//   //             'assets/appLogo.png',
//   //             height: 50,
//   //             width: 50,
//   //           ),
//   //           trailing: IconButton(
//   //               onPressed: () {
//   //                 OverlaySupportEntry.of(context)?.dismiss();
//   //               },
//   //               icon: Icon(Icons.close)),
//   //           shape: RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(10),
//   //               side: BorderSide(
//   //                   color: Theme.of(context).primaryColor, width: 0.3)),
//   //         ),
//   //       ),
//   //     );
//   //   },
//   //   // Text(_notificationInfo!.title ?? 'CRM'),
//   //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
//   //   // Text(_notificationInfo!.body ?? '-'),
//   //   context: navState.currentContext,
//   //   position: NotificationPosition.top,
//   //   duration: Duration(seconds: 4),
//   // );

// }

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
FlutterLocalNotificationsPlugin flutterLocalPlugin=FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();
   await NotificationHelper.initialize(flutterLocalPlugin);

 FirebaseMessaging.onBackgroundMessage(NotificationHelper.firebaseMessagingBackgroundHandler);


 ////         // await FirebaseMessaging.instance.requestPermission();



  //await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>() ?.createNotificationChannel(channel);
// FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


   runApp(MyApp());
}





class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late final FirebaseMessaging _messaging;
 // PushNotification? _notificationInfo;
  //late int _totalNotifications;

  //  PushNotification? _notificationInfo;


// Future<void> showNotification(RemoteMessage message)async {

  
// }

  /// This has to happen only once per app

  // void registerNotification() async {
  //   await Firebase.initializeApp();
  //   _messaging = FirebaseMessaging.instance;

  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   FirebaseMessaging.onBackgroundMessage((message) async {

  //  showSimpleNotification(
  //           Text(_notificationInfo!.title ?? 'CRM'),
  //            leading: Text('dsfdsf'),
  //           subtitle: Text(_notificationInfo!.body ?? '-'),
  //          // context: CommanClass.navState.currentContext,
  //       //    background: ColorCollection.backColor,
  //           duration: Duration(seconds: 3),
  //           slideDismissDirection: DismissDirection.startToEnd,
  //           elevation: 5,
  //         );

  //     print('getting messages from background --------'+message.data.toString());
  //     String id = await SharedPreferenceClass.getSharedData("contact_id");
  //     Navigator.pushNamed(context, Chat_Screen.id,
  //         arguments: chatdata(
  //             myid: "client_" + id,
  //             friendid:
  //                 "staff_${message.notification?.body!.split("_")[1].split("-").first.toString()}",
  //             friendname: "lbmsupport"));
  //   });

  //   //On iOS, this helps to take the user permissions
  //   NotificationSettings settings = await _messaging.requestPermission(
  //     alert: true,
  //     announcement: true,
  //     badge: true,
  //     carPlay: true,
  //     criticalAlert: true,
  //     provisional: true,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     log('User granted permission============>>>>>>>>>');
  //     SharedPreferenceClass.setSharedData("TokenKey",
  //         "AAAAMue_ylA:APA91bHIASApWJVz-VTt2PJ0wVGo4lik1x9OtO290ECgYgFemSBFM6R5uRDdLHO_riqN9XQO12r2AJwu1j-BjSp7zZpHVdZopjCsOuqOLB5E0bPKtyfLauV97cRqI9ZfTCCrMu2spAHy");
  //     _messaging.getToken().then((token) {
  //       log("   Toookkkkeeennn   Toookkkkeeennn   Toookkkkeeennn     $token");
  //       SharedPreferenceClass.setSharedData("TokenID", token);
  //     });
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       log('================>>>>>>>>  Message title: ${message.notification?.title}, body: ${message.notification?.body?.split("_")[1].split("-").first}');
  //       log(" ===Title of the Message ===    " +
  //           message.data['title'].toString());
  //       log(" ===Body of the Message ===    " + message.toMap().toString());

  //       // Parse the message received
  //       PushNotification notification = PushNotification(
  //         title: message.notification?.title,
  //         body: message.notification?.body,
  //         dataTitle: message.data['title'],
  //         dataBody: message.data['body'],
  //       );

  //       setState(() {
  //         _notificationInfo = notification;
  //         //  _totalNotifications++;
  //       });

  //       if (_notificationInfo != null) {
  //         // For displaying the notification as an overlay

  //         // showSimpleNotification(
  //         //   Text(_notificationInfo!.title ?? 'CRM'),
  //         //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
  //         //   subtitle: Text(_notificationInfo!.body ?? '-'),
  //         //   context: CommanClass.navState.currentContext,
  //         //   background: ColorCollection.backColor,
  //         //   duration: Duration(seconds: 3),
  //         //   slideDismissDirection: DismissDirection.startToEnd,
  //         //   elevation: 5,
  //         // );
  //         showOverlayNotification(
  //           (context) {
  //             return Material(
  //               // shape: RoundedRectangleBorder(
  //               //     borderRadius: BorderRadius.circular(10),
  //               //     side: BorderSide(color: Colors.white, width: 0.3)),
  //               // elevation: 1,
  //               color: Colors.transparent,
  //               child: Padding(
  //                 padding: EdgeInsets.all(10),
  //                 child: ListTile(
  //                   onTap: () async {
  //                     String id = await SharedPreferenceClass.getSharedData(
  //                         "contact_id");
  //                     Navigator.pushNamed(context, Chat_Screen.id,
  //                         arguments: chatdata(
  //                             myid: "client_" + id,
  //                             friendid:
  //                                 "staff_${message.notification?.body!.split("_")[1].split("-").first.toString()}",
  //                             friendname: "lbmsupport"));
  //                   },
  //                   selected: true,
  //                   selectedTileColor: Colors.white,
  //                   selectedColor: Theme.of(context).primaryColor,
  //                   title: SizedBox(
  //                       width: MediaQuery.of(context).size.width - 50,
  //                       child: Text(
  //                         _notificationInfo!.title ?? 'CRM',
  //                         style: TextStyle(fontWeight: FontWeight.w700),
  //                         overflow: TextOverflow.ellipsis,
  //                       )),
  //                   subtitle: SizedBox(
  //                       width: MediaQuery.of(context).size.width - 50,
  //                       child: Text(
  //                         _notificationInfo!.body ?? '',
  //                         style: TextStyle(fontWeight: FontWeight.w600),
  //                         overflow: TextOverflow.ellipsis,
  //                       )),
  //                   leading: Image.asset(
  //                     'assets/appLogo.png',
  //                     height: 50,
  //                     width: 50,
  //                   ),
  //                   trailing: IconButton(
  //                       onPressed: () {
  //                         OverlaySupportEntry.of(context)?.dismiss();
  //                       },
  //                       icon: Icon(Icons.close)),
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       side: BorderSide(
  //                           color: Theme.of(context).primaryColor, width: 0.3)),
  //                 ),
  //               ),
  //             );
  //           },
  //           // Text(_notificationInfo!.title ?? 'CRM'),
  //           // leading: NotificationBadge(totalNotifications: _totalNotifications),
  //           // Text(_notificationInfo!.body ?? '-'),
  //           context: navState.currentContext,
  //           position: NotificationPosition.top,
  //           duration: Duration(seconds: 3),
  //         );
  //       } else {
  //         log('No Notification');
  //       }
  //     });
  //   } else {
  //     log('User declined or has not accepted permission');
  //   }
  // }
  // For handling notification when the app is in terminated state

  // checkForInitialMessage() async {
  //   await Firebase.initializeApp();
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   if (initialMessage != null) {
  //     log('000000   Initial Message terminated state   1111111' +
  //         initialMessage.toMap().toString());
  //     setState(() {
  //       CommanClass.noticationMessage = initialMessage;
  //       CommanClass.notifcationTapped = true;
  //     });
  //     PushNotification notification = PushNotification(
  //       title: initialMessage.notification?.title,
  //       body: initialMessage.notification?.body,
  //       dataTitle: initialMessage.data['title'],
  //       dataBody: initialMessage.data['body'],
  //     );

  //     setState(() {
  //       _notificationInfo = notification;
  //     });
  //   }
  // }

  @override
  void initState() {
   // registerNotification();
    //checkForInitialMessage();
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   setState(() {
    //     _totalNotifications++;
    //     CommanClass.notifcationTapped = true;
    //     CommanClass.noticationMessage = message;
    //   });

    //   log('notification Tapped == > $message');
    //   log(message.toMap().toString());
    
    
    //   PushNotification notification = PushNotification(
    //     title: message.notification?.title,
    //     body: message.notification?.body,
    //     dataTitle: message.data['title'],
    //     dataBody: message.data['body'],
    //   );

    //   setState(() {
    //     _notificationInfo = notification;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRM CLIENT',
        theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Color(0XFF68A642),
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              bodyText1: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              bodyText2: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            )),
        navigatorKey: navState,
        initialRoute: SplashWidget.id,
        onGenerateRoute: RouteGenerator.generateRoute,
        //
        //
        //
      ),
    );
  }
}



class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
