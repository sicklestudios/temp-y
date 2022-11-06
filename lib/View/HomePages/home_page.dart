import 'dart:developer';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:ystyle/FirebaseController/home_page_controller.dart';
import 'package:ystyle/Models/all_posts_model.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/HomePages/post_comment_screen.dart';
import '../ProfilePages/user_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController _homePageController = Get.put(HomePageController());
  VideoPlayerController? _videoPlayerController;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LikesOnPost likesOnPost = LikesOnPost();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //getting the name of the user with uid
  Future<String> getUserName(uid) async {
    String user = "";
    await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = value.data()!['name'].toString()});

    return user;
  }

  //getting the images of the user with uid
  Future<String> getUserProfileImage(uid) async {
    String user = "";
    await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = value.data()!['image'].toString()});

    return user;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore
            .collection("allPosts")
            .orderBy("createdAt", descending: true)
            .get()
            .asStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something Went Wrong"),
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        _homePageController.getUserDetail(
                            snapshot.data.docs[index].data()["userId"]);
                        late final _cheiweController;
                        if (snapshot.data.docs[index].data()["isVideo"] ==
                            true) {
                          _cheiweController = ChewieController(
                            videoPlayerController:
                                VideoPlayerController.network(snapshot
                                    .data.docs[index]
                                    .data()["postUrl"]),
                            autoPlay: false,
                          );
                        }

                        return GetBuilder<HomePageController>(
                          init: HomePageController(),
                          builder: (controller) {
                            return GestureDetector(
                              onDoubleTap: () async {
                                await _homePageController.likePost(
                                  post_id: snapshot.data.docs[index]
                                      .data()["postId"],
                                );
                                setState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            FutureBuilder(
                                                future: getUserProfileImage(
                                                  snapshot.data.docs[index]
                                                      .data()["userId"],
                                                ),
                                                builder: (context, snapshot) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            backgroundImage:
                                                                AssetImage(
                                                              "assets/placeholder.jpg",
                                                            ))
                                                        : FadeInImage(
                                                            height: 45,
                                                            width: 45,
                                                            fit: BoxFit.cover,
                                                            placeholder: AssetImage(
                                                                "assets/images/logo.jpg"),
                                                            image: NetworkImage(
                                                                snapshot.data
                                                                    .toString()),
                                                          ),
                                                  );
                                                }),
                                            // controller.userDetailsModel.image !=
                                            //         null
                                            // ? ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             50),
                                            //     child: FadeInImage(
                                            //       height: 45,
                                            //       width: 45,
                                            //       fit: BoxFit.cover,
                                            //       placeholder: AssetImage(
                                            //           "assets/images/logo.jpg"),
                                            //       image: NetworkImage(
                                            //           controller
                                            //               .userDetailsModel
                                            //               .image
                                            //               .toString()),
                                            //     ),
                                            //   )
                                            //     : CircleAvatar(
                                            //         radius: 20,
                                            //         backgroundColor:
                                            //             Colors.grey,
                                            //         child: Image.asset(
                                            //           "assets/images/logo.jpg",
                                            //           height: 45,
                                            //           width: 45,
                                            //         ),
                                            //       ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder(
                                                  future: getUserName(
                                                    snapshot.data.docs[index]
                                                        .data()["userId"],
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Text(
                                                        "Loading",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      );
                                                    }
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        snapshot.data
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      );
                                                    } else {
                                                      return Text(
                                                        "Nothing to show",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      );
                                                    }
                                                  },
                                                ),
                                                // Text(
                                                //   controller
                                                //       .userDetailsModel.name
                                                //       .toString(),
                                                //   style: blackFontStyle(
                                                //       fontSize: 14.0,
                                                //       fontWeight:
                                                //           FontWeight.w500),
                                                // ),
                                                Container(
                                                  width: Get.width * 0.8,
                                                  child: Text(
                                                      snapshot.data.docs[index]
                                                                      .data()[
                                                                  "postMessage"] !=
                                                              ""
                                                          ? snapshot.data
                                                                  .docs[index]
                                                                  .data()[
                                                              "postMessage"]
                                                          : "No description",
                                                      style: blackFontStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    snapshot.data.docs[index]
                                                .data()['isVideo'] ==
                                            true
                                        ? VideoPlayerNetwork(snapshot
                                            .data.docs[index]
                                            .data()["postUrl"])
                                        : snapshot.data.docs[index]
                                                    .data()["isVideo"] ==
                                                false
                                            ? AspectRatio(
                                                aspectRatio: 1,
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: AssetImage(
                                                    'assets/placeholder.jpg',
                                                  ),
                                                  image: NetworkImage(
                                                    snapshot.data.docs[index]
                                                        .data()["postUrl"],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await _homePageController
                                                      .likePost(
                                                    post_id: snapshot
                                                        .data.docs[index]
                                                        .data()["postId"],
                                                  );
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  snapshot.data.docs[index]
                                                          .data()["likes"]
                                                          .contains(_auth
                                                              .currentUser!.uid
                                                              .toString())
                                                      ? Icons.favorite
                                                      : Icons
                                                          .favorite_border_outlined,
                                                  size: 24,
                                                  color: snapshot
                                                          .data.docs[index]
                                                          .data()["likes"]
                                                          .contains(_auth
                                                              .currentUser!.uid
                                                              .toString())
                                                      ? Colors.red
                                                      : blackColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      PostCommentScreen(
                                                        postId: snapshot
                                                            .data.docs[index]
                                                            .data()["postId"],
                                                      ));
                                                },
                                                child: Icon(
                                                  Icons.comment,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.share,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Icon(
                                            Icons.bookmark_outline,
                                            size: 25.0,
                                            color: greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      })
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}

// play video from network
class VideoPlayerNetwork extends StatefulWidget {
  final String url;

  VideoPlayerNetwork(this.url);

  @override
  _VideoPlayerNetworkState createState() => _VideoPlayerNetworkState();
}

class _VideoPlayerNetworkState extends State<VideoPlayerNetwork> {
  late ChewieController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = ChewieController(
      videoPlayerController:
          VideoPlayerController.network(widget.url.toString()),
      autoPlay: false,
      showControls: true,
      allowFullScreen: true,
      aspectRatio: 16 / 9,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.videoPlayerController.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.videoPlayerController.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: _controller!,
          ),
        ),
      ),
    );
  }
}
