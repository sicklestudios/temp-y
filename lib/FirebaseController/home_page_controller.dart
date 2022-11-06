import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';
import 'package:ystyle/Models/all_posts_model.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/Utils/constant.dart';

class HomePageController extends GetxController {
  UserDetailsModel userDetailsModel = UserDetailsModel();
  late VideoPlayerController videoPlayerController;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  File? fileFromGallery;

  /// this is for video
  UploadTask? uploadTask;
  double? downLoadProgress;
  String? downloadUrl;
  // List likes = List.empty(growable: true);
  DocumentSnapshot? likes;

  /// create post method for image and video

  Future<void> createPost({String? postDescription}) async {
    final ref = await storage
        .ref("Posts")
        .child(auth.currentUser!.uid)
        .child(basename(fileFromGallery!.path));
    uploadTask = ref.putFile(fileFromGallery!);

    uploadTask!.snapshotEvents.listen((event) {
      downLoadProgress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble() * 100;
      update();
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    downloadUrl = await snapshot.ref.getDownloadURL();

    // is video or image
    bool isImageOrVideo = isVideo(fileFromGallery!.path);

    // send data to firestore
    DocumentReference postData = await firestore.collection("allPosts").doc();
    postData.set({
      "postId": postData.id,
      'isVideo': isImageOrVideo,
      "postUrl": downloadUrl,
      "postMessage": postDescription,
      "userId": auth.currentUser!.uid,
      "likes": [],
      "createdAt": DateTime.now(),
    });

    Get.snackbar(
      "Success",
      "Post uploaded Successfully",
      backgroundColor: primaryColor,
      colorText: Colors.white,
    );
    downLoadProgress = null;
    downloadUrl = null;
    fileFromGallery = null;
    update();
  }

  /// create post without media file
  Future<void> createPostWithoutMedia({String? postDescription}) async {
    // send data to firestore
    DocumentReference postData = await firestore.collection("allPosts").doc();
    postData.set({
      "postId": postData.id,
      'isVideo': null,
      "postUrl": "",
      "postMessage": postDescription,
      "userId": auth.currentUser!.uid,
      "likes": [],
      "createdAt": DateTime.now(),
    });


    Get.snackbar(
      "Success",
      "Post uploaded Successfully",
      backgroundColor: primaryColor,
      colorText: Colors.white,
    );
    downLoadProgress = null;
    downloadUrl = null;
    fileFromGallery = null;
    update();
  }

  /// create image picker method
  pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      fileFromGallery = File(pickedFile.path);
      update();
    }
  }

  /// create image picker method from camera
  pickImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      fileFromGallery = File(pickedFile.path);
      update();
    }
  }

  /// create video picker method from camera
  pickVideoFromCamera() async {
    final pickedFile = await ImagePicker().getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 10));
    if (pickedFile != null) {
      fileFromGallery = File(pickedFile.path);
      update();
    }
  }

  /// create video picker method from gallery
  pickVideoFromGallery() async {
    final pickedFile = await ImagePicker().getVideo(
        source: ImageSource.gallery, maxDuration: Duration(seconds: 10));
    if (pickedFile != null) {
      fileFromGallery = File(pickedFile.path);
      videoPlayerController =
          await VideoPlayerController.file(File(fileFromGallery!.path))
            ..initialize().then((_) {
              videoPlayerController.pause(); // pause video
              update();
            });
      update();
    }
  }

  /// remove image and video after selection
  void removeImage() {
    fileFromGallery = null;
    update();
  }

  /// check file format is video or image
  bool isVideo(fileUrl) {
    if (fileUrl!.endsWith('.mp4') ||
        fileUrl.endsWith('.mov') ||
        fileUrl.endsWith('.3gp') ||
        fileUrl.endsWith('.avi') ||
        fileUrl.endsWith('.flv') ||
        fileUrl.endsWith('.wmv') ||
        fileUrl.endsWith('.mkv') ||
        fileUrl.endsWith('.webm') ||
        fileUrl.endsWith('.mpeg') ||
        fileUrl.endsWith('.mpg') ||
        fileUrl.endsWith('.m4v')) {
      return true;
    } else {
      return false;
    }
  }

  /// like post and store in firestore
  likePost({required String post_id}) async {
    DocumentReference _docRef = await firestore.collection('allPosts').doc(post_id);
    DocumentSnapshot _docSnap = await _docRef.get();
    List<dynamic>? _myLikeOnPost = _docSnap.get('likes');
    log("Post: like_count => " + _myLikeOnPost!.length.toString());

    if (_myLikeOnPost!.contains(auth.currentUser!.uid)) {
      _docRef.update({
        "likes": FieldValue.arrayRemove([auth.currentUser!.uid])
      });
    } else {
      _docRef.update({
        "likes": FieldValue.arrayUnion([auth.currentUser!.uid])
      });
    }
    update();
  }

  // get user details and store in model
  getUserDetail(uid) async {
    DocumentSnapshot userDetails =
    await firestore.collection("users").doc(uid).get();
    // log("Post: user => "+ userDetails.data().toString());
    userDetailsModel =
        UserDetailsModel.fromDocumentSnapshot(documentSnapshot: userDetails);
    update();
  }
}
