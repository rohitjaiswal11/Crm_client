// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe, prefer_if_null_operators, file_names

import 'dart:convert';

import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

class DiscussionTab extends StatefulWidget {
  String projectId;

  DiscussionTab({required this.projectId});

  @override
  State<DiscussionTab> createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<DiscussionTab> {
  List discussionList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    //method to get discussion List
    getDiscussionList();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : discussionList.isEmpty
            ? Center(
                child: Text('No Data'),
              )
            : ListView.builder(
                itemCount: discussionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return discussionDetailsContainer(
                      kheight(context), kwidth(context), index);
                });
  }

  Widget discussionDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discussionList[index]['subject'] == null
                      ? ''
                      : discussionList[index]['subject'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Last Activity: ',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                        Text(
                            discussionList[index]['last_activity'] == null
                                ? ' '
                                : discussionList[index]['last_activity'],
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600))
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total Comments: ',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    Text(discussionList[index]['discussion'].length.toString(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            onTap: () {
              discussionList[index]['project_Discussion'].length > 0
                  ? Navigator.of(context).pushNamed("/DiscussionList",
                      arguments: discussionList[index]['project_Discussion'])
                  : '';
            },
          )),
    );
  }

//Api Call to fetch data from Server
  Future<void> getDiscussionList() async {
    final paramDic = {
      'projectid': widget.projectId,
      'project_detailtype': 'discussion'
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_PROJECT_DETAIL, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      setState(() {
        isLoading = false;
        discussionList = data['data'];
      });
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
          if (discussionList.isEmpty) {
            ToastShowClass.toastShow(
                context, 'Discussion List is Empty', Colors.green);
          } else {
            ToastShowClass.toastShow(context, data['message'], Colors.red);
          }
        });
      }
    }
  }
}
