// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print
import 'dart:convert';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/project_AddTicket.dart';
import 'package:crm_client/Support/ticket_details_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import '../../Lbm plugin/lbmplugin.dart';

class ProjectTickets extends StatefulWidget {
  String projectId, projectName;
  ProjectTickets({required this.projectId, required this.projectName});
  @override
  State<ProjectTickets> createState() => _ProjectTicketsState();
}

class _ProjectTicketsState extends State<ProjectTickets> {
  bool isLoading = true;
  List ticketData = [];

  @override
  void initState() {
    super.initState();
    print("INIT_ID" " " + widget.projectId);
    project_id = widget.projectId;
    project_name = widget.projectName;

    //Getting tickets related to that project
    getProjectTicket();
  }

  //Api call to get data from server using user_id, project_ids
  Future<void> getProjectTicket() async {
    final paramDic = {
      'id': await SharedPreferenceClass.getSharedData('contact_id'),
      'project_id': project_id
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_SUPPORT, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      setState(() {
        isLoading = false;
        ticketData = data['data'];
      });
    } else {
      setState(() {
        isLoading = false;
        if (ticketData.isEmpty) {
          ToastShowClass.toastShow(context, 'No Ticket is found', Colors.green);
        } else {
          ToastShowClass.toastShow(context, data['message'], Colors.red);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, ProjectAddTicket.id,
                  arguments:
                      PassData(id: widget.projectId, url: widget.projectName))
              .then((value) => getProjectTicket());
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: kheight(context) * 0.55,
          padding: EdgeInsets.symmetric(
              horizontal: kwidth(context) * 0.02,
              vertical: kheight(context) * 0.02),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ticketData.isEmpty
                  ? Center(
                      child: Text('No Data'),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: kheight(context) * 0.02),
                      itemCount: ticketData.length,
                      itemBuilder: (c, i) => ticketDetailsContainer(
                          kheight(context), kwidth(context), i)),
        ),
      ),
    );
  }

  Widget ticketDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(TicketDetailScreen.id,
            arguments: PassTicketData(
                ticketData[index]['ticketid'],
                "#" +
                    ticketData[index]['ticketid'] +
                    "-" +
                    ticketData[index]['subject'],
                ticketData[index]['message']));
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
                    Row(
                      children: [
                        Text(
                          ticketData[index]['subject'] == null
                              ? ''
                              : "#" + ticketData[index]['ticketid'],
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        SizedBox(
                          width: kwidth(context) * 0.35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              ticketData[index]['project_id_name'] == null
                                  ? ' '
                                  : '(${ticketData[index]['project_id_name']})',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${KeyValues.department} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              ticketData[index]['department_name'] ?? ' ',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Text(
                          '${KeyValues.lastReply} :',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        SizedBox(
                          width: kwidth(context) * 0.16,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              ticketData[index]['lastreply'] ?? ' ',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${KeyValues.priority} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              ticketData[index]['priority_name'] ?? ' ',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.12,
                        ),
                        Row(
                          children: [
                            Text(
                              '${KeyValues.date} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              ticketData[index]['date'] ?? ' ',
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
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    ticketData[index]['status_name'] ?? '',
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
}
