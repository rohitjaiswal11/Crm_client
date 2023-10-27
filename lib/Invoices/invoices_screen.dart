// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, import_of_legacy_library_into_null_safe, deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import '../Lbm plugin/lbmplugin.dart';

class InvoicesScreen extends StatefulWidget {
  static const id = 'invocies';
  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  List invoiceList = [];
  List allInoviceData = [];
  List statusCount = [];
  bool isLoading = true;
  String title = 'Invoices';

  @override
  void initState() {
    super.initState();
    //method for getting Invoice List
    getInvoiceList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                        'assets/invoice.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: kwidth(context) * 0.03,
                    ),
                    Text(
                      KeyValues.invoices,
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
              height: kheight(context) * 0.03,
            ),
            Stack(
              children: [
                Container(
                  height: kheight(context) * 0.62,
                  margin: EdgeInsets.only(top: kheight(context) * 0.06),
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
                        : invoiceList.isEmpty
                            ? Center(
                                child: Text('No Data'),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(
                                    top: kheight(context) * 0.04),
                                itemCount: invoiceList.length,
                                itemBuilder: (c, i) => invoiceDetailsContainer(
                                    kheight(context), kwidth(context), i),
                              ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kwidth(context) * 0.03,
                  ),
                  height: kheight(context) * 0.13,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: statusCount.length,
                    itemBuilder: (c, i) => titleCard(
                      i,
                      kwidth(context),
                      kheight(context),
                      statusCount[i]['total'].toString(),
                      statusCount[i]['status_name'].toString(),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget invoiceDetailsContainer(double height, double width, int index) {
    print(invoiceList[index].toString());
    return GestureDetector(
      onTap: () {
        String proposalTitle = "INV-" + invoiceList[index]['number'];
        Navigator.of(context).pushNamed('proposalView',
            arguments: PassData(
                id: proposalTitle,
                url: "https:" +
                    ApiClass.BaseURL +
                    "/crm/invoice/" +
                    invoiceList[index]['id'] +
                    "/" +
                    invoiceList[index]['hash']));
      },
      child: Stack(
        children: [
          Container(
            height: height * 0.12,
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
                      (invoiceList[index]['prefix'] ?? 'INV-') +
                          (invoiceList[index]['number']) +
                          ' ' +
                          (invoiceList[index]['subject'] ?? ' '),
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${KeyValues.amount} : \$. ',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                Text(
                                  invoiceList[index]['total'] ?? '0.0',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.007),
                            Row(
                              children: [
                                Text(
                                  '${KeyValues.startDate} :',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                Text(
                                  invoiceList[index]['date'] ?? ' ',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.15,
                        ),
                        Row(
                          children: [
                            Text(
                              '${KeyValues.lastDate} :',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              invoiceList[index]['duedate'] ?? ' ',
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
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    invoiceList[index]['status_name'] ?? ' ',
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

  Widget titleCard(
    int index,
    double width,
    double height,
    String amount,
    String title,
  ) {
    return InkWell(
      onTap: () {
        getInvoiceList(statusID: statusCount[index]['status'].toString());
      },
      child: Card(
        color: Colors.white60,
        elevation: 4,
        shadowColor: Colors.grey.shade100,
        child: Container(
          margin: EdgeInsets.all(3),
          height: height * 0.1,
          width: width * 0.3,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade400, blurRadius: 2)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text('\$.$amount', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    invoiceList.clear();
    if (text.isEmpty) {
      setState(() {
        invoiceList.addAll(allInoviceData);
      });
      return;
    }

    setState(() {
      invoiceList.addAll(
        allInoviceData.where((item) {
          return item['number']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()) ||
              item['status_name']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase());
        }),
      );
      invoiceList.toSet().toList();
    });
  }

  //Api call to fetch data from server using id and category type(invoice)
  Future<void> getInvoiceList({String? statusID}) async {
    setState(() {
      isLoading = true;
    });
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData("user_id"),
      "category": "invoice",
      if (statusID != null) 'status': statusID,
    };
    print("prma $paramDic");
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_CATEGORY_DATA, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());

    if (data["status"] == 1) {
      log(data.toString());
      invoiceList.clear();
      allInoviceData.clear();
      statusCount.clear();

      setState(() {
        isLoading = false;

        invoiceList.addAll(data["data"]);
        allInoviceData.addAll(data["data"]);
        statusCount.addAll(data['status_count']);
      });
      print("data" " " + invoiceList.length.toString());
    } else {
      setState(() {
        invoiceList.clear();
        isLoading = false;
      });
      // if (invoiceList.isEmpty) {
      //   ToastShowClass.toastShow(
      //       context, 'Invoices List is Empty', Colors.green);
      // } else {
      //   ToastShowClass.toastShow(context, data["message"], Colors.red);
      // }
    }
  }
}
