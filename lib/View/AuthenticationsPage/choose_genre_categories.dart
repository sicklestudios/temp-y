import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/profile_data_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/widgets/custom_buttton.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';

import 'signup_with_email_page.dart';

class ChooseCategoriesPage extends StatelessWidget {
  String userType;
   ChooseCategoriesPage(this.userType);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<ProfileDataController>(builder: (controller) {
      return Stack(
        children: [
          BackgroundImage(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.grey),
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBoxHeight(25.0),
                        customButton('WHAT STYLE DESCRIBES YOU?', () {}),
                        SizedBoxHeight(15.0),
                        Row(
                          children: [
                            Expanded(
                              child: customMaterialButton(
                                text: 'TRENDY',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("TRENDY");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('TRENDY') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'BOHEMIAN',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("BOHEMIAN");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('BOHEMIAN') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'CHIC',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("CHIC");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('CHIC') ? whiteColor : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxHeight(15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: customMaterialButton(
                                text: 'SEXY',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("SEXY");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('SEXY') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'CASUAL',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("CASUAL");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('CASUAL') ? whiteColor : Colors.transparent,
                              ),
                            ),
                             SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'TOMBOY',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("TOMBOY");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('TOMBOY') ? whiteColor : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxHeight(15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: customMaterialButton(
                                text: 'ARTSY',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("ARTSY");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('ARTSY') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'EDGY',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("EDGY");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('EDGY')
                                    ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'KIDCORE',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("KIDCORE");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('KIDCORE') ? whiteColor : Colors.transparent,
                              ),
                            ),
                           ],
                        ),
                        SizedBoxHeight(15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: customMaterialButton(
                                text: 'COTTAGECORE',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("COTTAGECORE");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('COTTAGECORE') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'LIGHTACADEMIA',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("LIGHTACADEMIA");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('LIGHTACADEMIA')
                                    ? whiteColor : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxHeight(15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: customMaterialButton(
                                text: 'DARKACADEMIA',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("DARKACADEMIA");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('DARKACADEMIA') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'ROYALCORE',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("ROYALCORE");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('ROYALCORE') ? whiteColor : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxHeight(15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: customMaterialButton(
                                text: 'VISCO',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("VISCO");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('VISCO') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'SOFTIE',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("SOFTIE");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('SOFTIE') ? whiteColor : Colors.transparent,
                              ),
                            ),
                            SizedBoxWidth(10.0),
                            Expanded(
                              child: customMaterialButton(
                                text: 'NON BINARY',
                                ontap: () {
                                  controller.addOrRemoveGenreFromList("NON BINARY");
                                },
                                color: appColor,
                                width: 90.0,
                                siderColor: controller.interestListWhichDescribeUser.contains('NON BINARY') ? whiteColor : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxHeight(10.0),
                        controller.isloading.value ?
                            Center(
                              child: CircularProgressIndicator(
                                color: appColor,
                              ),
                            ):
                        customMaterialButton(
                          text: "SAVE",
                          color: appColor,
                          ontap: (){
                            controller.updateUserTypeAndInterest("fashionista");
                          },
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Hero(
                          tag: 'logoTag',
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 50,
                            height: 50,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
