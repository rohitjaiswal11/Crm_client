// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_web_libraries_in_flutter, non_constant_identifier_names

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// top rounded container
BoxDecoration kContaierDeco = BoxDecoration(
  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  ),
);

// form fields decoration
BoxDecoration kDropdownContainerDeco = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Color(0xFFFBF8F8),
    border: Border.all(color: Colors.grey.shade200, width: 2),
    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 3)]);

EdgeInsetsGeometry kcontentPadding(width) {
  return EdgeInsets.only(left: width * 0.02, right: width * 0.02);
}

double kheight(context) {
  return MediaQuery.of(context).size.height;
}

double kwidth(context) {
  return MediaQuery.of(context).size.width;
}

// form fields text styles
TextStyle kTextformHintStyle = TextStyle(color: Colors.grey, fontSize: 10);
TextStyle kTextformStyle = TextStyle(fontSize: 12);
const Color primaryColor = Color(0xFFD20910);
const Color primaryColorLight = Color(0xFFED1B2E);
const Color drawerColoPrimary = Color(0xFF88070B);
const Color drawerColoSecondary = Color(0xFFCF0A11);

final List tickets = [];
final List discussion = [];
List<MultiFileClass> multiFileList = [];

File? imageFile;
String imagePath = '';
String fileUrl = "";
String contactId = '';
String userImage = '';
String project_id = '';
String project_name = '';
String DEVICE_TOKEN = '';
GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
String APP_SIGNATURE = '';
File? changedImage;

final List categories = [
  {'image': 'images/support_ticket.png', 'title': 'Support'},
  {'image': 'images/projects.png', 'title': 'Projects'},
  {'image': 'images/proposal.png', 'title': 'Proposals'},
  {'image': 'images/invoice.png', 'title': 'Invoices'},
  {'image': 'images/contracts.png', 'title': 'Contracts'},
  {'image': 'images/estimate.png', 'title': 'Estimates'},
];

class MultiFileClass {
  final File file;
  final String fileName;

  MultiFileClass({required this.file, required this.fileName});
}

class CommanClass {
  // static bool isLogin = false;
  static bool notifcationTapped = false;
  static RemoteMessage? noticationMessage;
}