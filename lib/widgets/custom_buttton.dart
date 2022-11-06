import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/Utils/constant.dart';

Widget customButton(String text, var ontap) {
  return InkWell(
    onTap: ontap,
    child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          gradient: LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: whiteFontStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        )),
  );
}

Widget customButtonWithColors(String text, var ontap, Color firstColor, Color secondColor) {
  return InkWell(
    onTap: ontap,
    child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              firstColor,
              secondColor,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: whiteFontStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        )),
  );
}

Widget customMaterialButton({
   required String text,
    required var ontap,
    required Color color,
   double? height,
   double? width,
  Color? siderColor,
}) {
  return MaterialButton(
    onPressed: ontap,
    child: Text(text),
    color: color,
    textColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: BorderSide(color: siderColor != null? siderColor :Colors.transparent,width: 1.0),
    ),
    height: height,
    minWidth: width,
  );
}
