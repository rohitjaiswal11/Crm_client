// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, prefer_if_null_operators, file_names, avoid_print

import 'package:flutter/material.dart';

class DiscussView extends StatefulWidget {
  static const id = 'DiscussionView';
//Fetch the discussion comment on Discussion View
  List data = [];
  DiscussView({required this.data});

  @override
  State<StatefulWidget> createState() {
    return _DiscussView();
  }
}

class _DiscussView extends State<DiscussView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("data" " " + widget.data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Discussion",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300)),
        ),
        //Show the data in list view
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                return listViewData(context, index);
              }),
        ));
  }

  Widget listViewData(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              widget.data[index]['content'] == null
                  ? ''
                  : widget.data[index]['content'],
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.data[index]['file_name'] == null
                ? 'Not Specified'
                : widget.data[index]['file_name'],
            style: TextStyle(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600),
          ),
          Text(
            widget.data[index]['file_mime_type'] == null
                ? ''
                : widget.data[index]['file_mime_type'],
            style: TextStyle(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Discussion Type: ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
              Text(
                widget.data[index]['discussion_type'] == null
                    ? ''
                    : widget.data[index]['discussion_type']
                        .toString()
                        .toUpperCase(),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Date: ',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.data[index]['created'] == null
                    ? ''
                    : widget.data[index]['created'],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Divider(color: Theme.of(context).primaryColor)
        ],
      ),
    );
  }
}
