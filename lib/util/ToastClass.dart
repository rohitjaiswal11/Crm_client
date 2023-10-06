// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastShowClass {
  //Display the Toast
  static void toastShow(
      BuildContext context, String ToastValue, MaterialColor _color) {
    Fluttertoast.showToast(
        msg: ToastValue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: _color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
