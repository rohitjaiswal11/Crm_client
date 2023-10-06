// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, unnecessary_null_comparison, prefer_if_null_operators, avoid_print, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';

import 'package:crm_client/Chat/clientlisting.dart';
import 'package:crm_client/Contracts/contracts_screen.dart';
import 'package:crm_client/Estimates/estimates_screen.dart';
import 'package:crm_client/Invoices/invoices_screen.dart';
import 'package:crm_client/Project/project_screen.dart';
import 'package:crm_client/Proposals/proposal_screen.dart';
import 'package:crm_client/Support/support_screen.dart';
import 'package:crm_client/Support/ticket_details_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../util/LicenseKey.dart';
import '../util/ToastClass.dart';

class DashBoardScreen extends StatefulWidget {
  static const id = 'DashBoard';
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List data = [];
  List ticketStatus = [];

  bool isLoading = true;
  String username = '', newUsername = '';
  String email = '', newEmail = '';
  String lastLogin = '', newLastLogin = '';
  String image = '', id = '', newImage = '';
  @override
  void initState() {
    super.initState();
    getSupportTicketStatus();
    //Getting SharedPreferenceData
    getSharedPrefData();
  }

  //Getting SharedPreference Data and assigning it to variables inside setState()
  getSharedPrefData() async {
    username = await SharedPreferenceClass.getSharedData("first_name") +
        "  " +
        await SharedPreferenceClass.getSharedData("last_name");
    email = await SharedPreferenceClass.getSharedData("email");
    lastLogin = await SharedPreferenceClass.getSharedData("last_login");
    image = await SharedPreferenceClass.getSharedData("image");
    id = await SharedPreferenceClass.getSharedData('contact_id');

    setState(() {
      newUsername = username;
      newEmail = email;
      newLastLogin = lastLogin;
      userImage = image;
      contactId = id;
    });
  }

