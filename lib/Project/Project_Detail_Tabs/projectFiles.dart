// ignore_for_file: prefer_const_constructors, file_names, must_be_immutable, use_key_in_widget_constructors, non_constant_identifier_names, import_of_legacy_library_into_null_safe, avoid_print, deprecated_member_use, prefer_typing_uninitialized_variables, prefer_if_null_operators, unnecessary_null_comparison, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/AttachmentDialog.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/PreviewDialogBox.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import '../../Lbm plugin/lbmplugin.dart';
import 'package:http/http.dart' as http;

class ProjectFiles extends StatefulWidget {
  String projectId;
  ProjectFiles({required this.projectId});

  @override
  State<ProjectFiles> createState() => _ProjectFilesState();
}

class _ProjectFilesState extends State<ProjectFiles> {
  List filesList = [];
  bool isLoading = true;
  String? user_id;
  File? image;
  bool isCaptured = false;
  int is_state = 3;

  @override
  void initState() {
    super.initState();
    print('data' + widget.projectId);
    //Getting SharedPreference Data
    getSharedData();

    //Method to get ProjectFiles
    getProjectFiles();
  }

  void getSharedData() async {
    String id = await SharedPreferenceClass.getSharedData('user_id');
    setState(() {
      user_id = id;
    });
  }

  // ApiCalls to get Project files from server
  Future<void> getProjectFiles() async {
    final paramDic = {
      'projectid': widget.projectId,
      'project_detailtype': 'files'
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_PROJECT_DETAIL, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      if (mounted) {
        setState(() {
          isLoading = false;
          filesList = data['data'];
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
          if (filesList.isEmpty) {
            ToastShowClass.toastShow(context, 'No File is Found', Colors.green);
          } else {
            ToastShowClass.toastShow(context, data['message'], Colors.red);
          }
        });
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: height * 0.6,
              width: width,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.03),
                        SizedBox(
                          height: width * 0.2,
                          width: width * 0.2,
                          child: image == null
                              ? Image.asset(
                                  'assets/folder.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                  width: 340,
                                  height: 150,
                                ),
                        ),
                        SizedBox(height: height * 0.01),
                        SizedBox(
                          width: width * 0.25,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Colors.orange.shade400))),
                            onPressed: () {
                              showGeneralDialog(
                                  transitionBuilder: (context, a1, a2, widget) {
                                    return Transform.scale(
                                      scale: a1.value,
                                      child: Opacity(
                                          opacity: a1.value,
                                          // Dialog box to add files from gallery and camera
                                          child: AttachmentAddDialogBox()),
                                    );
                                  },
                                  transitionDuration:
                                      Duration(milliseconds: 400),
                                  barrierDismissible: false,
                                  barrierLabel: '',
                                  context: context,
                                  pageBuilder:
                                      (context, animation1, animation2) {
                                    return SizedBox();
                                  }).then((value) => getCapturedImage());
                            },
                            child: Text(
                              isCaptured == true ? 'Change' : 'Add File',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.orange.shade400,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: kheight(context) * 0.045,
                          width: kwidth(context),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                            onPressed: () {
                              if (image != null) {
                                setState(() {
                                  is_state = 1;
                                });
                                addProjectFile();
                              } else {
                                ToastShowClass.toastShow(context,
                                    'Select file to upload', Colors.green);
                              }
                            },
                            child: is_state == 1
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ))
                                : Text(
                                    'Upload File',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.3,
                          child: ListView.builder(
                              itemCount: filesList.length,
                              itemBuilder: ((context, index) =>
                                  _FilesList(context, index))),
                        )
                      ],
                    )),
        ],
      ),
    );
  }

  //Handle File list items UI, Values and onTap functionality
  Widget _FilesList(BuildContext context, int index) {
    return InkWell(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                filesList[index]['file_name'] == null
                    ? Icon(Icons.photo,
                        size: 20, color: Theme.of(context).primaryColor)
                    : Image.network(
                        "https://" +
                            ApiClass.BaseURL +
                            "/crm/uploads/projects/" +
                            widget.projectId +
                            "/" +
                            filesList[index]['file_name'],
                        width: 40,
                        height: 40,
                      ),
                SizedBox(
                  width: 280,
                  child: Text(
                      filesList[index]['file_name'] == null
                          ? ''
                          : filesList[index]['file_name'],
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(
              height: kheight(context) * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 300,
                    child: Text(
                      'File Type: ' + filesList[index]['filetype'] == null
                          ? ''
                          : 'File Type: ' + filesList[index]['filetype'],
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      maxLines: 2,
                    )),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Total Comments: ',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              Text(
                'Date: ' + filesList[index]['dateadded'] == null
                    ? ''
                    : 'Date: ' + filesList[index]['dateadded'],
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500),
              )
            ]),
            Divider(
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
        onTap: () {
          fileUrl = "https://" +
              ApiClass.BaseURL +
              "/crm/uploads/projects/" +
              widget.projectId +
              "/" +
              filesList[index]['file_name'].toString();
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    //DialogBox to show file on tap
                    child: PreviewDialogBox(),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 100),
              barrierDismissible: false,
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {
                return SizedBox();
              });
        });
  }

  //Api call to upload file on server using multipart

  Future<void> addProjectFile() async {
    final uri = Uri.https(ApiClass.BaseURL, ApiClass.UPLOAD_PROJECT_FILES);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (ApiClass.api_key);
    request.fields['contact_id'] =
        await SharedPreferenceClass.getSharedData('contact_id');
    request.fields['project_id'] = widget.projectId;
    request.fields['staff_id'] =
        await SharedPreferenceClass.getSharedData("user_id") ?? '';
    var file;

    if (image != null) {
      var stream = http.ByteStream(DelegatingStream.typed(image!.openRead()));
      var length = await image!.length();
      file = http.MultipartFile('file', stream, length,
          filename: image!.path.split('/').last);
      request.files.add(file);
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        is_state = 0;
        image = null;
        ToastShowClass.toastShow(
            context, 'File Uploaded Successfully', Colors.green);
      });
      response.stream.transform(utf8.decoder).listen((value) {
        print(' VALUE' + value.toString());
      });
      getProjectFiles();
    } else {
      setState(() {
        is_state = 0;
        ToastShowClass.toastShow(context, 'error', Colors.green);
      });
    }
  }

  //This method is called after selecting image from camera and gallery
  getCapturedImage() {
    setState(() {
      image = imageFile;
      if (image != null) {
        isCaptured = true;
      }
    });
  }
}
