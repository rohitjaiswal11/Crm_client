import 'dart:convert';
import 'dart:developer';

import 'package:crm_client/Chat/chat_screen.dart';
import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../util/ApiClass.dart';
import '../util/LicenseKey.dart';
import '../util/ToastClass.dart';
import '../util/constants.dart';
import '../util/storage_manger.dart';

class clientlisting extends StatefulWidget {
  static const id = 'clientlist';

  @override
  State<clientlisting> createState() => _clientlistingState();
}

class _clientlistingState extends State<clientlisting> {
  List clientlist = [];
  List Allclientlist = [];
  bool isLoading = true;

  @override
  void initState() {
    getclientlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: kheight(context) * 0.2,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kwidth(context) * 0.05),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: kwidth(context) * 0.02,
                  ),
                  SizedBox(
                    height: kheight(context) * 0.08,
                    width: kwidth(context) * 0.15,
                    child: Image.asset(
                      'assets/chat.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: kwidth(context) * 0.03,
                  ),
                  Text(
                    KeyValues.Chat,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              height: height * 0.06,
              width: width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.06,
                    width: width * 0.75,
                    child: TextFormField(
                      autofocus: false,
                      onChanged: onSearchTextChanged,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.01),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.06,
                    width: width * 0.11,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: kheight(context) * 0.03,
          ),
          Container(
            height: kheight(context) * 0.65,
            margin: EdgeInsets.only(top: kheight(context) * 0.025),
            padding: EdgeInsets.symmetric(
                horizontal: kwidth(context) * 0.05,
                vertical: kheight(context) * 0.04),
            width: kwidth(context),
            decoration: kContaierDeco,
            child: SizedBox(
              height: kheight(context) * 0.3,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : clientlist.isEmpty || clientlist.length == 0
                      ? Center(
                          child: Text("No Data"),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: clientlist.length,
                          itemBuilder: (c, i) {
                            return Container(
                              height: height * 0.08,
                              margin: EdgeInsets.only(bottom: height * 0.015),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  color: Color(0xFFF8F8F8),
                                  borderRadius: BorderRadius.circular(6)),
                              child: ListTile(
                                onTap: () async {
                                  String id =
                                      await SharedPreferenceClass.getSharedData(
                                          "contact_id");
                                  Navigator.pushNamed(context, Chat_Screen.id,
                                      arguments: chatdata(
                                        myid: "client_" + id,
                                        friendid:
                                            "staff_" + clientlist[i]["staffid"],
                                        friendname: clientlist[i]["firstname"] +
                                            clientlist[i]["lastname"],
                                      ));
                                },
                                leading: clientlist[i]["profile_image"] == null
                                    ? CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundImage: NetworkImage(
                                            ApiClass.IMAGEBASEURL +
                                                clientlist[i]["staffid"] +
                                                "/thumb_" +
                                                clientlist[i]["profile_image"]),
                                      ),
                                title: Text(
                                    clientlist[i]["firstname"].toString() +
                                        clientlist[i]["lastname"].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> getclientlist() async {
    final paramDic = {"": ""};
    clientlist.clear();
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          ApiClass.StaffClientList, paramDic, "Post", Api_Key_by_Admin);
      var data = json.decode(response.body);
      log(data.toString());
      if (data["status"] == 1) {
        clientlist.addAll(data["data"]);
        Allclientlist.addAll(data["data"]);
      } else {
        ToastShowClass.toastShow(
            context, data["message"].toString(), Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ToastShowClass.toastShow(context, e.toString(), Colors.red);
      setState(() {
        isLoading = false;
      });
    }
  }

  onSearchTextChanged(String text) async {
    clientlist.clear();
    if (text.isEmpty) {
      setState(() {
        clientlist.addAll(Allclientlist);
      });
      return;
    }
    setState(() {
      clientlist.addAll(
        Allclientlist.where((item) {
          return item['firstname']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()) ||
              item["lastname"]
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase());
        }),
      );
      clientlist.toSet().toList();
    });
  }
}
