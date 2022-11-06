

// snack bar widget to show message
import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController ShowSuccesSnackbar({String? title, String? message}) {
  return Get.snackbar(
    title!,
    message!,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}