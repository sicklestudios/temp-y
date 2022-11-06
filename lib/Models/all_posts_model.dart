import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ystyle/Models/user_details_model.dart';

class AllPosts {
  String? userId;
  String? postId;
  String? postUrl;
  bool? isVideo;
  String? postMessage;
  Timestamp? createdAt;

  AllPosts(
      {this.userId,
      this.postId,
      this.postUrl,
      this.isVideo,
      this.postMessage,
      this.createdAt});

  factory AllPosts.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    return AllPosts(
      userId: documentSnapshot.get("userId"),
      postId: documentSnapshot.get("postId"),
      postUrl: documentSnapshot.get("postUrl"),
      isVideo: documentSnapshot.get("isVideo"),
      postMessage: documentSnapshot.get("postMessage"),
      createdAt: documentSnapshot.get("createdAt"),
    );
  }
}

class LikesOnPost {
  String? postId;
  List<dynamic>? likes = [];

  LikesOnPost({this.postId, this.likes});

  factory LikesOnPost.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    return LikesOnPost(
      postId: documentSnapshot.get("postId"),
      likes: documentSnapshot.get('likes'),
    );
  }
}

class CommentModel {
  // String username;
  String comment;
  final datePublished;
  List likes;
  // String profilePhoto;
  String uid;
  String id;

  CommentModel({
    // required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    // required this.profilePhoto,
    required this.uid,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        // 'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        // 'profilePhoto': profilePhoto,
        'uid': uid,
        'id': id,
      };

  factory CommentModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      // username: snapshot['username'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      // profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      id: snapshot['id'],
    );
  }
}
