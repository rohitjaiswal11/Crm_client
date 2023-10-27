// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, deprecated_member_use

import 'dart:convert';

import 'package:crm_client/Proposals/ProposalView.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:flutter/material.dart';
import '../Lbm plugin/lbmplugin.dart';

import '../Dashboard/dashboard_screen.dart';
import '../util/ToastClass.dart';
import '../util/storage_manger.dart';

class ContractsScreen extends StatefulWidget {
  static const id = 'Contracts';
  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  bool isLoading = true;
  List contractList = [];

  @override
  void initState() {
    super.initState();
    //Getting Contact List
    getContractList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                      height: kheight(context) * 0.1,
                      width: kwidth(context) * 0.2,
                      child: Image.asset(
                        'assets/contracts.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: kwidth(context) * 0.03,
                    ),
                    Text(KeyValues.contracts,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: kheight(context) * 0.07,
            ),
            Container(
                width: kwidth(context),
                height: kheight(context) * 0.73,
                padding: EdgeInsets.symmetric(
                    horizontal: kwidth(context) * 0.06,
                    vertical: kheight(context) * 0.04),
                decoration: kContaierDeco,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : contractList.isEmpty
                        ? Center(
                            child: Text('No Data'),
                          )
                        : ListView.builder(
                            itemCount: contractList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return contractDetailsContainer(
                                  kheight(context), kwidth(context), index);
                            }))
          ],
        ),
      ),
    );
  }

  Widget contractDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {
        String contractTitle = "Contract-" + contractList[index]['id'];
        Navigator.of(context).pushNamed(ProposalView.id,
            arguments: PassData(
                id: contractTitle,
                url: "https:" +
                    ApiClass.BaseURL +
                    "/crm/contract/" +
                    contractList[index]['id'] +
                    "/" +
                    contractList[index]['hash']));
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
                      (contractList[index]['subject'] ?? ' ') + ' ',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contractList[index]['client_name'] == null
                          ? ' '
                          : '(${contractList[index]['client_name']})',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  '${KeyValues.contractType} : ' +
                      (contractList[index]['contract_type_name'] ?? ' '),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
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
                          '${KeyValues.startDate} :',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          contractList[index]['datestart'] ?? ' ',
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
                          contractList[index]['dateend'] ?? ' ',
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

  //Api call to get  contract list data from server using user_id
  // and category type
  Future<void> getContractList() async {
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData('user_id'),
      "category": "contract"
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_CATEGORY_DATA, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      setState(() {
        isLoading = false;
        contractList = data['data'];
      });
    } else {
      setState(() {
        isLoading = false;
        if (contractList.isEmpty) {
          //Displaying message at the bottom of the screen
          ToastShowClass.toastShow(
              context, 'Contract List is Empty', Colors.green);
        } else {
          ToastShowClass.toastShow(context, data['message'], Colors.red);
        }
      });
    }
  }
}
