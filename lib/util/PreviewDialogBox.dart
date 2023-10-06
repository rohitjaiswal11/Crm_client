// ignore_for_file: avoid_print, use_key_in_widget_constructors, file_names

import 'dart:io';

import 'package:crm_client/util/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PreviewDialogBox extends StatefulWidget {
  bool? isFile;
  PreviewDialogBox({this.isFile});
  @override
  State<StatefulWidget> createState() {
    return _PreviewDialogBox();
  }
}

class _PreviewDialogBox extends State<PreviewDialogBox> {
  @override
  Widget build(BuildContext context) {
    print("Url" " " + fileUrl);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 500,
          child: Dialog(
              child: widget.isFile == true
                  ? Image.file(File(fileUrl),
                      errorBuilder: (context, error, stackTrace) {
                      Navigator.pop(context);

                      return Text(
                        'No Image Found',
                        style: TextStyle(color: Colors.white),
                      );
                    })
                  : Image.network(fileUrl,
                      errorBuilder: (context, error, stackTrace) {
                      Navigator.pop(context);
                      return Text(
                        'No Image Found',
                        style: TextStyle(color: Colors.white),
                      );
                    })),
        ),
      )),
    );
  }
}
