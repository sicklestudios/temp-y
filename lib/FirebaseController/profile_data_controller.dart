import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/NavigationBarScreen/nav_bar.dart';

class ProfileDataController extends GetxController implements GetxService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxString? gender;
  RxString? dob;
  XFile? image;
  RxString? imgUrl;
  RxBool isloading = false.obs;
  RxBool isImageUpLoading = false.obs;
  List<dynamic> interestListWhichDescribeUser = [];
  String? userType;

  getProfileData() async {
    var user = _auth.currentUser;
    var uid = user!.uid;
    DocumentSnapshot data = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    nameController.text = data['name'];
    emailController.text = data['email'];
    phoneController.text = data['phone'];
    gender = data['gender'] != null || data['gender'] != ''?  RxString(data['gender']):null;
    dob = RxString(data['d_o_b']);
    imgUrl = RxString(data['image']);
    userType = data['user_type'];
    interestListWhichDescribeUser = data['interest'];
  }

  updateProfileData() async {
    isloading = true.obs;
    update();
    var user = _auth.currentUser;
    var uid = user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'gender': gender.toString(),
      'd_o_b': dob != "" ? DateTime.parse(dob.toString()).toString() : '',
    });
    isloading = false.obs;
    update();
    Get.snackbar(
      "Success",
      "Profile Updated Successfully",
      colorText: Colors.white,
      backgroundColor: primaryColor,
    );
  }

  uploadProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      File image = new File(pickedFile!.path);

      isImageUpLoading = true.obs;
      update();

      //Create a reference to the location you want to upload to in firebase
      Reference reference = _storage.ref('ProfilePictures').child("${_auth.currentUser!.uid}");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);

      // Waits till the file is uploaded then stores the download url
      String location = await uploadTask.storage.ref('ProfilePictures').child("${_auth.currentUser!.uid}").getDownloadURL();

      // update link of profile in database
      await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update({
        'image': location,
      });

      await getProfileData();

      Get.snackbar(
        "Success",
        "Profile Image Updated Successfully",
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );

    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }

    isImageUpLoading = false.obs;
    update();
  }

  updateUserTypeAndInterest(usertype) async {
    isloading = true.obs;
    update();
    var user = _auth.currentUser;
    var uid = user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'user_type': usertype,
      'interest': interestListWhichDescribeUser,
    });
    isloading = false.obs;
    update();
    Get.off(() => NavBarPage());
  }

  selectGenderFunction(int _Selectgender) {
    if (_Selectgender == 1) {
      gender = "male".obs;
    } else {
      gender = "female".obs;
    }
    update();
  }

  selectDateFunction(DateTime _SelectDate) {
    dob = _SelectDate.toString().obs;
    update();
  }

  addOrRemoveGenreFromList(genre) {
    if (interestListWhichDescribeUser.length <= 3) {
      if (interestListWhichDescribeUser.contains(genre)) {
        interestListWhichDescribeUser.remove(genre);
      } else {
        interestListWhichDescribeUser.add(genre);
      }
    } else {
      if (interestListWhichDescribeUser.contains(genre)) {
        interestListWhichDescribeUser.remove(genre);
      } else {
        Get.snackbar(
          "Sorry",
          "You can select only four.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    }
    update();
  }
}
