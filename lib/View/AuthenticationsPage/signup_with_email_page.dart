import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/authentication_controller.dart';
 import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/custom_buttton.dart';
import 'package:ystyle/widgets/transparent_textfield.dart';

import 'user_genre_info.dart';

class SignUpWithEmail extends StatelessWidget {
  const SignUpWithEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<AuthenticationController>(
        init: AuthenticationController(),
        builder: (controller){
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
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'logoTag',
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Register in YStyle',style: whiteFontStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                    SizedBox(height: height * 0.1,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: whiteFontStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0),
                        ),
                        transParentTextField(
                          controller: controller.userNameController,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email',
                          style: whiteFontStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0),
                        ),
                        transParentTextField(
                          controller: controller.emailController,
                        ),
                        const SizedBox(height: 10),
                        Text('Password',
                          style: whiteFontStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0),
                        ),
                        transParentTextField(
                          controller: controller.passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        controller.isLoading.value
                            ? Center(child: CircularProgressIndicator(color: whiteColor,))
                            : customButton('SIGN UP', () async{
                              if(controller.userNameController.text.isEmpty) {
                                Get.snackbar("Error", "Please Enter User Name",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }else{
                                await controller.signup();
                              }
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
