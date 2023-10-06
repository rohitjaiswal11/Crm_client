// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, import_of_legacy_library_into_null_safe, deprecated_member_use

import 'dart:convert';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/projectDiscussion.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/projectFiles.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/projectOverview.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/projectTickets.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

class ProjectDetailScreen extends StatefulWidget {
  static const id = 'projectDetailScreen';
  PassData data;
  ProjectDetailScreen({required this.data});
  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? index;
  List projectDetail = [];
  bool isLoading = true;

  // Api Call to fetch Project Detail from server
  // using projectid and project_detailtype
  Future<void> getProjectDetail() async {
    final paramDic = {
      'projectid': widget.data.id,
      'project_detailtype': 'project'
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_PROJECT_DETAIL, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      setState(() {
        isLoading = false;
        projectDetail = data['data'];
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
      // Do whatever you want based on the tab index
    });
    super.initState();
    getProjectDetail();
  }

  @override
  Widget build(BuildContext context) {
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
                        SizedBox(
                          height: kheight(context) * 0.08,
                          width: kwidth(context) * 0.2,
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
                        "#" + widget.data.id + "-" + widget.data.url,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kheight(context) * 0.07,
            ),
            Stack(
              children: [
                Container(
                  height: kheight(context) * 0.64,
                  margin: EdgeInsets.only(top: kheight(context) * 0.02),
                  padding: EdgeInsets.only(
                      left: kwidth(context) * 0.05,
                      right: kwidth(context) * 0.05,
                      top: kheight(context) * 0.04),
                  width: kwidth(context),
                  decoration: kContaierDeco,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // 1st Tab (Project OverView)
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ProjectOverView(
                              projectDetail: projectDetail,
                              status: widget.data.status,
                            ),
                      // 2nd Tab (Files) (Files)
                      ProjectFiles(projectId: widget.data.id),
                      // 3rd Tab (Discussion)
                      DiscussionTab(projectId: widget.data.id),
                      // 4th Tab (Tickets)
                      ProjectTickets(
                          projectId: widget.data.id,
                          projectName: widget.data.url)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kwidth(context) * 0.07),
                  child: Container(
                    height: kheight(context) * 0.04,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ]),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF426C29),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                      ),
                      unselectedLabelColor: Colors.grey.shade600,
                      onTap: (_) {
                        setState(() {
                          _tabController.index;
                        });
                      },
                      tabs: [
                        Text(
                          KeyValues.projectOverview,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.files,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.discussion,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.tickets,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
