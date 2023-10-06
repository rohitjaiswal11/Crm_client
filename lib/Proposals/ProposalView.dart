// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, must_be_immutable, use_key_in_widget_constructors

import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ProposalView extends StatefulWidget {
  static const id = 'proposalView';
  PassData webdata;

  //Getting PassData object from ProposalList class
  ProposalView({required this.webdata});

  @override
  _ProposalViewState createState() => _ProposalViewState();
}

class _ProposalViewState extends State<ProposalView> {
  @override
  Widget build(BuildContext context) {
    //creating webview to view Proposal details
    return Padding(
      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WebviewScaffold(
        url: widget.webdata.url,
        appBar: AppBar(
            title: Text(widget.webdata.id,
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300)),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(-0.27, 1.0),
                      end: Alignment(0.27, -1.0),
                      colors: [Theme.of(context).primaryColor, Color(0xff3a7b7d)],
                      stops: [0.0, 1.0])),
            )),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.white,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
      ),
    );
  }
}
