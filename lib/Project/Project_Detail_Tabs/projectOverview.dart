// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/separator.dart';
import 'package:flutter/material.dart';

class ProjectOverView extends StatefulWidget {
  List projectDetail;
  String? status;
  ProjectOverView({required this.projectDetail, required this.status});
  @override
  State<ProjectOverView> createState() => _ProjectOverViewState();
}

class _ProjectOverViewState extends State<ProjectOverView> {
  bool _descExpand = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: kheight(context) * 0.03,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: kwidth(context) * 0.05,
                vertical: kheight(context) * 0.03),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Project #',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                        child: MySeparator(
                      color: Colors.grey,
                    )),
                    Text(
                      widget.projectDetail[0]['id'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kheight(context) * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Billing Type',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                        child: MySeparator(
                      color: Colors.grey,
                    )),
                    Text(
                      widget.projectDetail[0]['billing_type'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kheight(context) * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Total Rate',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                        child: MySeparator(
                      color: Colors.grey,
                    )),
                    Text(
                      widget.projectDetail[0]['project_cost'] == null
                          ? '\$ 0.0'
                          : '\$ ' + widget.projectDetail[0]['project_cost'],
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kheight(context) * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                        child: MySeparator(
                      color: Colors.grey,
                    )),
                    Text(
                      widget.status ?? 'Not Assigned',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kheight(context) * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                        child: MySeparator(
                      color: Colors.grey,
                    )),
                    Text(
                      widget.projectDetail[0]['start_date'] ?? ' ',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kheight(context) * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Totol Logged Hours',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                        child: MySeparator(
                      color: Colors.grey,
                    )),
                    Text(
                      widget.projectDetail[0]['estimated_hours'] ?? 'NA',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: kheight(context) * 0.04,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: kwidth(context) * 0.05,
                vertical: kheight(context) * 0.005),
            height: kheight(context) * 0.05,
            width: kwidth(context),
            color: Color(0xFFE7F5E0),
            child: Row(
              children: [
                Text(KeyValues.description,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _descExpand = !_descExpand;
                      });
                    },
                    child: Icon(
                      _descExpand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).primaryColor,
                    )),
              ],
            ),
          ),
          if (_descExpand)
            Container(
              padding: EdgeInsets.symmetric(horizontal: kwidth(context) * 0.01),
              height: kheight(context) * 0.15,
              width: kwidth(context),
              color: Color(0xFFE7F5E0),
              child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: kwidth(context) * 0.01),
                  children: [
                    Text(
                      widget.projectDetail[0]['description'] ?? ' ',
                    )
                  ]),
            ),
        ],
      ),
    );
  }
}
