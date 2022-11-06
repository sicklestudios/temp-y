import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/authentication_controller.dart';
import 'package:ystyle/FirebaseController/home_page_controller.dart';
import 'package:ystyle/FirebaseController/profile_data_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/HomePages/home_page.dart';
import 'package:ystyle/service/local_push_notification.dart';

import '../ProfilePages/accout_page.dart';
import 'create_post_page.dart';
import 'favourite_page.dart';
import 'search_page.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({Key? key}) : super(key: key);
  @override
  State<NavBarPage> createState() => _HomePageState();
}

class _HomePageState extends State<NavBarPage> {
  // initial controllers
  ProfileDataController profileDataController =
      Get.put(ProfileDataController());
  HomePageController homePageController = Get.put(HomePageController());

  int _pageIndex = 0;
  late PageController _pageController;
  List<Widget> tabPages = [
    HomePage(),
    SearchPage(),
    CreatePostPage(),
    Favourite_page(),
    ProfilePage(),
  ];

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    profileDataController.getProfileData();
    _pageController = PageController(initialPage: _pageIndex);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    storeNotificationToken();
  }
  //Notification related work

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('STYLE THREAD'),
        leading: IconButton(
            onPressed: () async {
              AuthenticationController().logOut();
            },
            icon: Icon(Icons.logout_outlined)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: blackColor,
              ))
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle:
            blackFontStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: whiteColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account")
        ],
        currentIndex: _pageIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
