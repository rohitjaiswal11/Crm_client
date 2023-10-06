// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_if_null_operators, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Support/add_ticket_screen.dart';
import 'package:crm_client/Support/ticket_details_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

class SupportScreen extends StatefulWidget {
  static const id = 'Support';
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List ticketStatus = [];
  List ticketData = [];
  List aLLticketData = [];

  Color? boxcolor;
  bool isLoading = true;
  bool isSlide = false;

  @override
  void initState() {
    super.initState();
    //getting all tickets data
    getSupportTicketStatus("");
  }

  onSearchTextChanged(String text) async {
    ticketData.clear();
    if (text.isEmpty) {
      setState(() {
        ticketData.addAll(aLLticketData);
      });
      return;
    }

    setState(() {
      ticketData.addAll(
        aLLticketData.where((item) {
          return item['subject']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()) ||
              item['project_id_name']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()) ||
              item['department_name']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase());
        }),
      );
      ticketData.toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.pushNamed(context, AddTicket.id);
        },
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: kheight(context) * 0.21,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kwidth(context) * 0.05),
                      child: Row(
                        children: [
                          SizedBox(
                            height: kheight(context) * 0.08,
                            width: kwidth(context) * 0.15,
                            child: Image.asset(
                              'assets/newticket.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: kwidth(context) * 0.03,
                          ),
                          Text(
                            KeyValues.support_tickets,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: kheight(context) * 0.16),
                    padding: EdgeInsets.symmetric(
                        horizontal: kwidth(context) * 0.04),
                    height: kheight(context) * 0.1,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ticketStatus.length,
                        itemBuilder: (c, i) => supportContainer(
                            width: kwidth(context),
                            height: kheight(context),
                            title: ticketStatus[i]['name'] == null
                                ? ' '
                                : ticketStatus[i]['name'],
                            value: ticketStatus[i]['total'],
                            color:
                                _colorFromHex(ticketStatus[i]['statuscolor']))),
                  )
                ],
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
                                horizontal: width * 0.02,
                                vertical: height * 0.01),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
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
                height: height * 0.03,
              ),
              Container(
                height: kheight(context) * 0.63,
                padding: EdgeInsets.symmetric(
                    horizontal: kwidth(context) * 0.05,
                    vertical: kheight(context) * 0.02),
                width: kwidth(context),
                decoration: kContaierDeco,
                child: SizedBox(
                  height: kheight(context) * 0.3,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ticketData.isEmpty
                          ? Center(
                              child: Text('No Data'),
                            )
                          : ListView.builder(
                              itemCount: ticketData.length,
                              itemBuilder: (c, i) => ticketDetailsContainer(
                                  kheight(context), kwidth(context), i),
                            ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget supportContainer(
      {required double width,
      required double height,
      required String title,
      Color? color,
      required String value}) {
    print(ticketStatus[0]);
    return InkWell(
      onTap: () {
        if (title.toLowerCase() == 'all') {
           ticketData.clear();
           ticketData.addAll(aLLticketData);setState(() {
             
           });
          return;
        }
        setState(() {
          ticketData.clear();
          ticketData.addAll(aLLticketData.where((element) {
            print(element['status_name']);
            return element['status_name'].toString().toLowerCase() ==
                title.toLowerCase();
          }));
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.02,
            vertical: height * 0.005,
          ),
          width: width * 0.25,
          height: height * 0.1,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(
                height: height * 0.01,
              ),
              Text(value,
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }

  //Api call to get data from server using id and status type
  Future<void> getSupportTicketStatus(String _status) async {
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData('contact_id'),
      "status": _status
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_SUPPORT, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    ticketData.clear();
    if (data['status'] == 1) {
      setState(() {
        isLoading = false;
        ticketStatus = data["status_count"];
        ticketStatus.insert(0, {
          "total": "${data["data"].length}",
          "name": "ALL",
          "statuscolor": "FF000000"
        });
        ticketData.addAll(data["data"]);
        aLLticketData.addAll(data["data"]);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      if (ticketData.isEmpty) {
        ToastShowClass.toastShow(context, 'Ticket List is Empty', Colors.green);
      } else {
        ToastShowClass.toastShow(context, data['message'], Colors.red);
      }
    }
  }

  //we are parsing colorCode getting from server
  Color _colorFromHex(String hexColor) {
    if (hexColor != null) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } else {
      return Colors.transparent;
    }
  }

  Widget ticketDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TicketDetailScreen.id,
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
                          width: width * 0.02,
                        ),
                        Text(
                          ticketData[index]['project_id_name'] == null
                              ? " "
                              : '(${ticketData[index]['project_id_name']})',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.015),
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
                              ticketData[index]['department_name'] == null
                                  ? ''
                                  : ticketData[index]['department_name'],
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        Text(
                          '${KeyValues.lastReply} :',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          ticketData[index]['lastreply'] == null
                              ? ' '
                              : ticketData[index]['lastreply'],
                          style: TextStyle(fontSize: 10, color: Colors.grey),
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
                              ticketData[index]['priority_name'] == null
                                  ? ' '
                                  : ticketData[index]['priority_name'],
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.15,
                        ),
                        Row(
                          children: [
                            Text(
                              '${KeyValues.date} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              ticketData[index]['date'] == null
                                  ? ' '
                                  : ticketData[index]['date'],
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
                color:
                    _colorFromHex(Colorname(ticketData[index]['status_name'])),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    ticketData[index]['status_name'] == null
                        ? ''
                        : ticketData[index]['status_name'],
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

  //getting color code from status name
  Colorname(String statusName) {
    for (int i = 0; i < ticketStatus.length; i++) {
      if (statusName == ticketStatus[i]['name']) {
        return ticketStatus[i]['statuscolor'];
      }
    }
  }
}

class Contracts {
  Contracts({
    required this.title,
    required this.value,
    required this.color,
  });
  final String title;
  final int value;
  final Color color;
}

List<Contracts> items = <Contracts>[
  Contracts(title: 'Open', value: 2, color: Colors.red),
  Contracts(title: 'In Progress', value: 0, color: Colors.green),
  Contracts(title: 'Answered', value: 0, color: Colors.blue.shade900),
  Contracts(title: 'On Hold', value: 6, color: Colors.grey),
  Contracts(title: 'Closed', value: 0, color: Colors.blue.shade300),
];
