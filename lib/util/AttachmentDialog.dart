// ignore_for_file: prefer_const_constructors, invalid_use_of_visible_for_testing_member, use_key_in_widget_constructors, file_names, prefer_final_fields, avoid_print, must_be_immutable

import 'dart:io';

import 'package:crm_client/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee_widget/marquee_widget.dart';

import 'PreviewDialogBox.dart';

class AttachmentAddDialogBox extends StatefulWidget {
  bool? isEdit;
  bool? isMultiImage;
  AttachmentAddDialogBox({this.isEdit, this.isMultiImage});
  @override
  State<StatefulWidget> createState() {
    return _AttachmentAddDialogBox();
  }
}

class _AttachmentAddDialogBox extends State<AttachmentAddDialogBox> {
  final TextStyle subtitle = TextStyle(fontSize: 12, color: Colors.grey);

  final TextStyle label = TextStyle(fontSize: 14, color: Colors.grey);
  static ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    multiFileList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: 220,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("New Attachment",
                        style: label.copyWith(
                            color: Theme.of(context).primaryColor)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close,
                          color: Theme.of(context).primaryColor),
                    )
                  ],
                ),

                Divider(),
//                CheckboxListTile(title: Text('Public'),value: _isChecked,onChanged: (val){setState((){});},),
                //choose options for camera and gallery
                Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      "Choose Option",
                      style: label,
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.isMultiImage != null) {
                              var pictureList = await _picker.pickImage(
                                source: ImageSource.camera,
                              );

                              setState(() {
                                if (pictureList == null) {
                                } else {
                                  final imageFile = File(pictureList.path);

                                  multiFileList.add(MultiFileClass(
                                      file: imageFile,
                                      fileName:
                                          pictureList.path.split('/').last));

                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              var picture = await _picker.pickImage(
                                source: ImageSource.camera,
                              );

                              setState(() {
                                if (picture == null) {
                                } else {
                                  imageFile = File(picture.path);
                                  changedImage = imageFile;
                                  print('Image Changed ===' +
                                      changedImage.toString());

                                  imagePath = imageFile!.path.split("/").last;
                                  Navigator.pop(context);
                                }
                              });
                            }
                            //
                            //
                            // Navigator.pop(context,true);
                            // imageFile = picture;
                            // Customer_Files(picture);
                          },
                          child: Icon(
                            Icons.camera,
                            color: Colors.black,
                            size: 50,
                          ),
                        ),
                        Text('Camera')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.isMultiImage != null) {
                              var picturesList =
                                  await ImagePicker.platform.getMultiImage();

                              setState(() {
                                if (picturesList == null ||
                                    picturesList.isEmpty) {
                                } else {
                                  for (var i = 0;
                                      i < picturesList.length;
                                      i++) {
                                    multiFileList.add(MultiFileClass(
                                        file: File(picturesList[i].path),
                                        fileName: picturesList[i]
                                            .path
                                            .split('/')
                                            .last));
                                  }
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              var image = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              setState(() {
                                if (image == null) {
                                } else {
                                  imageFile = File(image.path);
                                  changedImage =
                                      widget.isEdit == true ? imageFile : null;
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          child: Icon(
                            Icons.dashboard,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                        Text('Gallery')
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

StatefulBuilder multipleItemDialog(double height, double width) {
  return StatefulBuilder(builder: (context, setState) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: height * 0.5,
        width: width * 0.8,
        decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 2)),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Selected Items",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 13)),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              height: height * 0.43,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < multiFileList.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        fileUrl = multiFileList[i].file.path;
                                        showGeneralDialog(
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            transitionBuilder:
                                                (context, a1, a2, widget) {
                                              return Transform.scale(
                                                scale: a1.value,
                                                child: Opacity(
                                                  opacity: a1.value,
                                                  child: PreviewDialogBox(
                                                      isFile: true),
                                                ),
                                              );
                                            },
                                            transitionDuration:
                                                Duration(milliseconds: 100),
                                            barrierDismissible: false,
                                            barrierLabel: '',
                                            context: context,
                                            pageBuilder: (context, animation1,
                                                animation2) {
                                              return SizedBox();
                                            });
                                      },
                                      child: Image.file(
                                        multiFileList[i].file,
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.insert_drive_file_sharp,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    SizedBox(
                                        width: width * 0.4,
                                        child: Marquee(
                                          child:
                                              Text(multiFileList[i].fileName),
                                        )),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        multiFileList.removeAt(i);
                                      });
                                      if (multiFileList.isEmpty) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
