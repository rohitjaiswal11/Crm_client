// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison, prefer_if_null_operators, deprecated_member_use

import 'package:crm_client/Profile/editProfile.dart';
import 'package:crm_client/util/ApiClass.dart';
import 'package:crm_client/util/PreviewDialogBox.dart';
import 'package:crm_client/util/constants.dart';
import 'package:crm_client/util/storage_manger.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const id = 'profile';
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstName = '',
      lastName = '',
      email = '',
      phone = '',
      newFirstName = '',
      newLastName = '',
      newEmail = '',
      newPhone = '',
      image = '',
      newImage = '',
      task = '',
      project = '',
      newTask = '',
      newProject = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    //getting sharedPreference data
    getSharedPrefData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: kheight(context) * 0.25,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: kwidth(context) * 0.07),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                            child: newImage == null || newImage == ''
                                ? Image.asset(
                                    'assets/dummy_profile.jpg',
                                    fit: BoxFit.fill,
                                  )
                                : InkWell(
                                    onTap: () async {
                                      fileUrl = 'https://' +
                                          ApiClass.BaseURL +
                                          "/crm/uploads/client_profile_images/" +
                                          contactId +
                                          "/thumb_" +
                                          newImage;

                                      showGeneralDialog(
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          transitionBuilder:
                                              (context, a1, a2, widget) {
                                            return Transform.scale(
                                              scale: a1.value,
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: PreviewDialogBox(),
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
                                    child: Image.network(
                                      'https://' +
                                          ApiClass.BaseURL +
                                          "/crm/uploads/client_profile_images/" +
                                          contactId +
                                          "/thumb_" +
                                          newImage,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/dummy_profile.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: kwidth(context) * 0.07,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newFirstName == null
                                  ? ''
                                  : newFirstName + " " + newLastName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Text('Edit Your profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.w200)),
                                SizedBox(
                                  width: kwidth(context) * 0.03,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, EditProfile.id);
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: kwidth(context) * 0.07,
                      right: kwidth(context) * 0.07,
                      top: kheight(context) * 0.22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      profileontainer(
                          width: kwidth(context),
                          height: kheight(context),
                          title: 'Project Email',
                          number: newProject == null ? '0' : newProject),
                      profileontainer(
                          width: kwidth(context),
                          height: kheight(context),
                          title: 'Task Email',
                          number: newTask == null ? '0' : newTask)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kheight(context) * 0.04,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kwidth(context) * 0.06,
                  vertical: kheight(context) * 0.03),
              height: kheight(context) * 0.68,
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
                      enabled: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                      style: kTextformStyle,
                      decoration: InputDecoration(
                        contentPadding: kcontentPadding(kwidth(context)),
                        hintText: newFirstName == null ? '' : newFirstName,
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
                      enabled: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the Last Name';
                        }
                        return null;
                      },
                      style: kTextformStyle,
                      decoration: InputDecoration(
                        contentPadding: kcontentPadding(kwidth(context)),
                        hintText: newLastName == null ? '' : newLastName,
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
                      enabled: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the Email';
                        }
                        return null;
                      },
                      style: kTextformStyle,
                      decoration: InputDecoration(
                        contentPadding: kcontentPadding(kwidth(context)),
                        hintText: newEmail == null ? '' : newEmail,
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
                      enabled: false,
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
                        hintText: newPhone == null ? '' : newPhone,
                        hintStyle: kTextformHintStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Getting data from sharedPreference and assigning it to variables in setState()
  getSharedPrefData() async {
    firstName = await SharedPreferenceClass.getSharedData("first_name");
    lastName = await SharedPreferenceClass.getSharedData("last_name");
    email = await SharedPreferenceClass.getSharedData("email");
    phone = await SharedPreferenceClass.getSharedData("phone");
    image = await SharedPreferenceClass.getSharedData('image');
    task = await SharedPreferenceClass.getSharedData('task');
    project = await SharedPreferenceClass.getSharedData('project');

    setState(() {
      newFirstName = firstName;
      newLastName = lastName;
      newEmail = email;
      newPhone = phone;
      newImage = image;
      newTask = task;
      newProject = project;
    });
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
