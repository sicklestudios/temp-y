import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:ystyle/FirebaseController/authentication_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/NavigationBarScreen/nav_bar.dart';
import 'register_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  isUserLogin()async{
    await auth.authStateChanges().listen((event) {
      if(event == null){
        routeMethod();
      }else{
        Get.off(()=>NavBarPage());
      }
    });
  }

  VideoPlayerController _controller =  VideoPlayerController.asset('assets/testvideo.mp4')
    ..initialize().then((_) {});
  routeMethod()async{
    _controller.play();
    Future.delayed(Duration(seconds: 14),()async{
      await Get.offAll(() => RegisterPage());
    });

  }

  @override
  void initState() {
    super.initState();
    isUserLogin();
  }

  // @override
  // void dispose(){
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: _controller != null ?
        Container(
          height: Get.height,
          width: Get.width,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        )
        :Center(child: CircularProgressIndicator(
          color: primaryColor,
        ),),
      ),
    );
  }
}
