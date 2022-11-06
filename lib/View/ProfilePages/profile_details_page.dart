import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ystyle/FirebaseController/profile_data_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/widgets/custom_buttton.dart';
import 'package:ystyle/widgets/transparent_textfield.dart';
import 'package:ystyle/widgets/user_information_container_design.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.grey),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: GetBuilder<ProfileDataController>(
            init: ProfileDataController(),
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.isImageUpLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: FadeInImage(
                                    placeholder: AssetImage(
                                      'assets/images/launcher_icon.jpg',
                                    ),
                                    image: NetworkImage(
                                      controller.imgUrl.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                    height: 110,
                                    width: 110,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: primaryColor,
                                    child: IconButton(
                                      onPressed: () async {
                                        await controller.uploadProfileImage();
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          customTextField(
                            controller: controller.nameController,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email',
                            style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          customTextField(
                            controller: controller.emailController,
                            readonly: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone Number',
                            style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          customTextField(
                            controller: controller.phoneController,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Your Gender',
                            style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  controller.selectGenderFunction(1);
                                },
                                child: Text(
                                  'Male',
                                  style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                                ),
                                color: controller.gender == 'male' ? primaryColor : greyColor,
                                height: 40,
                                minWidth: 100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  controller.selectGenderFunction(2);
                                },
                                child: Text(
                                  'Female',
                                  style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                                ),
                                color: controller.gender == 'female' ? primaryColor : greyColor,
                                height: 40,
                                minWidth: 100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Date of Birth',
                            style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: Text(
                                    controller.dob != "" ? controller.dob.toString().substring(0, 10) : "-- -- --",
                                    style: customFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0, Color: primaryColor),
                                  ),
                                  color: whiteColor,
                                  height: 40,
                                  minWidth: 100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                flex: 3,
                                child: MaterialButton(
                                  onPressed: () {
                                    // show date picker
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Select Date'),
                                          content: Container(
                                            height: height * 0.3,
                                            child: CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode.date,
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged: (DateTime newDateTime) {
                                                controller.selectDateFunction(newDateTime);
                                              },
                                            ),
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: Text('Ok'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Select',
                                    style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                                  ),
                                  color: primaryColor,
                                  height: 40,
                                  minWidth: 100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          controller.isloading.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: primaryColor,
                                ))
                              : MaterialButton(
                                  onPressed: () {
                                    controller.updateProfileData();
                                  },
                                  child: Text(
                                    'Save',
                                    style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                                  ),
                                  color: primaryColor,
                                  height: 40,
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
