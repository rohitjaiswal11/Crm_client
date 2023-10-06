// ignore_for_file: prefer_const_constructors, file_names, prefer_final_fields, avoid_print

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Profile/editProfile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'ContactUs/details_screen.dart';
import 'main.dart';
import 'util/constants.dart';

class BottomBar extends StatefulWidget {
  static const id = 'bottombar';
  const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  checkNotification() async {
    if (CommanClass.notifcationTapped) {
      PushNotification notification = PushNotification(
        title: CommanClass.noticationMessage?.notification?.title,
        body: CommanClass.noticationMessage?.notification?.body,
        dataTitle: CommanClass.noticationMessage?.data['title'],
        dataBody: CommanClass.noticationMessage?.data['body'],
      );

      final _notificationInfo = notification;
      ;
      showOverlayNotification(
        (context) {
          return Material(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     side: BorderSide(color: Colors.white, width: 0.3)),
            // elevation: 1,
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                selected: true,
                selectedTileColor: Colors.white,
                selectedColor: Theme.of(context).primaryColor,
                title: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      _notificationInfo.title ?? 'CRM',
                      style: TextStyle(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )),
                subtitle: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      _notificationInfo.body ?? '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    )),
                leading: Image.asset(
                  'assets/appLogo.png',
                  height: 50,
                  width: 50,
                ),
                trailing: IconButton(
                    onPressed: () {
                      OverlaySupportEntry.of(context)?.dismiss();
                    },
                    icon: Icon(Icons.close)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 0.3)),
              ),
            ),
          );
        },
        // Text(_notificationInfo!.title ?? 'CRM'),
        // leading: NotificationBadge(totalNotifications: _totalNotifications),
        // Text(_notificationInfo!.body ?? '-'),
        context: navState.currentContext,
        position: NotificationPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await checkNotification();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Page=====>" + _page.toString());
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: pagesList[_page],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: height * 0.07,
        key: _bottomNavigationKey,
        index: 0,
        items: [
          Icon(
            Icons.dashboard,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.headphones_outlined,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.settings,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ],
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        buttonBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

List<Widget> pagesList = [
  DashBoardScreen(),
  DetailsScreen(),
  EditProfile(),
];
