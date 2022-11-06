import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/authentication_controller.dart';
import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/Utils/constant.dart';
 import 'package:ystyle/widgets/custom_buttton.dart';

import 'signup_with_email_page.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<AuthenticationController>(
      init: AuthenticationController(),
      builder: (controller){
        return  Stack(
          children: [
            BackgroundImage(),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      Hero(
                          tag: 'logoTag',
                          child: Image.asset('assets/images/logo.jpg', width: 100,height: 100,)),
                      Column(
                        children: [
                          SizedBox(height: height * 0.2,),
                          customButton('SIGN UP WITH EMAIL',(){
                            Get.to(()=> SignUpWithEmail());
                          }),
                          const SizedBox(height: 20),
                          customButton('CONTINUE WITH FACEBOOK',()async{
                            await controller.signInWithFacebook();
                          }),
                        ],),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>  LoginPage());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Already an account?',style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),),
                            const SizedBox(height: 5,),
                            Text('Login',style: whiteFontStyle(fontWeight: FontWeight.bold, fontSize: 12.0), ),
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
      },
    );
  }
}
