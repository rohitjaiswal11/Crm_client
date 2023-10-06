// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Proposals/ProposalView.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

class ProposalsScreen extends StatefulWidget {
  static const id = 'proposals';
  @override
  State<ProposalsScreen> createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  String title = 'Proposals';
  List proposalList = [];
  bool isLoading = true;
  String? proposalTitle;

  @override
  void initState() {
    super.initState();
    //getting proposal list data
    getProposalList();
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
                      width: kwidth(context) * 0.15,
                      child: Image.asset(
                        'assets/proposal.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: kwidth(context) * 0.03,
                    ),
                    Text(
                      KeyValues.proposals,
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
                    : proposalList.isEmpty
                        ? Center(
                            child: Text('No Data'),
                          )
                        : ListView.builder(
                            itemCount: proposalList.length,
                            itemBuilder: (c, i) => proposalContainer(
                                height: kheight(context),
                                width: kwidth(context),
                                index: i),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget proposalContainer({
    required double width,
    required double height,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        proposalTitle = "PRO-" + proposalList[index]['id'];
        Navigator.of(context).pushNamed(ProposalView.id,
            arguments: PassData(
                id: proposalTitle!,
                url: "https:" +
                    ApiClass.BaseURL +
                    "/crm/proposal/" +
                    proposalList[index]['id'] +
                    "/" +
                    proposalList[index]['hash']));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.015),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        color: Colors.black,
                      ),
                      Text(
                        "PRO-" +
                            proposalList[index]['id'] +
                            ' ' +
                            (proposalList[index]['subject'] ?? ' '),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'Open Till : ' + (proposalList[index]['open_till'] ?? 'NA'),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              SizedBox(height: height * 0.005),
              Row(
                children: [
                  Text(
                    'Status-',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  SizedBox(
                    width: width * 0.005,
                  ),
                  Text(
                    proposalList[index]['status_name'] ?? 'NA',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                        .copyWith(color: Colors.orange),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount - \$:' + (proposalList[index]['total'] ?? ''),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    '${KeyValues.date} - ' +
                        (proposalList[index]['date'] ?? ' '),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          )),
    );
  }
  //Api call to fetch data from server using Id and category type 'proposal'

  Future<void> getProposalList() async {
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData("user_id"),
      "category": "proposal"
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_CATEGORY_DATA, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data["status"] == 1) {
      setState(() {
        isLoading = false;
        proposalList = data["data"];
      });
      print("data" " " + proposalList.length.toString());
    } else {
      setState(() {
        isLoading = false;
      });
      if (proposalList.isEmpty) {
        ToastShowClass.toastShow(
            context, 'Proposal List is Empty', Colors.green);
      } else {
        ToastShowClass.toastShow(context, data["message"], Colors.red);
      }
    }
  }
}







/* */