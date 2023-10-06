// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:crm_client/Support/add_ticket_screen.dart';
import 'package:crm_client/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/LicenseKey.dart';
import 'contact_us.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    getDetails();
    super.initState();
  }

  String? name, phonenumber, email;
  Future<void> getDetails() async {
    var headers = {
      'authtoken': Api_Key_by_Admin,
    };
    var request = http.Request(
        'GET', Uri.parse('https://ppscs.io/crm/api/Tickets/supportteam'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    try {
      if (response.statusCode == 200) {
        final resp = await response.stream.bytesToString();
        final data = jsonDecode(resp);
        final details = data['data'][0];
        name = (details['firstname'] ?? '') + (details['lastname'] ?? '');
        email = details['email'];
        phonenumber = '${details['phonenumber'] ?? ''}';

        setState(() {});
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('error -- > $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                padding:
                    EdgeInsets.symmetric(horizontal: kwidth(context) * 0.05),
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
                      'Contact Support',
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
              height: height * 0.04,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06, vertical: height * 0.03),
              height: height * 0.68,
              width: width,
              decoration: kContaierDeco,
              child: Column(
                children: [
                  ContactUs(
                    cardColor: Colors.white,
                    textColor: Theme.of(context).primaryColor,

                    // logo: const AssetImage('assets/newticket.png'),
                    email: email ?? '',
                    emailText: email,
                    phoneNumber: phonenumber ?? '',
                    phoneNumberText: phonenumber,
                    message: phonenumber,
                    messageNumberText: 'Message Us at $phonenumber',

                    companyName: name ?? '',
                    companyColor: Theme.of(context).primaryColor,
                    dividerThickness: 2,
                    dividerColor: Theme.of(context).primaryColor,
                    taglineColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: kheight(context) * 0.04),
                  SizedBox(
                    height: kheight(context) * 0.045,
                    width: kwidth(context) * 0.8,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: () {
                        Navigator.pushNamed(context, AddTicket.id);
                      },
                      child: Text(
                        'Create Ticket',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ],
              ),

              //  Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(
              //       height: height * 0.03,
              //     ),
              //     Text('Call :-'),
              //     SizedBox(
              //       height: height * 0.02,
              //     ),
              //     Container(
              //       height: height * 0.06,
              //       width: width,
              //       decoration: kDropdownContainerDeco.copyWith(
              //           border: Border.all(
              //         color: Theme.of(context).primaryColor,
              //       )),
              //       child: TextFormField(
              //         enabled: false,
              //         style: kTextformStyle.copyWith(
              //             color: Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 14),
              //         decoration: InputDecoration(
              //           contentPadding: EdgeInsets.only(
              //               left: width * 0.02, right: width * 0.02),
              //           hintText: phonenumber ?? '',
              //           hintStyle: kTextformStyle.copyWith(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w600,
              //               decoration: TextDecoration.underline,
              //               fontSize: 14),
              //           border: InputBorder.none,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: height * 0.03,
              //     ),
              //     Text('Text Us'),
              //     SizedBox(
              //       height: height * 0.02,
              //     ),
              //     Container(
              //       height: height * 0.06,
              //       width: width,
              //       decoration: kDropdownContainerDeco.copyWith(
              //           border: Border.all(
              //         color: Theme.of(context).primaryColor,
              //       )),
              //       child: TextFormField(
              //         enabled: false,
              //         style: kTextformStyle.copyWith(
              //             color: Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 14),
              //         decoration: InputDecoration(
              //           contentPadding: EdgeInsets.only(
              //               left: width * 0.02, right: width * 0.02),
              //           hintText: 'Text us at ${phonenumber ?? ''}',
              //           hintStyle: kTextformStyle.copyWith(
              //               color: Colors.black,
              //               decoration: TextDecoration.underline,
              //               fontWeight: FontWeight.w600,
              //               fontSize: 14),
              //           border: InputBorder.none,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: height * 0.03,
              //     ),
              //     Text('Email'),
              //     SizedBox(
              //       height: height * 0.02,
              //     ),
              //     Container(
              //       height: height * 0.06,
              //       width: width,
              //       decoration: kDropdownContainerDeco.copyWith(
              //           border: Border.all(
              //         color: Theme.of(context).primaryColor,
              //       )),
              //       child: TextFormField(
              //         enabled: false,
              //         style: kTextformStyle.copyWith(
              //             color: Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 14),
              //         decoration: InputDecoration(
              //           contentPadding: EdgeInsets.only(
              //               left: width * 0.02, right: width * 0.02),
              //           hintText: email ?? '',
              //           hintStyle: kTextformStyle.copyWith(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w600,
              //               decoration: TextDecoration.underline,
              //               fontSize: 14),
              //           border: InputBorder.none,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: height * 0.03,
              //     ),
              //     Text('Phone Number'),
              //     SizedBox(
              //       height: height * 0.02,
              //     ),
              //     Container(
              //       height: height * 0.06,
              //       width: width,
              //       decoration: kDropdownContainerDeco.copyWith(
              //           border: Border.all(
              //         color: Theme.of(context).primaryColor,
              //       )),
              //       child: TextFormField(
              //         enabled: false,
              //         style: kTextformStyle.copyWith(
              //             color: Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 14),
              //         keyboardType: TextInputType.number,
              //         decoration: InputDecoration(
              //           contentPadding: EdgeInsets.only(
              //               left: width * 0.02, right: width * 0.02),
              //           hintText: 'phone_Number',
              //           hintStyle: kTextformStyle.copyWith(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w600,
              //               fontSize: 14),
              //           border: InputBorder.none,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileontainer({
    required double width,
    required double height,
    required String number,
    required String title,
  }) {
    return Container(
        width: width * 0.4,
        height: height * 0.06,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 7, color: Colors.grey),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
