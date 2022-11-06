import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/Models/all_posts_model.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/ChatScreen/chat_screen.dart';
import 'package:ystyle/View/setting_pages/favourite_design_page.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';

class User_detail_page extends StatefulWidget {
  final UserDetailsModel userModel;
  const User_detail_page({Key? key, required this.userModel}) : super(key: key);

  @override
  State<User_detail_page> createState() => _User_detail_pageState();
}

class _User_detail_pageState extends State<User_detail_page>
    with TickerProviderStateMixin {
  int? val = 1;
  int _initialIndex = 0;
  TabController? _tabController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String followText = "Follow";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, animationDuration: Duration(milliseconds: 300), vsync: this);
  }

  followUser() async {
    var doc = await firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('following')
        .doc(widget.userModel.uid)
        .get();

    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(widget.userModel.uid)
          .collection('followers')
          .doc(_auth.currentUser!.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('following')
          .doc(widget.userModel.uid)
          .set({});
      setState(() {
        followText = "Following";
      });
    } else {
      await firestore
          .collection('users')
          .doc(widget.userModel.uid)
          .collection('followers')
          .doc(_auth.currentUser!.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('following')
          .doc(widget.userModel.uid)
          .delete();
      setState(() {
        followText = "Follow";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.userModel.name ?? "Nothing to Show"),
          backgroundColor: appColor,
        ),
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 10.0,
                margin: EdgeInsets.zero,
                child: Container(
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: (widget.userModel.image != null
                                    ? NetworkImage(widget.userModel.image!)
                                    : AssetImage(
                                        'assets/images/background_image.jpg'))
                                as ImageProvider,
                          ),
                          SizedBoxWidth(30.0),
                          Column(
                            children: [
                              Text(
                                '1,706 Posts',
                                style: blackFontStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBoxHeight(10.0),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      followUser();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            primaryColor,
                                            secondaryColor,
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 0.0),
                                          end: const FractionalOffset(1.0, 0.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      child: Center(
                                          child: Text(
                                        followText,
                                        style: whiteFontStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      )),
                                    ),
                                  ),
                                  SizedBoxWidth(5.0),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
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
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: whiteColor,
                                    )),
                                  ),
                                ],
                              ),
                              SizedBoxHeight(10.0),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ChatScreen(
                                        receiverUid: widget.userModel.uid!,
                                      ));
                                },
                                child: Container(
                                  height: 30,
                                  width: 140,
                                  decoration: BoxDecoration(
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
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Message",
                                    style: whiteFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  )),
                                ),
                              ),
                              Text(
                                'See a few top post each works',
                                style: greyFontStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBoxHeight(10.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: DefaultTabController(
                  initialIndex: _initialIndex,
                  length: 2,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: blackColor,
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: greyColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 80.0),
                      tabs: [
                        Tab(
                          text: "Top",
                        ),
                        Tab(text: "Recent"),
                      ],
                    ),
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        Favourite_design_page(),
                        Favourite_design_page(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
