// ignore_for_file: import_of_legacy_library_into_null_safe, file_names, use_key_in_widget_constructors, slash_for_doc_comments, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:crm_client/bottom_Navigation_bar.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../Lbm plugin/lbmplugin.dart';

class SignInScreen extends StatefulWidget {
  static const id = '/SignIn';

  @override
  _SignInStateScreen createState() => _SignInStateScreen();
}

class _SignInStateScreen extends State<SignInScreen> {
  /********** Text Editing Controller To get text from Textform field *************/

  //test3156 Test@123
  TextEditingController userController =
      TextEditingController(text: 'test3156');
  TextEditingController passwordController =
      TextEditingController(text: 'Test@123');
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  /************ Focus Node to get Focus on textFrom field*************/
  final _userFocus = FocusNode();
  final _passFocus = FocusNode();
  int _state = 0;
  List latestTickets = [];
  String? deviceToken;

  @override
  void initState() {
    super.initState();

    /******** This method is for getting FCM Token for Notification********/
    getToken();
  }

  void getToken() {
    /************** server key from FCM is saved in SharedPreference *****************/
    final _messaging = FirebaseMessaging.instance;
    SharedPreferenceClass.setSharedData("TokenKey",
        "AAAAMue_ylA:APA91bHIASApWJVz-VTt2PJ0wVGo4lik1x9OtO290ECgYgFemSBFM6R5uRDdLHO_riqN9XQO12r2AJwu1j-BjSp7zZpHVdZopjCsOuqOLB5E0bPKtyfLauV97cRqI9ZfTCCrMu2spAHy");
    _messaging.getToken().then((token) {
      log("$token");
      SharedPreferenceClass.setSharedData("TokenID", token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(color: Colors.amber,
            image: DecorationImage(
              image: AssetImage("assets/signin_bg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 150.0,
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  )),
              SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: userController,
                    textInputAction: TextInputAction.next,
                    focusNode: _userFocus,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _userFocus, _passFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //hintText: 'Username',
                        labelText: 'Username'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.done,
                    focusNode: _passFocus,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is Empty';
                      }
                      return null;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //  hintText: 'Password',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Center(
                  child: Container(
                    height: 50.0,
                    width: 320,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).primaryColor,
                        Color(0xff3a7b7d)
                      ]),
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: MaterialButton(
                      child: setUpButton(),
                      onPressed: () {
                        setState(() {
                          if (_state == 0) {
                            if (_formKey.currentState!.validate()) {
                              animateButton();
                              _loginUser();
                            }
                          }
                        });
                      },
                      height: 50,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 8.0, right: 8.0),
                child: Text('Forgot Your Password?',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey)),
              ),
              SizedBox(
                height: 6.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Text('Do not have an Account?',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                    Text('Sign up',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  //This method is used for uploading data on server
  Future<void> _loginUser() async {
    final tokenId = await SharedPreferenceClass.getSharedData("TokenID");
    final tokenKey =
        await await SharedPreferenceClass.getSharedData("TokenKey");

    final paramDic = {
      "username": userController.text,
      "password": passwordController.text,
      "tokenid": tokenId,
      "tokenkey": tokenKey
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.LOGIN_URL, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data);
    if (data["status"] == 1) {
      latestTickets = data['data']['ticket_detail'];
      tickets.addAll(latestTickets);
      _state = 2;
      log('resp data --> $data');
      //Adding user Data in sharedPreference
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
          "last_login", data["data"]['client_info']["last_login"]);
      SharedPreferenceClass.setSharedData(
          'task', data["data"]['client_info']["task_emails"]);
      SharedPreferenceClass.setSharedData(
          'project', data["data"]['client_info']["project_emails"]);

      SharedPreferenceClass.setSharedData("password", passwordController.text);
      ToastShowClass.toastShow(context, 'Successfully Logged In', Colors.green);
      Navigator.of(context).pushReplacementNamed(BottomBar.id);
    } else {
      ToastShowClass.toastShow(context, data["message"], Colors.red);
      _state = 0;
    }
    setState(() {
      setUpButton();
    });
  }

  //Method to handle Progress bar on Login Button
  setUpButton() {
    if (_state == 0) {
      return Text(
        "Login",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  //Timmer for progress bar loading
  void animateButton() {
    setState(() {
      _state = 1;
    });
    Timer(Duration(milliseconds: 4000), () {});
  }
}

// Handle the keyboard focus on TextFormField
void _fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
