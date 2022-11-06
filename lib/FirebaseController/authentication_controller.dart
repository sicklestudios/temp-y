import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/View/AuthenticationsPage/register_page.dart';
import 'package:ystyle/View/AuthenticationsPage/user_genre_info.dart';
import 'package:ystyle/View/NavigationBarScreen/nav_bar.dart';
import '../Utils/constant.dart';
import '../View/AuthenticationsPage/login_page.dart';

class AuthenticationController extends GetxController {
  var firestore = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  UserCredential? userCredential;
  RxBool showPassword = true.obs;

  login() async {
    try {
      isLoading(true);
      update();
      userCredential = await auth.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
      if (userCredential != null) {
       await FirebaseFirestore.instance.collection('users').doc(userCredential!.user!.uid).get().then((value) {
          if(value['user_type'] == null || value['user_type'] == ""){
            Get.offAll(() => UserInformationPage());
          }else{
            Get.offAll(() => NavBarPage());
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
      update();
    }
  }

  signup() async {
    try {
      isLoading(true);
      update();
      userCredential = await auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text)
          .then((value) {
        if (value.user != null) {
          firestore.doc(auth.currentUser!.uid.toString()).set({
            'name': userNameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': '',
            'gender': '',
            'd_o_b': '',
            'image': 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
            'user_id': value.user!.uid,
            'created_at': DateTime.now(),
            'user_type': '',
            'interest': [],
          });
        }
      });
      Get.off(() => LoginPage());
      Get.snackbar(
        "Success",
        "User Register Successfully",
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  forgetPassword() async {
    try {
      isLoading(true);
      update();
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar(
        "Success",
        "Reset Password Link Send Successfully",
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    log('loginResult:' + loginResult.message.toString());
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await auth.signInWithCredential(facebookAuthCredential).then((value) {
      firestore.doc(auth.currentUser!.uid.toString()).set({
        'name': value.user!.displayName,
        'email': value.user!.email,
        'phone': '',
        'gender': '',
        'd_o_b': '',
        'image': value.user!.photoURL,
        'user_id': value.user!.uid,
        'created_at': DateTime.now(),
        'user_type': '',
        'interest': [],
      });
    });
    Get.off(() => NavBarPage());
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  /// logout method
  Future logOut() async {
    await auth.signOut();// go to login page
  }



}
