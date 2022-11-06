import 'package:flutter/material.dart';
import 'package:ystyle/Utils/constant.dart';

Widget CustomInformationContainer(
  String text,
) {
  return Card(
    elevation: 10.0,
    child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5),

          // border: Border.all(
          //   color: primaryColor,
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
          child: Text(
            text,
            style: blackFontStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
          ),
        )),
  );
}
