// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe, non_constant_identifier_names, must_be_immutable, avoid_print, unnecessary_null_comparison, prefer_if_null_operators, deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:async/async.dart';
import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/AttachmentDialog.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/PreviewDialogBox.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart' as http;
import 'package:lbm_plugin/lbm_plugin.dart';

class TicketDetailScreen extends StatefulWidget {
  static const id = 'ticketDetail';
  PassTicketData data;
  TicketDetailScreen({required this.data});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  int? state;
  List ticketReply = [];
  bool isLoading = true;
  final HtmlEditorController controllerhtml = HtmlEditorController();
  List<Attachment> NotUploadTicket = [];

  ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  // File? image;
  bool isCaptured = true;

  @override
  void initState() {
    multiFileList.clear();

    super.initState();

    //Initially getting Ticket reply history
    getTicketsReply("yes", "history");
  }

//api call to add support ticket using multipart because we are adding image too
  Future addTicketReply(
      List<MultiFileClass> multiFileList, String replyType, String msg) async {
    final uri = Uri.https(ApiClass.BaseURL, ApiClass.TICKET_REPLY);
    print("Add_Ticket" + uri.toString());
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (ApiClass.api_key);
    request.fields['userid'] =
        await SharedPreferenceClass.getSharedData('user_id');
    request.fields['ticketid'] = widget.data.id;
    request.fields['message'] = await controllerhtml.getText();
    request.fields['replydata'] = replyType;
    print("ADD_Ticket_Data" + request.toString());
    var file;

    if (multiFileList.isNotEmpty) {
      for (var i = 0; i < multiFileList.length; i++) {
        var stream = http.ByteStream(
            DelegatingStream.typed(multiFileList[i].file.openRead()));
        var length = await multiFileList[i].file.length();
        file = http.MultipartFile('attachments[]', stream, length,
            filename: multiFileList[i].file.path.split("/").last);
        request.files.add(file);
      }
    }
    log('-- params ${request.fields}');
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("Add_Ticket_Image" + response.statusCode.toString());
      if (response.statusCode == 200) {
        multiFileList.clear();
        setState(() {
          isCaptured = true;
          // images_list.add(new Data(image.path.split("/").las));
          //_replyList.add(new TicketReply(username, replyController.text, DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),images_list));
          if (ticketReply.isNotEmpty) {
            controller.jumpTo(controller.position.maxScrollExtent);
          }
          //imagePath=null;
          controllerhtml.clear();
        });
        getTicketsReply("yes", "history");
      }
    });
  }

  //api call to get ticket reply history from server
  Future<void> getTicketsReply(String replyType, String msg) async {
    final paramDic = {
      "userid": await SharedPreferenceClass.getSharedData('user_id'),
      "replydata": replyType,
      "message": msg,
      "ticketid": widget.data.id
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.TICKET_REPLY, paramDic, 'Post', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      try {
        setState(() {
          if (replyType == "yes") {
            //fetch reply
            state = 1;
            imageFile = null;
            // image = null;

            ticketReply = data['data'];
            isCaptured = true;
            isLoading = false;
          } else {
            // send reply
            setState(() {
              state = 1;
              /*   ticketreplynew.add(new fetchdata(
                ticketReply[i]['submitter']
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                replyController.text,
                NotUploadTicket));*/
              if (ticketReply.isNotEmpty) {
                controller.jumpTo(controller.position.maxScrollExtent);
              }
              // replyController.text = '';
              isCaptured = true;
              isLoading = false;
            });
          }
        });
      } catch (e) {
        setState(() {
          isCaptured = true;

          isLoading = false;
        });
      }
    } else {
      ticketReply.clear();
      isCaptured = true;
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(multiFileList.length);
    // controllerhtml.clear();
    // print('Hello');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: kheight(context) * 0.25,
                  padding: EdgeInsets.only(
                      left: kwidth(context) * 0.04,
                      top: kheight(context) * 0.1),
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
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: kwidth(context) * 0.01,
                        ),
                        Text(
                          'SECOMUSA ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              fontSize: 18),
                        ),
                        Text(
                          'LLC',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w200,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: kheight(context) * 0.22),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: kwidth(context) * 0.05,
                          vertical: kheight(context) * 0.012),
                      decoration: BoxDecoration(
                        color: Color(0xFF426C29),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        widget.data.url,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kheight(context) * 0.49,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
                      height: 50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                            widget.data.description == null
                                ? ''
                                : widget.data.description,
                            style: TextStyle(color: Colors.black87)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kheight(context) * 0.38,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0)),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ticketReply.isNotEmpty
                                ? ListView.builder(
                                    // reverse:true,
                                    controller: controller,
                                    itemCount: ticketReply.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
//                            return buildList(context, index);
                                      return _buildMessage(context, index);
                                    })
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Center(
                                          child: Text(
                                              " No reply for this ticket yet")),
                                    ),
                                  ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: kheight(context) * 0.02,
            ),
            Form(
              key: _formKey,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kwidth(context) * 0.03,
                      vertical: kheight(context) * 0.01),
                  width: kwidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 3,
                            blurStyle: BlurStyle.outer)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: kheight(context) * 0.3,
                          child: HtmlEditor(
                            controller: controllerhtml,
                            htmlEditorOptions:
                                HtmlEditorOptions(hint: 'Your Text Here'),
                            otherOptions: OtherOptions(
                              decoration: kDropdownContainerDeco,
                            ),
                          )),
                      SizedBox(
                        height: kheight(context) * 0.03,
                      ),
                      Container(
                        width: kwidth(context),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                showGeneralDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionBuilder:
                                        (context, a1, a2, widget) {
                                      return Transform.scale(
                                        scale: a1.value,
                                        child: Opacity(
                                          opacity: a1.value,
                                          child: AttachmentAddDialogBox(
                                              isMultiImage: true),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        Duration(milliseconds: 400),
                                    barrierDismissible: false,
                                    barrierLabel: '',
                                    context: context,
                                    pageBuilder:
                                        (context, animation1, animation2) {
                                      return SizedBox();
                                    }).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Icon(
                                Icons.image,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: kwidth(context) * 0.02,
                            ),
                            SizedBox(
                              width: kwidth(context) * 0.3,
                              child: Text(
                                multiFileList.isEmpty
                                    ? "No File"
                                    : multiFileList.length > 1
                                        ? 'Multiple Files Selected'
                                        : multiFileList.first.fileName,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            if (multiFileList.length > 1)
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return multipleItemDialog(
                                              kheight(context) , kwidth(context));
                                        }).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('View All',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).primaryColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w700))),
                            state == 0
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ))
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        state = 0;
                                      });
                                      addTicketReply(multiFileList, "no",
                                          controllerhtml.getText().toString());
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: kheight(context) * 0.01,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //showing reply list items data on List view
  _buildMessage(BuildContext context, int index) {
    // print(
    //     'Attachements ' + ticketReply[index]['attachments'].length.toString());
    Widget msg = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      /* decoration: BoxDecoration(
        // color: Color(0xFFFFEFEE),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0))),*/
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // getDashboard(ticketreply[index]['attachments'][0]['file_name'].toString()==null?'':ticketreply[index]['attachments'][0]['file_name'].toString()),
          Text(
            ticketReply[index]['submitter'] == null
                ? ''
                : ticketReply[index]['submitter'].toString(),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0;
                    i < ticketReply[index]['attachments'].length;
                    i++)
                  InkWell(
                    onTap: () async {
                      fileUrl = "https://" +
                          ApiClass.BaseURL +
                          '/crm/download/preview_image?path=uploads/ticket_attachments/' +
                          widget.data.id +
                          "/" +
                          ticketReply[index]['attachments'][i]['file_name'] +
                          "&" +
                          ticketReply[index]['attachments'][i]['filetype'];
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                opacity: a1.value,
                                child: PreviewDialogBox(),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 100),
                          barrierDismissible: false,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {
                            return SizedBox(
                              height: kheight(context) * 0.1,
                            );
                          });
                    },
                    child: ticketReply[index]['attachments'][i]['filetype'] ==
                            "application/pdf"
                        ? Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/proposal.png')),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: NetworkImage("https://" +
                                  ApiClass.BaseURL +
                                  "/crm/download/preview_image?path=uploads/ticket_attachments/" +
                                  widget.data.id +
                                  "/" +
                                  ticketReply[index]['attachments'][i]
                                      ['file_name'] +
                                  "&" +
                                  ticketReply[index]['attachments'][i]
                                      ['filetype']),
                            )),
                          ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
              ticketReply[index]['message'] == null
                  ? ''
                  : ticketReply[index]['message'].toString(),
              style: TextStyle(color: Colors.black87, fontSize: 12)),
          // widget.TicketData[0]['attachment'].length>0?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                ticketReply[index]['date'] == null
                    ? "Date: " ''
                    : ticketReply[index]['date'].toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 10),
              ),
            ],
          ),
//

          Divider(
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );

    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }
  //this method will call once user select image from gallery and camera

  // getCapturedImage() {
  //   setState(() {
  //     image = imageFile;
  //     if (image != null) {
  //       isCaptured = false;
  //       imagePath = image!.path.split('/').last;
  //     }
  //   });
  // }
}

//model class for list NotUploadTicket
class Attachment {
  String FileName;
  String FileType;

  Attachment(this.FileName, this.FileType);
}

//Model class for Ticket reply List
class TicketReply {
  String submitter;
  String message;
  String date;
  List attachments;

  TicketReply(this.submitter, this.message, this.date, this.attachments);
}
