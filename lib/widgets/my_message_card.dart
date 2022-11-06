import 'package:flutter/material.dart';
import 'package:ystyle/Utils/constant.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String image;

  const MyMessageCard({required this.message, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Container(
              width: 200,
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: Text(
                message,
                style: whiteFontStyle(fontSize: 12.0),
              ),
            ),
            CircleAvatar(
              radius: 15.0,
              backgroundImage: AssetImage('assets/images/favourite.jpg'),
            ),
          ],
        ));
  }
}
