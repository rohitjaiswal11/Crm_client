// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, import_of_legacy_library_into_null_safe, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:async/async.dart';
import 'package:crm_client/Support/support_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/AttachmentDialog.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Lbm plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

class AddTicket extends StatefulWidget {
  static const id = 'Addticket';

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  int is_state = 3;
  final _formKey = GlobalKey<FormState>();
  final _subjectFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final TextEditingController controller = TextEditingController();

  //TextEditingController for textformField to get its text
  TextEditingController subjectController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  // TextEditingController priorityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<DeptItem> deptItems = [];
  List _department = [];
  DeptItem? _selectDept;

  List<Project> projectItems = [];
  List _projects = [];
  Project? _selectProject;

  // List<PriorityItem> priorityItems = [];
  // List _priority = [];
  // PriorityItem? _selectPriority;
  // File? image;
  // bool isCaptured = true;

  @override
  void initState() {
    multiFileList.clear();
    super.initState();

    //getting project list.
    getAddTicketDept("project");

    //getting Department List
    getAddTicketDept("department");

    //Getting Priority List
    getAddTicketDept("priority");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                        height: kheight(context) * 0.07,
                        width: kwidth(context) * 0.14,
                        child: Image.asset(
                          'assets/newticket.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: kwidth(context) * 0.03,
                      ),
                      Text(KeyValues.submitTicket,
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
                padding: EdgeInsets.symmetric(
                    horizontal: kwidth(context) * 0.06,
                    vertical: kheight(context) * 0.04),
                decoration: kContaierDeco,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(KeyValues.subject,
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: kheight(context) * 0.01),
                    Container(
                      height: kheight(context) * 0.06,
                      width: kwidth(context),
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: subjectController,
                        textInputAction: TextInputAction.next,
                        focusNode: _subjectFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _subjectFocus, _descriptionFocus);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the Subject';
                          }
                          return null;
                        },
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: kcontentPadding(kwidth(context)),
                          hintText: KeyValues.enterSubject,
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: kheight(context) * 0.03),
                    Text(KeyValues.selectProject,
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: kheight(context) * 0.01),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Project>(
                        hint: Text(
                          KeyValues.nothingSelected,
                          style: TextStyle(fontSize: 12),
                        ),
                        elevation: 8,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: kwidth(context) * 0.04),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        dropdownColor: Colors.green.shade50,
                        value: _selectProject,
                        onChanged: (Value) async {
                          setState(() {
                            _selectProject = Value;
                            projectController.text = _selectProject!.id;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select project' : null,
                        items: projectItems.map((user) {
                          return DropdownMenuItem(
                            value: user,
                            child: SizedBox(
                              width: kwidth(context) * 0.7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  user.name,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: kheight(context) * 0.03),
                    Text(KeyValues.selectDepartment,
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: kheight(context) * 0.01),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<DeptItem>(
                        hint: Text(
                          KeyValues.nothingSelected,
                          style: TextStyle(fontSize: 12),
                        ),
                        elevation: 8,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: kwidth(context) * 0.04),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        dropdownColor: Colors.green.shade50,
                        value: _selectDept,
                        onChanged: (Value) async {
                          setState(() {
                            _selectDept = Value;
                            departmentController.text =
                                _selectDept!.departmentId;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select department' : null,
                        items: deptItems.map((user) {
                          return DropdownMenuItem(
                            value: user,
                            child: SizedBox(
                              width: kwidth(context) * 0.7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  user.name,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: kheight(context) * 0.03),
                    // Text(KeyValues.selectPriority,
                    //     style: Theme.of(context).textTheme.bodyText2),
                    // SizedBox(height: kheight(context) * 0.01),
                    // Container(
                    //   decoration: kDropdownContainerDeco,
                    //   child: DropdownButtonFormField<PriorityItem>(
                    //     hint: Text(
                    //       KeyValues.nothingSelected,
                    //       style: TextStyle(fontSize: 12),
                    //     ),
                    //     elevation: 8,
                    //     decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.symmetric(
                    //           horizontal: kwidth(context) * 0.04),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Colors.grey.shade100, width: 2),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       border: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Colors.grey.shade100, width: 2),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     dropdownColor: Colors.green.shade50,
                    //     value: _selectPriority,
                    //     onChanged: (Value) async {
                    //       setState(() {
                    //         _selectPriority = Value;
                    //         priorityController.text =
                    //             _selectPriority!.priorityid;
                    //       });
                    //     },
                    //     validator: (value) =>
                    //         value == null ? 'Please select priority' : null,
                    //     items: priorityItems.map((user) {
                    //       return DropdownMenuItem(
                    //         value: user,
                    //         child: SizedBox(
                    //           width: kwidth(context) * 0.7,
                    //           child: SingleChildScrollView(
                    //             scrollDirection: Axis.horizontal,
                    //             child: Text(
                    //               user.name,
                    //               style: TextStyle(
                    //                   color: Colors.black, fontSize: 12),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),

                    Text('Please describe detail about what you need',
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: kheight(context) * 0.01),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: kwidth(context) * 0.03,
                            vertical: kheight(context) * 0.01),
                        width: kwidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade200, width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 3,
                                  blurStyle: BlurStyle.outer)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: kDropdownContainerDeco,
                              // height: kheight(context) * 0.3,
                              child: TextFormField(
                                controller: controller, maxLines: 15,

                                // textInputAction: TextInputAction.next,
                                // focusNode: _subjectFocus,
                                // onFieldSubmitted: (term) {
                                //   _fieldFocusChange(context, _subjectFocus,
                                //       _descriptionFocus);
                                // },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Description';
                                  }
                                  return null;
                                },
                                style: kTextformStyle,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  hintText: KeyValues.enterSubject,
                                  hintStyle: kTextformHintStyle,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kheight(context) * 0.01,
                            ),
                            Text(
                              KeyValues.attachment +
                                  ' (Please add photo or doc)',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: kheight(context) * 0.01,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();

                                    showGeneralDialog(
                                        transitionBuilder:
                                            (context, a1, a2, widget) {
                                          return Transform.scale(
                                            scale: a1.value,
                                            child: Opacity(
                                                opacity: a1.value,
                                                child: AttachmentAddDialogBox(
                                                  isMultiImage: true,
                                                )),
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
                                        }).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: kheight(context) * 0.01,
                                          horizontal: kwidth(context) * 0.04),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      child: Text(
                                        KeyValues.chooseFile,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                ),
                                SizedBox(
                                  width: kwidth(context) * 0.02,
                                ),
                                SizedBox(
                                  width: kwidth(context) * 0.3,
                                  child: Marquee(
                                    child: Text(
                                      multiFileList.isEmpty
                                          ? "No File"
                                          : multiFileList.length > 1
                                              ? 'Multiple Files Selected'
                                              : multiFileList.first.fileName,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                                if (multiFileList.length > 1)
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return multipleItemDialog(
                                                  kheight(context),
                                                  kwidth(context));
                                            }).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Text('View All',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w700))),
                              ],
                            ),
                            SizedBox(
                              height: kheight(context) * 0.01,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kheight(context) * 0.03,
                    ),
                    SizedBox(
                      height: kheight(context) * 0.045,
                      width: kwidth(context),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              is_state = 0;
                            });
                            addTicket();
                          }
                        },
                        child: is_state == 0
                            ? CircularProgressIndicator()
                            : Text(
                                KeyValues.submitTicket,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Handle Keyboard focus on different TextFormfield
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //Api call to get project list, department list and priority list
  // using differnt category (like project, priority and department)
  Future<void> getAddTicketDept(String type) async {
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData('user_id'),
      "category": type
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_CATEGORY_DATA, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data["status"] == 1) {
      setState(() {
        if (type == 'project') {
          _projects = data['data'];
          for (int i = 0; i < _projects.length; i++) {
            projectItems.add(Project(_projects[i]['id'], _projects[i]['name']));
          }
        } else if (type == 'department') {
          _department = data['data'];
          for (int i = 0; i < _department.length; i++) {
            deptItems.add(DeptItem(
                _department[i]['departmentid'], _department[i]['name']));
          }
        }
        //  else if (type == 'priority') {
        //   _priority = data['data'];
        //   for (int i = 0; i < _priority.length; i++) {
        //     priorityItems.add(
        //         PriorityItem(_priority[i]['priorityid'], _priority[i]['name']));
        //   }
        // }
      });
    } else {
      projectItems.clear();
      deptItems.clear();
      // priorityItems.clear();
      ToastShowClass.toastShow(context, "Data not found", Colors.red);
    }
  }

  //Api call to add ticket with image on server (using Multipart)
  // once ticket will add we redirect user to previous screen ie SupportTicket
  Future<void> addTicket() async {
    print('here 1');
    final uri = Uri.https(ApiClass.BaseURL, ApiClass.ADD_TICKET);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (ApiClass.api_key);
    request.fields['userid'] =
        await SharedPreferenceClass.getSharedData('user_id');
    request.fields['project_id'] = projectController.text;
    request.fields['department'] = departmentController.text;
    // request.fields['priority'] = priorityController.text;
    request.fields['subject'] = subjectController.text;
    request.fields['message'] = await controller.text;
    var file;
    print('here 2');

    if (multiFileList.isNotEmpty) {
      for (var i = 0; i < multiFileList.length; i++) {
        var stream = http.ByteStream(
            DelegatingStream.typed(multiFileList[i].file.openRead()));
        var length = await multiFileList[i].file.length();
        file = http.MultipartFile('attachments[]', stream, length,
            filename: multiFileList[i].file.path.split("/").last);
        request.files.add(file);
      }
    }
    print('here 3');

    // if (image != null) {
    //   var stream = http.ByteStream(DelegatingStream.typed(image!.openRead()));
    //   var length = await image!.length();
    //   file = http.MultipartFile('attachments[]', stream, length,
    //       filename: image!.path.split('/').last);
    //   request.files.add(file);
    // }
    var response = await request.send();
    print(response.statusCode);
    // response.stream.transform(streamTransformer)
    response.stream.transform(utf8.decoder).listen((value) {
      print("adding Support Ticket" + response.statusCode.toString());

      if (response.statusCode == 200) {
        setState(() {
          is_state = 1;
          ToastShowClass.toastShow(
              context, 'Ticket Added Successfully', Colors.green);
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(SupportScreen.id);
        });
      } else {
        setState(() {
          is_state = 1;
          ToastShowClass.toastShow(
              context, 'Internal server error', Colors.green);
        });
      }
    });
    print('here 5');

  }

  //This method will be called after selecting image from camera or gallery
  // getCapturedImage() {
  //   setState(() {
  //     image = imageFile;
  //     if (image != null) {
  //       isCaptured = false;
  //     }
  //   });
  // }
}

//Model Class for Priority Items
class PriorityItem {
  String priorityid;
  String name;

  PriorityItem(this.priorityid, this.name);
}

//Model Class for Project Items
class Project {
  String id;
  String name;

  Project(this.id, this.name);
}

//Model Class for Department Items
class DeptItem {
  String departmentId;
  String name;

  DeptItem(this.departmentId, this.name);
}
