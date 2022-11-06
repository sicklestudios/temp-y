import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/authentication_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/backfround_image_widget.dart';
import 'package:ystyle/widgets/custom_buttton.dart';
import 'package:ystyle/widgets/transparent_textfield.dart';

class Forgot_password extends StatelessWidget {
  const Forgot_password({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<AuthenticationController>(
        init: AuthenticationController(),
        builder: (controller) {
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
                        SizedBox(
                          height: 10,
                        ),
                        Text('Forgot your password?',
                            style: whiteFontStyle(fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.center),
                        Text('Reset it with your email',
                            style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 14.0), textAlign: TextAlign.center),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EMAIL',
                              style: whiteFontStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                            ),
                            transParentTextField(
                              controller: controller.emailController,
                            ),
                            const SizedBox(height: 30),
                            controller.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ))
                                : customButton('SEND', () async {
                                    await controller.forgetPassword();
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
