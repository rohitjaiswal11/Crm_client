// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_if_null_operators, import_of_legacy_library_into_null_safe, avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Project/project_detail_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

class ProjectScreen extends StatefulWidget {
  static const id = 'Project';
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List projectList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    //Method to get ProjectList
    getProjectList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                padding:
                    EdgeInsets.symmetric(horizontal: kwidth(context) * 0.05),
                child: Row(
                  children: [
                    SizedBox(
                      height: kheight(context) * 0.08,
                      width: kwidth(context) * 0.17,
                      child: Image.asset(
                        'assets/projects.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: kwidth(context) * 0.03,
                    ),
                    Text(
                      KeyValues.projects,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: kheight(context) * 0.05,
            ),
            Container(
              height: kheight(context) * 0.75,
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
                    : ListView.builder(
                        itemCount: projectList.length,
                        itemBuilder: (c, i) => projectDetailsContainer(
                            kheight(context), kwidth(context), i),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget projectDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProjectDetailScreen.id,
            arguments: PassData(
                id: projectList[index]['id'],
                url: projectList[index]['name'],
                status: projectList[index]["status_name"]));
      },
      child: Stack(
        children: [
          Container(
            height: height * 0.10,
            margin: EdgeInsets.only(bottom: height * 0.015),
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.005),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      "#" +
                          projectList[index]['id'] +
                          ' ' +
                          (projectList[index]['name'] == null
                              ? ''
                              : projectList[index]['name']),
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${KeyValues.startDate} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              projectList[index]['start_date'] ?? '',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        Row(
                          children: [
                            Text(
                              '${KeyValues.lastDate} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              projectList[index]['deadline'] ?? '',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: width * 0.22,
              height: height * 0.035,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    projectList[index]['status_name'] == null
                        ? 'NA'
                        : projectList[index]['status_name'],
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getProjectList() async {
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData("user_id"),
      "category": "project"
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_CATEGORY_DATA, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    print("DATA    " + data.toString());
    if (data["status"] == 1) {
      setState(() {
        isLoading = false;
        projectList = data["data"];
      });
    } else {
      setState(() {
        isLoading = false;
        if (projectList.isEmpty) {
          ToastShowClass.toastShow(
              context, 'Project List is Empty', Colors.green);
        } else {
          ToastShowClass.toastShow(context, data["message"], Colors.red);
        }
      });
    }
  }
}
