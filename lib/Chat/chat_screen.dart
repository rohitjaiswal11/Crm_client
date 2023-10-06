import 'dart:convert';
import 'dart:developer';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../util/ApiClass.dart';
import '../util/LicenseKey.dart';
import '../util/ToastClass.dart';
import '../util/constants.dart';

class Chat_Screen extends StatefulWidget {
  static const id = 'ChatScreen';
  chatdata passdata;
  Chat_Screen({required this.passdata});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  List OldMessage = [];
  bool isLoading = true;
  int turn = 1;
  bool isSend = false;
  String myid = "";
  TextEditingController messageController = TextEditingController();
  bool isRefreshloading = false;
  @override
  void initState() {
    myid = widget.passdata.myid.toString();
    OldChat().then((value) => UpdateUnreadmessage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemHeight = kheight(context) * 0.045;
    final itemWidth = kwidth(context) * 0.1;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 4),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: kheight(context) * 0.06,
            width: kwidth(context) * 0.7,
            decoration: BoxDecoration(color: Colors.white),
            child: TextFormField(
              controller: messageController,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 15, color: Colors.black87),
              decoration: InputDecoration(
                contentPadding: kcontentPadding(kwidth(context)),
                hintText: 'Type message...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          isSend
              ? SizedBox(
                  height: kheight(context) * 0.06,
                  width: kheight(context) * 0.065,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )),
                )
              : InkWell(
                  onTap: () {
                    if (messageController.text.isNotEmpty) {
                      SendMessage();
                    }
                  },
                  child: Container(
                    height: kheight(context) * 0.06,
                    width: kheight(context) * 0.065,
                    margin: EdgeInsets.only(top: 4, right: 4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    )),
                  ),
                )
        ]),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(children: [
          Container(
            height: kheight(context) * 0.2,
            padding: EdgeInsets.only(
                left: kwidth(context) * 0.04, top: kheight(context) * 0.1),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
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
                    width: kwidth(context) * 0.05,
                  ),
                  Text(
                    '${widget.passdata.friendname.toString()}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 18),
                  ),
                  Spacer(),

                  IconButton(
                    onPressed: () async {
                      OldChat();
                      for (var i = 0; i < 4; i++) {
                        await Future.delayed(Duration(milliseconds: 100), () {
                          turn = turn + 1;
                          setState(() {});
                        });
                      }

                      setState(() {
                        isRefreshloading = true;
                      });
                      print("00000");
                    },
                    icon: RotatedBox(
                      quarterTurns: turn,
                       
                      child: Icon(
                        Icons.refresh,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: kwidth(context) * 0.05,
                  ),
                  // Text('Refresh' , style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w800,
                  //       letterSpacing: 1,
                  //       fontSize: 14),)
                ],
              ),
            ),
          ),
          Container(
            height: kheight(context) * 0.8,
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : OldMessage.isEmpty || OldMessage.length == 0
                    ? Center(
                        child: Text("No Chat History"),
                      )
                    : RefreshIndicator(
                        onRefresh: () => OldChat(),
                        child: ListView.builder(
                            reverse: true,
                            itemCount: OldMessage.length,
                            padding: EdgeInsets.only(
                                top: 5, bottom: kheight(context) * 0.08),
                            itemBuilder: (BuildContext context, int ind) {
                              int i = (OldMessage.length - 1) - ind;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //For Friend message
                                  OldMessage[i]["sender_id"] != myid
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                OldMessage[i]["message"]
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                          ),
                                        )
                                      : SizedBox(),

                                  //For own message
                                  OldMessage[i]["sender_id"] == myid
                                      ? Container(
                                          constraints: BoxConstraints(
                                            maxWidth: kwidth(context) * 0.7,
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: 10, right: 10, left: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                OldMessage[i]["message"]
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.visible,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              );
                            }),
                      ),
          )
        ]),
      ),
    );
  }

  Future<void> OldChat() async {
    final paramDic = {
      "staff_id": myid.toString(),
      "type": "Client",
      "reciever_id": widget.passdata.friendid.toString()
    };
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          ApiClass.OldChatList, paramDic, "Get", Api_Key_by_Admin);
      var data = json.decode(response.body);
      //log(data.toString());
      if (data["status"] == 1) {
        OldMessage.clear();
        OldMessage.addAll(data["data"]);
      } else {
        ToastShowClass.toastShow(context, "No data", Colors.red);
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

  Future<void> UpdateUnreadmessage() async {
    final paramDic = {
      "id": myid.toString(),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.UPDATE_READMESSAGE, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log("$paramDic   " + data.toString());
    if (data["status"] == 1) {
    } else {}
  }

  Future<void> SendMessage() async {
    final paramdic = {
      "sender_id": myid,
      "reciever_id": widget.passdata.friendid,
      "message": messageController.text.toString(),
    };
    messageController.text = "";
    setState(() {
      isSend = true;
    });
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.SEND_MESSAGE, paramdic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data["status"] == 1) {
      OldChat();
    } else {
      ToastShowClass.toastShow(context, data["message"].toString(), Colors.red);
    }
    setState(() {
      isSend = false;
    });
  }

  void refreshUI() {
    OldChat();
  }
}