  Future<void> getSupportTicketStatus() async {
    try {
      final paramDic = {
        "id": await SharedPreferenceClass.getSharedData('contact_id'),
        "status": ''
      };
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          ApiClass.GET_SUPPORT, paramDic, 'Get', Api_Key_by_Admin);
      var respData = json.decode(response.body);
      if (respData['status'] == 1) {
        setState(() {
          data.clear();
          data = respData["data"];
          ticketStatus = respData["status_count"];

          isLoading = false;
        });
      } else {
        log('respData $respData');

        if (data.isEmpty) {
          ToastShowClass.toastShow(
              context, 'Ticket List is Empty', Colors.green);
        } else {
          ToastShowClass.toastShow(context, respData['message'], Colors.red);
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('EEE $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemHeight = kheight(context) * 0.045;
    final itemWidth = kwidth(context) * 0.1;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // print(' -- ${ticketStatus}');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: kheight(context) * 0.2,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                        Container(
                          height: height * 0.05,
                          width: width * 0.11,
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, clientlisting.id);
                            },
                            icon: Icon(
                              Icons.message_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: kwidth(context) * 0.05,
                //       right: kwidth(context) * 0.05,
                //       top: kheight(context) * 0.14),
                //   child: Card(
                //     margin: EdgeInsets.only(top: kheight(context) * 0.027),
                //     elevation: 20,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15)),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(15),
                //         gradient: LinearGradient(
                //             colors: [
                //               Color(0xFF76B74F),
                //               Color(0xFF93E460),
                //             ],
                //             begin: Alignment.bottomCenter,
                //             end: Alignment.topCenter),
                //       ),
                //       child: Container(
                //         margin: EdgeInsets.symmetric(
                //             horizontal: kwidth(context) * 0.05,
                //             vertical: kheight(context) * 0.025),
                //         padding: EdgeInsets.symmetric(
                //             horizontal: kwidth(context) * 0.03,
                //             vertical: kheight(context) * 0.01),
                //         width: kwidth(context),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.white, width: 1),
                //           borderRadius: BorderRadius.circular(10),
                //           color: Color(0xFFAAF17E),
                //           boxShadow: [
                //             BoxShadow(color: Colors.grey.shade500),
                //           ],
                //         ),
                //         child: Column(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.end,
                //                 children: [
                //                   InkWell(
                //                     onTap: () {
                //                       Navigator.pushNamed(context, Profile.id)
                //                           .then((value) => getSharedPrefData());
                //                     },
                //                     child: Icon(
                //                       Icons.arrow_forward,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(
                //                 height: kheight(context) * 0.02,
                //               ),
                //               Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceEvenly,
                //                 children: [
                //                   Column(
                //                     children: [
                //                       Text(
                //                         'Email',
                //                         style: TextStyle(
                //                             fontSize: 12,
                //                             color: Colors.green.shade900),
                //                       ),
                //                       Text(
                //                         newEmail,
                //                         style: TextStyle(
                //                             fontSize: 12,
                //                             color: Colors.green.shade900),
                //                       ),
                //                     ],
                //                   ),
                //                   Container(
                //                     padding: EdgeInsets.all(2),
                //                     width: kwidth(context) * 0.13,
                //                     height: kwidth(context) * 0.13,
                //                     decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(50),
                //                       border: Border.all(
                //                         color: Colors.white,
                //                         width: 1.0,
                //                       ),
                //                     ),
                //                     child: ClipRRect(
                //                       borderRadius: BorderRadius.circular(50),
                //                       child: image == null || image == ''
                //                           ? Image.asset(
                //                               'assets/dummy_profile.jpg',
                //                               fit: BoxFit.fill,
                //                             )
                //                           : Image.network(
                //                               'https://' +
                //                                   ApiClass.BaseURL +
                //                                   "/crm/uploads/client_profile_images/" +
                //                                   contactId +
                //                                   "/thumb_" +
                //                                   image,
                //                               fit: BoxFit.cover,
                //                               errorBuilder: (context, error,
                //                                       stackTrace) =>
                //                                   Image.asset(
                //                                 'assets/dummy_profile.jpg',
                //                                 fit: BoxFit.fill,
                //                               ),
                //                             ),
                //                     ),
                //                   ),
                //                   Column(
                //                     children: [
                //                       Text(
                //                         'Last Active',
                //                         style: TextStyle(
                //                             fontSize: 12,
                //                             color: Colors.green.shade900),
                //                       ),
                //                       Text(
                //                         newLastLogin == null
                //                             ? " "
                //                             : newLastLogin,
                //                         style: TextStyle(
                //                             fontSize: 12,
                //                             color: Colors.green.shade900),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(
                //                 height: kheight(context) * 0.013,
                //               ),
                //               Text(
                //                 newUsername.toUpperCase(),
                //                 style: TextStyle(
                //                     fontSize: 12,
                //                     color: Colors.green.shade900,
                //                     fontWeight: FontWeight.w600),
                //               ),
                //               SizedBox(
                //                 height: kheight(context) * 0.02,
                //               )
                //             ]),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: kheight(context) * 0.05,
            ),
            Container(
                height: kheight(context) * 0.3,
                margin: EdgeInsets.only(
                  left: kwidth(context) * 0.02,
                  right: kwidth(context) * 0.02,
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: choices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    print("Lengtgh $index");
                    return ListItem(choice: choices[index]);
                  },
                )),
            SizedBox(
              height: kheight(context) * 0.07,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kwidth(context) * 0.05,
                  vertical: kheight(context) * 0.03),
              width: kwidth(context),
              decoration: kContaierDeco,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Tickets',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: kheight(context) * 0.03,
                  ),
                  SizedBox(
                    height: kheight(context) * 0.25,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : data.isEmpty
                            ? Center(
                                child: Text('No Tickets Available'),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (c, i) => ticketDetailsContainer(
                                    kheight(context), kwidth(context), i)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  colorname(String statusName) {
    for (int i = 0; i < ticketStatus.length; i++) {
      if (statusName == ticketStatus[i]['name']) {
        return ticketStatus[i]['statuscolor'];
      }
    }
  }

  Widget ticketDetailsContainer(
    double height,
    double width,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TicketDetailScreen.id,
            arguments: PassTicketData(
                data[index]['ticketid'],
                '#' + data[index]['ticketid'] + " " + data[index]['subject'],
                data[index]['message']));
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
                          data[index]['ticketid'] == null
                              ? ''
                              : '#' + data[index]['ticketid'],
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          data[index]['project_id_name'] == null
                              ? " "
                              : '(${data[index]['project_id_name']})',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
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
                              data[index]['department_name'] == null
                                  ? ''
                                  : data[index]['department_name'],
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
                          data[index]['lastreply'] == null
                              ? 'null'
                              : data[index]['lastreply'],
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
                              data[index]['priority_name'] == null
                                  ? ' '
                                  : data[index]['priority_name'],
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
                              data[index]['date'] == null
                                  ? ''
                                  : data[index]['date'],
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
                color: _colorFromHex(colorname(data[index]['status_name'])),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    data[index]['status_name'] == null
                        ? ''
                        : data[index]['status_name'],
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

  /// ******* Getting hexColor from server and parsing it here ********* ///
  Color _colorFromHex(String hexColor) {
    if (hexColor != null) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } else {
      return Colors.transparent;
    }
  }
}

class ListItem extends StatelessWidget {
  final Choice choice;

  ListItem({required this.choice});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Card(
      color: Color(0xffedefee),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, choice.routeName);
        },
        child: Container(
          margin: EdgeInsets.all(4),
          //height: height * 0.7,
          decoration: BoxDecoration(
            color: Color(0xfff7f5f6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: height * 0.07, child: Image.asset(choice.imageData)),
              SizedBox(
                height: height * 0.005,
              ),
              FittedBox(
                  child: Text(choice.title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)))
            ],
          ),
        ),
      ),
    );
  }
}

List<Choice> choices = <Choice>[
  Choice(
      title: 'Support',
      imageData: 'assets/newticket.png',
      routeName: SupportScreen.id),
  Choice(
      title: 'Projects',
      imageData: 'assets/projects.png',
      routeName: ProjectScreen.id),
  Choice(
      title: 'Proposals',
      imageData: 'assets/proposal.png',
      routeName: ProposalsScreen.id),
  Choice(
      title: 'Invoice',
      imageData: 'assets/invoice.png',
      routeName: InvoicesScreen.id),
  Choice(
      title: 'Contract',
      imageData: 'assets/contracts.png',
      routeName: ContractsScreen.id),
  Choice(
      title: 'Estiamte',
      imageData: 'assets/estimate.png',
      routeName: EstimatesScreen.id),
];

class Choice {
  const Choice(
      {required this.title, required this.imageData, required this.routeName});
  final String title;
  final String imageData;
  final String routeName;
}

class PassTicketData {
  String id;
  String url;
  String description;

  PassTicketData(this.id, this.url, this.description);
}

class PassData {
  String id;
  String url;
  String? status;

  PassData({required this.id, required this.url, this.status});
}

class chatdata {
  String myid;
  String friendid;
  String friendname;

  chatdata(
      {required this.myid, required this.friendid, required this.friendname});
}
