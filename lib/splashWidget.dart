// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, avoid_print, prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:crm_client/SignInScreen.dart';
import 'package:crm_client/bottom_Navigation_bar.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import '../../Lbm plugin/lbmplugin.dart';

class SplashWidget extends StatefulWidget {
  static const id = '/';
  @override
  State<StatefulWidget> createState() {
    return _SplashWidget();
  }
}

class _SplashWidget extends State<SplashWidget> {
  List latestTickets = [];
  Timer? timer;

  //initialise FirebaseMessaging

  @override
  void initState() {
    super.initState();
    initPlatformState(context);
  }

  //getting fcm token when token is not null checkData() will called
  //also saving server key from Firebase Console to shared preference
  void getToken() {
    checkData();
  }

  Future<void> initPlatformState(BuildContext context) async {
    var platformVersion = await LbmPlugin.platformVersion(
        Base_Url_For_App, Purchase_Code_envato, Licence_Key_by_Admin);
    var data = json.decode(platformVersion.body);
    print('-->' + data['message'].toString());
    if (data['message'] == "Allow") {
      setState(() {
        //getting firebase token
        getToken();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image:
                  DecorationImage(image: AssetImage('assets/splash_bg.jpg'))),
        ));
  }

  //checking user exist in sharedPreference or not
  Future<void> checkData() async {
    if (await SharedPreferenceClass.getSharedData("user_id") != null) {
      checkLoginData();
    } else {
      timer = Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.of(context).pushReplacementNamed(SignInScreen.id);
        });
      });
    }
  }

  //Api call to logged in user into app using parameter username, password,tokenid and tokenkey
  Future<void> checkLoginData() async {
    final paramDic = {
      "username": await SharedPreferenceClass.getSharedData("email"),
      "password": await SharedPreferenceClass.getSharedData("password"),
      "tokenid": await SharedPreferenceClass.getSharedData("TokenID") ?? '',
      "tokenkey": await SharedPreferenceClass.getSharedData("TokenKey") ?? '',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.LOGIN_URL, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data);
    if (data["status"] == 1) {
      setState(() {
        latestTickets = data['data']['ticket_detail'];
        tickets.addAll(latestTickets);
        SharedPreferenceClass.setSharedData(
            "user_id", data["data"]['client_info']["userid"]);
        SharedPreferenceClass.setSharedData(
            "contact_id", data["data"]['client_info']["id"]);
        SharedPreferenceClass.setSharedData(
            "first_name", data["data"]['client_info']["firstname"]);
        SharedPreferenceClass.setSharedData(
            "last_name", data["data"]['client_info']["lastname"]);
        SharedPreferenceClass.setSharedData(
            "email", data["data"]['client_info']["email"]);
        SharedPreferenceClass.setSharedData(
            "phone", data["data"]['client_info']["phonenumber"]);
        SharedPreferenceClass.setSharedData(
            "image", data["data"]['client_info']["profile_image"]);
        SharedPreferenceClass.setSharedData(
            'task', data["data"]['client_info']["task_emails"]);
        SharedPreferenceClass.setSharedData(
            'project', data["data"]['client_info']["project_emails"]);
        SharedPreferenceClass.setSharedData(
            "last_login", data["data"]['client_info']["last_login"]);
      });
      SharedPreferenceClass.setSharedData(
          "password", await SharedPreferenceClass.getSharedData("password"));
      Navigator.of(context).pushReplacementNamed(BottomBar.id);
    } else {
      print('Status' + data['status'].toString());
      Navigator.of(context).pushReplacementNamed(SignInScreen.id);
    }
  }
}
