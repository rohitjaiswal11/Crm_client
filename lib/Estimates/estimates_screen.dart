// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, import_of_legacy_library_into_null_safe, deprecated_member_use

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
import '../Lbm plugin/lbmplugin.dart';

class EstimatesScreen extends StatefulWidget {
  static const id = 'estimates';
  @override
  State<EstimatesScreen> createState() => _EstimatesScreenState();
}

class _EstimatesScreenState extends State<EstimatesScreen> {
  bool isLoading = true;
  List estimatesList = [];

  @override
  void initState() {
    super.initState();

    //getting estimates list
    getEstimatesData();
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
                        'assets/estimate.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: kwidth(context) * 0.03,
                    ),
                    Text(
                      KeyValues.estimates,
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
                    : estimatesList.isEmpty
                        ? Center(
                            child: Text('No Data'),
                          )
                        : ListView.builder(
                            itemCount: estimatesList.length,
                            itemBuilder: (c, i) => estimateDetailsContainer(
                                kheight(context), kwidth(context), i),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget estimateDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {
        String estimateTitle = "EST-" + estimatesList[index]['id'];
        Navigator.of(context).pushNamed(ProposalView.id,
            arguments: PassData(
                id: estimateTitle,
                url: "https:" +
                    ApiClass.BaseURL +
                    "/crm/estimate/" +
                    estimatesList[index]['id'] +
                    "/" +
                    estimatesList[index]['hash']));
      },
      child: Container(
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
                      estimatesList[index]['prefix'] +
                          estimatesList[index]['number'],
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      estimatesList[index]['client_name'] == null
                          ? ' '
                          : ' (${estimatesList[index]['client_name']})',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    Text(
                      '${KeyValues.amount} :',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      estimatesList[index]['total'] ?? ' ',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${KeyValues.startDate} :',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          estimatesList[index]['date'] ?? ' ',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.15,
                    ),
                    Row(
                      children: [
                        Text(
                          '${KeyValues.endDate} :',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          estimatesList[index]['expirydate'] ?? ' ',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
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
    );
  }

  //Api call to fetch data from servers using user_id and category type estimate
  Future<void> getEstimatesData() async {
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData("user_id"),
      "category": "estimate"
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_CATEGORY_DATA, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data["status"] == 1) {
      setState(() {
        isLoading = false;
        estimatesList = data['data'];
      });
    } else {
      setState(() {
        isLoading = false;
        if (estimatesList.isEmpty) {
          ToastShowClass.toastShow(
              context, 'Estimates List is Empty', Colors.green);
        } else {
          ToastShowClass.toastShow(context, data['message'], Colors.red);
        }
      });
    }
  }
}
