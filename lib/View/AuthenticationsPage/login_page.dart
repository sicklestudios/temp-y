import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/authentication_controller.dart';
import 'package:ystyle/View/AuthenticationsPage/signup_with_email_page.dart';
 import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/custom_buttton.dart';
import 'package:ystyle/widgets/transparent_textfield.dart';

import 'forgot_paswword.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                    Image.asset(
                      'assets/images/logo.jpg',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: height * 0.1,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: whiteFontStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0),
                        ),
                        transParentTextField(
                          controller: controller.emailController,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Password',
                          style: whiteFontStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0),
                        ),
                        transParentTextField(
                          obscureText: controller.showPassword.value,
                          controller: controller.passwordController,
                        ),
                        const SizedBox(height: 30),
                        controller.isLoading.value ?
                        Center(child: CircularProgressIndicator(
                          color: whiteColor,
                        ),) :
                        customButton('LOGIN', () {
                          controller.login();
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            Get.to(()=> Forgot_password());
                          },
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Forgotten Your Password?',
                                style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.1,),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> SignUpWithEmail());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Need an account?',
                            style: whiteFontStyle(
                                fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'SignUp',
                            style: whiteFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.0),
                          ),
                        ],
                      ),
                    )
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
