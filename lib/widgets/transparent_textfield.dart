import 'package:flutter/material.dart';
import 'package:ystyle/Utils/constant.dart';
Widget transParentTextField ({TextEditingController? controller,bool? obscureText,bool? readonly}){
  return Container(
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      color: appColor.withOpacity(0.7),
      borderRadius:
      BorderRadius.circular(5),
      border: Border.all(
        color: primaryColor,
      ),
    ),
    child: TextFormField(
      readOnly: readonly == null ? false: readonly,
      obscureText: obscureText == null ? false : obscureText,
      controller: controller,
      cursorColor: whiteColor,
      style: TextStyle(color: whiteColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(15),
        isDense: true,
      ),
    ),
  );
}

Widget customTextField ({TextEditingController? controller,bool? obscureText,bool? readonly}){
  return Container(
    height: 40,
    width: double.infinity,
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius:
      BorderRadius.circular(5),
      border: Border.all(
        color: primaryColor,
      ),
    ),
    child: TextFormField(
      readOnly: readonly == null ? false: readonly,
      obscureText: obscureText == null ? false : obscureText,
      controller: controller,
      cursorColor: primaryColor,
      style: TextStyle(color: primaryColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(10),
        isDense: true,
      ),
    ),
  );
}