// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, prefer_final_fields, import_of_legacy_library_into_null_safe, must_be_immutable, non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';

import 'package:async/async.dart';
import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Support/add_ticket_screen.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/AttachmentDialog.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/app_key.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart' as http;
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

class ProjectAddTicket extends StatefulWidget {
  static const id = 'projectAddTicket';
  PassData data;
  ProjectAddTicket({required this.data});
  @override
  State<ProjectAddTicket> createState() => _ProjectAddTicketState();
}

class _ProjectAddTicketState extends State<ProjectAddTicket> {
  int is_state = 3;
  final _formKey = GlobalKey<FormState>();
  final _subjectFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final HtmlEditorController controller = HtmlEditorController();

  //TextEditingController for TextformField to get data
  TextEditingController subjectController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<DeptItem> deptItems = [];
  List _department = [];
  DeptItem? _selectDept;

  /*List<Project> projectItems = [];
  List _projects = [];
  Project _selectProject;*/

  List<PriorityItem> priorityItems = [];
  List _priority = [];
  PriorityItem? _selectPriority;
  // File? image;
  // bool isCaptured = true;

  @override
  void initState() {
    multiFileList.clear();
    super.initState();
    print("ID_ID" + widget.data.id);

    //Getting Department List
    getAddTicketDept("department");

    //Getting Priority List
    getAddTicketDept("priority");
  }

  @override
  Widget build(BuildContext context) {
    print(multiFileList.length);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: kheight(context) * 0.25,
                    padding: EdgeInsets.only(
                        left: kwidth(context) * 0.04,
                        top: kheight(context) * 0.1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            height: kheight(context) * 0.09,
                            width: kwidth(context) * 0.22,
                            child: Image.asset(
                              'assets/projects.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: kwidth(context) * 0.03,
                          ),
                          Text(
                            KeyValues.projects,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: kheight(context) * 0.22),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: kwidth(context) * 0.05,
                            vertical: kheight(context) * 0.012),
                        decoration: BoxDecoration(
                          color: Color(0xFF426C29),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          "# " + widget.data.id + "-" + widget.data.url,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
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
                        validator: (value) =>
                            value == null ? 'Please select department' : null,
                        value: _selectDept,
                        onChanged: (Value) async {
                          setState(() {
                            _selectDept = Value;
                            departmentController.text =
                                _selectDept!.departmentId;
                          });
                        },
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
                    Text(KeyValues.selectPriority,
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: kheight(context) * 0.01),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<PriorityItem>(
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
                        validator: (value) =>
                            value == null ? 'Please select priority' : null,
                        value: _selectPriority,
                        onChanged: (Value) async {
                          setState(() {
                            _selectPriority = Value;
                            priorityController.text =
                                _selectPriority!.priorityid;
                          });
                        },
                        items: priorityItems.map((user) {
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
                    SizedBox(
                      height: kheight(context) * 0.03,
                    ),
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
                            SizedBox(
                                height: kheight(context) * 0.3,
                                child: HtmlEditor(
                                  controller: controller,
                                  htmlEditorOptions:
                                      HtmlEditorOptions(hint: 'Your Text Here'),
                                  otherOptions: OtherOptions(
                                    decoration: kDropdownContainerDeco,
                                  ),
                                )),
                            SizedBox(
                              height: kheight(context) * 0.01,
                            ),
                            Text(
                              KeyValues.attachment,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: kheight(context) * 0.01,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
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
                            addProjectTicket();
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

  //Handling Keyboard Focus on different TextFormField
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //Api Call to get department list from server
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
        if (type == 'department') {
          _department = data['data'];
          for (int i = 0; i < _department.length; i++) {
            deptItems.add(DeptItem(
                _department[i]['departmentid'], _department[i]['name']));
          }
        } else if (type == 'priority') {
          _priority = data['data'];
          for (int i = 0; i < _priority.length; i++) {
            priorityItems.add(
                PriorityItem(_priority[i]['priorityid'], _priority[i]['name']));
          }
        }
      });
    } else {
      deptItems.clear();
      priorityItems.clear();
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  // Adding ticket on a particular project by projectid and
  // also adding image related to that ticket using Multipart
  Future<void> addProjectTicket() async {
    final uri = Uri.https(ApiClass.BaseURL, ApiClass.ADD_TICKET);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (ApiClass.api_key);
    request.fields['userid'] =
        await SharedPreferenceClass.getSharedData('user_id');
    request.fields['project_id'] = widget.data.id;
    request.fields['department'] = departmentController.text;
    request.fields['priority'] = priorityController.text;
    request.fields['subject'] = subjectController.text;
    request.fields['message'] = await controller.getText();
    var file;

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
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      if (response.statusCode == 200) {
        setState(() {
          is_state = 1;
          ToastShowClass.toastShow(
              context, 'Ticket Added Successfully', Colors.green);
          Navigator.of(context).pop(true);
        });
      } else {
        setState(() {
          is_state = 1;
          ToastShowClass.toastShow(context, 'error', Colors.green);
        });
      }
    });
  }

  //This method will be called once user select image from gallery or camera
  // getCapturedImage() {
  //   setState(() {
  //     image = imageFile;
  //     if (image != null) {
  //       isCaptured = false;
  //     }
  //   });
  // }
}
