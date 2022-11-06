import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/Utils/constant.dart';
 import 'package:ystyle/widgets/custom_buttton.dart';

import 'signup_with_email_page.dart';
import 'choose_genre_categories.dart';

class UserInformationPage extends StatelessWidget {
  late String userType;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                      tag: 'logoTag',
                      child: Image.asset('assets/images/logo.jpg', width: 100,height: 100,)),
                  Column(
                    children: [
                      SizedBox(height: height * 0.2,),
                      customButton('ARE YOU A FASHIONISTA?',(){
                        userType = 'Fashionista';
                        Get.to(()=> ChooseCategoriesPage(userType));
                      }),
                      const SizedBox(height: 20),
                      customButtonWithColors('ARE YOU A DESIGNER',(){
                        userType = 'Designer';
                        Get.to(()=> ChooseCategoriesPage(userType));}, secondaryColor, primaryColor),
                    ],),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
