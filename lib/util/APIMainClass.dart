// ignore_for_file: unused_import, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names, avoid_print

import 'dart:convert';

import 'package:crm_client/util/ApiClass.dart';
import 'package:http/http.dart' as http;


Future<http.Response> APIMainClass(
    String SubURL, Map<String, dynamic> paramDic, String PostGet) async {
  var response;
  switch (PostGet) {
    //Get Method Work
    case "Get":
      final uri = Uri.https(ApiClass.BaseURL, SubURL, paramDic);
      print("Get :" + uri.toString());
      response = await http.get(uri, headers: {
        "Accept": "application/json",
        'authtoken': ApiClass.api_key
      });
      return response;

    //Post Method Work
    case "Post":
      final uri = Uri.https(ApiClass.BaseURL, SubURL);
      print("Post :" + uri.toString());
      response = await http.post(uri,
          headers: {
            "Accept": "application/json",
            'authtoken': ApiClass.api_key
          },
          body: paramDic);

      return response;

    case "Put":
      final uri = Uri.https(ApiClass.BaseURL, SubURL);
      print("Put :" + uri.toString());
      response = await http.post(uri,
          headers: {
            "Accept": "application/json",
            'authtoken': ApiClass.api_key
          },
          body: paramDic);

      return response;

    case "Delete":
      break;
  }
  return response;
}
