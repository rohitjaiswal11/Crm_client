// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, unnecessary_null_comparison, prefer_if_null_operators, import_of_legacy_library_into_null_safe, prefer_adjacent_string_concatenation, avoid_print, deprecated_member_use, prefer_typing_uninitialized_variables, prefer_final_fields, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:crm_client/Profile/profile.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/AttachmentDialog.dart';
import 'package:crm_client/util/LicenseKey.dart';
import 'package:crm_client/util/ToastClass.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';
import '../Lbm plugin/lbmplugin.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class  EditProfile extends StatefulWidget {
  static const id = 'Editprofile';
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int? state;
  List profileData = [];
  String firstName = '',
      lastName = '',
      email = '',
      phone = '',
      imagepath = '',
      newFirstName = '',
      newLastName = '',
      newEmail = '',
      newPhone = '';
  String? newImage;
  //TextEditingController for TextFormField
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String contactId = '';
  final _formKey = GlobalKey<FormState>();
  File? image;
  bool isCaptured = false;
  //FocusNode for TextForm Field
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    //Getting data from SharedPreferenceClass
    getSharedData();
  }

  @override
  void dispose() {
    changedImage = null;
    super.dispose();
  }

  //Getting Data from SharedPreference Class, assigning the value to variables and to textEditorController inside setState()
  void getSharedData() async {
    String contact = await SharedPreferenceClass.getSharedData("contact_id");
    firstName = await SharedPreferenceClass.getSharedData("first_name");
    lastName = await SharedPreferenceClass.getSharedData("last_name");
    email = await SharedPreferenceClass.getSharedData("email");
    phone = await SharedPreferenceClass.getSharedData("phone");
    imagepath = await SharedPreferenceClass.getSharedData("image");
    setState(() {
      contactId = contact;
      newFirstName = firstName;
      newLastName = lastName;
      newEmail = email;
      newPhone = phone;
      newImage = imagepath;
    });
    firstNameController =
        TextEditingController(text: newFirstName == null ? "" : newFirstName);
    lastNameController =
        TextEditingController(text: newLastName == null ? "" : newLastName);
    emailController =
        TextEditingController(text: newEmail == null ? "" : newEmail);
    phoneController =
        TextEditingController(text: newPhone == null ? "" : newPhone);
  }

  //Api Call to get User Profile info from server
  // using user_id and type 'profile'
  Future<void> getProfileInfo(BuildContext context) async {
    print("GEtPROFILE");
    final paramDic = {
      "id": await SharedPreferenceClass.getSharedData('user_id'),
      "type": "profile"
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        ApiClass.GET_PROFILE, paramDic, 'Get', Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      setState(() {
        state = 1;
        //adding user data to SharedPreferenceClass
        // and redirecting user to ProfileScreen once he updated his information
        SharedPreferenceClass.setSharedData(
            "first_name", data["data"]["firstname"]);
        SharedPreferenceClass.setSharedData(
            "last_name", data["data"]["lastname"]);
        SharedPreferenceClass.setSharedData("email", data["data"]["email"]);
        SharedPreferenceClass.setSharedData(
            "phone", data["data"]["phonenumber"]);
        SharedPreferenceClass.setSharedData(
            "image", data["data"]["profile_image"]);
        SharedPreferenceClass.setSharedData(
            'task', data["data"]["task_emails"]);
        SharedPreferenceClass.setSharedData(
            'project', data["data"]["project_emails"]);
        ToastShowClass.toastShow(
            context, 'Profile Updated Successfully', Colors.green);
        changedImage = null;

        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(Profile.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Changed Image' + changedImage.toString());
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: kheight(context) * 0.25,
                width: kwidth(context),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kwidth(context) * 0.2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showGeneralDialog(
                                  transitionBuilder: (context, a1, a2, widget) {
                                    return Transform.scale(
                                      scale: a1.value,
                                      child: Opacity(
                                          opacity: a1.value,
                                          child: AttachmentAddDialogBox(
                                              isEdit: true)),
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
                            child: Container(
                              padding: EdgeInsets.all(2),
                              width: kwidth(context) * 0.17,
                              height: kwidth(context) * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: changedImage != null
                                      ? Image.file(
                                          changedImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : newImage == null
                                          ? Image.asset(
                                              'assets/dummy_profile.jpg',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              'https://' +
                                                  ApiClass.BaseURL +
                                                  "/crm/uploads/client_profile_images/" +
                                                  contactId +
                                                  "/thumb_" +
                                                  newImage!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                'assets/dummy_profile.jpg',
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                            ),
                          ),
                          SizedBox(
                            height: kheight(context) * 0.01,
                          ),
                          Text(
                            'Edit Profile',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                      SizedBox(
                        width: kwidth(context) * 0.07,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$newFirstName $newLastName',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: kheight(context) * 0.005,
                          ),
                          Text(
                            newEmail,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: kheight(context) * 0.04,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: kwidth(context) * 0.06,
                    vertical: kheight(context) * 0.03),
                height: kheight(context) * 0.71,
                width: kwidth(context),
                decoration: kContaierDeco,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: kheight(context) * 0.03,
                    ),
                    Text('First Name'),
                    SizedBox(
                      height: kheight(context) * 0.02,
                    ),
                    Container(
                      height: kheight(context) * 0.06,
                      width: kwidth(context),
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        focusNode: firstNameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, firstNameFocus, lastNameFocus);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the First Name';
                          }
                          return null;
                        },
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: kcontentPadding(kwidth(context)),
                          hintText: ' Enter First Name',
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kheight(context) * 0.03,
                    ),
                    Text('Last Name'),
                    SizedBox(
                      height: kheight(context) * 0.02,
                    ),
                    Container(
                      height: kheight(context) * 0.06,
                      width: kwidth(context),
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: lastNameController,
                        textInputAction: TextInputAction.next,
                        focusNode: lastNameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, lastNameFocus, emailFocus);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the Last Name';
                          }
                          return null;
                        },
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: kcontentPadding(kwidth(context)),
                          hintText: 'Enter Last Name',
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kheight(context) * 0.03,
                    ),
                    Text('Email'),
                    SizedBox(
                      height: kheight(context) * 0.02,
                    ),
                    Container(
                      height: kheight(context) * 0.06,
                      width: kwidth(context),
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        focusNode: emailFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, emailFocus, phoneFocus);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the Email';
                          }
                          return null;
                        },
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: kcontentPadding(kwidth(context)),
                          hintText: 'Enter Email Address',
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kheight(context) * 0.03,
                    ),
                    Text('Phone Number'),
                    SizedBox(
                      height: kheight(context) * 0.02,
                    ),
                    Container(
                      height: kheight(context) * 0.06,
                      width: kwidth(context),
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: phoneController,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the Phone Number';
                          }
                          return null;
                        },
                        style: kTextformStyle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: kcontentPadding(kwidth(context)),
                          hintText: 'Number',
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kheight(context) * 0.04,
                    ),
                    SizedBox(
                      height: kheight(context) * 0.045,
                      width: kwidth(context),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: () {
                          setState(() {
                            //check if data valid UpdateProfile() will called
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                state = 0;
                              });
                              UpdateProfile(context, image!);
                              //UpdateProfile();
                            }
                          });
                        },
                        child: state == 0
                            ? CircularProgressIndicator()
                            : Text(
                                'Update',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  //Api call To update Profile  also update image using Multipart
  // if statusCode 200, we are calling getProfileInfo()
  Future UpdateProfile(BuildContext context, File image) async {
    // var uri = Uri.parse("https://crmapi.lbmsolutions.in/clientapi/Clientprofile");
    final uri = Uri.https(ApiClass.BaseURL, ApiClass.GET_PROFILE);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (ApiClass.api_key);
    request.fields['userid'] =
        await SharedPreferenceClass.getSharedData('user_id');
    request.fields['firstname'] = firstNameController.text;
    request.fields['lastname'] = lastNameController.text;
    request.fields['email'] = emailController.text;
    request.fields['phonenumber'] = phoneController.text;
    var file;

    if (image != null) {
      var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();
      file = http.MultipartFile('profile_image', stream, length,
          filename: basename(image.path));
      request.files.add(file);
    }

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      //  Map<String, dynamic> data = jsonDecode(value);
      print("UpdateProfile" + " " + response.statusCode.toString());
      if (response.statusCode == 200) {
        getProfileInfo(context);
      } else {
        setState(() {
          state = 1;
        });
        // ToastShowClass.toastShow(data['message'],Colors.red);
      }
    });
  }

  /* Future <void> UpdateProfile() async {
    final paramDic={
      "userid":await SharedPreferenceClass.getSharedData('user_id'),
      "firstname": firstNameController.text,
      "lastname":lastNameController.text,
      "email":emailController.text,
      "phonenumber":phoneController.text,
    };
    var response= await APIMainClass(ApiClass.GET_PROFILE,paramDic,'Post');
    var data =json.decode(response.body);
    if(data["status"]==1){
      print("data"+" "+data.toString());
      setState(() {
        state=1;
      });
      getProfileInfo(context);
    }else{
      ToastShowClass.toastShow(data["message"], Colors.red);
    }
  }*/

  //Handle keyboard focus on TextFormField
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //this method will call once user select image from camera or gallery
  getCapturedImage() {
    setState(() {
      image = imageFile;
      if (image != null) {
        isCaptured = true;
      }
    });
  }
}
