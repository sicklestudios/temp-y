import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/comment_controller.dart';
import 'package:ystyle/Models/all_posts_model.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCommentScreen extends StatefulWidget {
  PostCommentScreen({Key? key, required this.postId}) : super(key: key);
  @override
  State<PostCommentScreen> createState() => _PostCommentScreenState();
  String postId;
}

class _PostCommentScreenState extends State<PostCommentScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CommentController commentController = Get.put(CommentController());
  final TextEditingController _commentController = TextEditingController();

  bool isCommentReply = false;
  String commentId = "";

  @override
  void initState() {
    super.initState();
    //initalizing the comment controller with the desired post id
    commentController.updataPostId(widget.postId);
  }

  //getting the name of the user with uid
  Future<String> getUserName(uid) async {
    String user = "";
    await _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = value.data()!['name'].toString()});

    return user;
  }

  //getting the images of the user with uid
  Future<String> getUserProfileImage(uid) async {
    String user = "";
    await _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = value.data()!['image'].toString()});

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //to remove the focus from textfield on touching outside
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text(
                'Post Comment',
              ),
              elevation: 0,
              // automaticallyImplyLeading: false,
            ),
            body: Container(
              child: CommentBox(
                  sendWidget: Icon(
                    Icons.send_sharp,
                    size: 30,
                    color: whiteColor,
                  ),
                  textColor: whiteColor,
                  commentController: _commentController,
                  backgroundColor: primaryColor,
                  labelText: "Write a comment",
                  withBorder: false,
                  userImage:
                      "https://firebasestorage.googleapis.com/v0/b/ystyle-d0610.appspot.com/o/ProfilePictures%2F8l3PCMpmg1XEe13R2s2lr1zIafn1?alt=media&token=1cc2c707-7ad8-4f9b-b94d-1270997d4604",
                  sendButtonMethod: () {
                    isCommentReply
                        ? commentController.postCommentReply(
                            _commentController.text, commentId)
                        : commentController.postComment(
                            _commentController.text,
                          );
                    _commentController.text = "";
                    commentId = "";
                    isCommentReply = false;
                  },
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: commentController.comments.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final comment = commentController.comments[index];
                          commentController.getCommentReplies(comment.id);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CommentTreeWidget<CommentModel,
                                    CommentModel>(
                                CommentModel(
                                    comment: comment.comment,
                                    datePublished: comment.datePublished,
                                    likes: comment.likes,
                                    uid: comment.uid,
                                    id: comment.id),
                                commentController.commentsReplies,
                                treeThemeData: TreeThemeData(
                                    lineColor: Colors.white, lineWidth: 1),
                                avatarRoot: (context, comment) => PreferredSize(
                                      child: FutureBuilder(
                                          future:
                                              getUserProfileImage(comment.uid),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data.toString()),
                                              );
                                            } else {
                                              return CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/placeholder.jpg"));
                                            }
                                          }),
                                      preferredSize: Size.fromRadius(18),
                                    ),
                                avatarChild: (context, comment) =>
                                    PreferredSize(
                                      child: FutureBuilder(
                                          future:
                                              getUserProfileImage(comment.uid),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data.toString()),
                                              );
                                            } else {
                                              return CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/placeholder.jpg"));
                                            }
                                          }),
                                      preferredSize: Size.fromRadius(12),
                                    ),
                                contentChild: (context, comment) {
                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                          future: getUserName(comment.uid),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text(
                                                "Loading",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            }
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data.toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            } else {
                                              return Text(
                                                "Nothing to show",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          comment.comment,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(children: [
                                      Text(
                                        timeago.format(
                                            comment.datePublished.toDate()),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ]),
                                    // trailing: GestureDetector(
                                    //   onTap: () => commentController.likeCommentReply(comment.id,),
                                    //   child: Column(
                                    //     children: [
                                    //       Icon(

                                    //         comment.likes.contains(
                                    //                 _auth.currentUser!.uid)
                                    //             ? Icons.favorite
                                    //             : Icons.favorite_outline,
                                    //         color: comment.likes.contains(
                                    //                 _auth.currentUser!.uid)
                                    //             ? Colors.red
                                    //             : Colors.black,
                                    //       ),
                                    //       Text(
                                    //         comment.likes.length.toString(),
                                    //         style: const TextStyle(
                                    //             fontSize: 12,
                                    //             color: Colors.black),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  );
                                },
                                contentRoot: (context, comment) {
                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                          future: getUserName(comment.uid),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text(
                                                "Loading",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            }
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data.toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            } else {
                                              return Text(
                                                "Nothing to show",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          comment.comment,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(children: [
                                      Text(
                                        timeago.format(
                                            comment.datePublished.toDate()),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          commentId = comment.id;
                                          isCommentReply = true;
                                        },
                                        child: Text(
                                          "Reply",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {});
                                        },
                                        child: Text(
                                          "View",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      )
                                    ]),
                                    trailing: GestureDetector(
                                      onTap: () => commentController
                                          .likeComment(comment.id),
                                      child: Column(
                                        children: [
                                          Icon(
                                            comment.likes.contains(
                                                    _auth.currentUser!.uid)
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: comment.likes.contains(
                                                    _auth.currentUser!.uid)
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                          Text(
                                            comment.likes.length.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        });
                  })),
            )));
  }
}
