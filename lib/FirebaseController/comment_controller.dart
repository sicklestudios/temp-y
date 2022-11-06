import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ystyle/Models/all_posts_model.dart';

class CommentController extends GetxController {
  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([]);
  final Rx<List<CommentModel>> _commentsReplies = Rx<List<CommentModel>>([]);
  List<CommentModel> get comments => _comments.value;
  List<CommentModel> get commentsReplies => _commentsReplies.value;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _postId = "";
  updataPostId(String id) {
    _postId = id;
    getComment();
  }

//get all the comments on a specific post
  getComment() async {
    _comments.bindStream(_firebaseFirestore
        .collection('comments')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((event) {
      List<CommentModel> retVal = [];
      for (var elements in event.docs) {
        retVal.add(CommentModel.fromSnap(elements));
      }
      return retVal;
    }));
  }

  //get all the comments on a specific post
  getCommentReplies(commentId) {
    _commentsReplies.bindStream(_firebaseFirestore
        .collection('comments')
        .doc(_postId)
        .collection('comments')
        .doc(commentId)
        .collection("replies")
        .snapshots()
        .map((event) {
      List<CommentModel> retVal = [];
      for (var elements in event.docs) {
        retVal.add(CommentModel.fromSnap(elements));
      }
      return retVal;
    }));
  }

  //method to post the comment
  postComment(String text) async {
    try {
      if (text.isNotEmpty) {
        // DocumentSnapshot userDoc = await _firebaseFirestore
        //     .collection("users")
        //     .doc(_auth.currentUser!.uid)
        //     .get();
        var allDocs = await _firebaseFirestore
            .collection("comments")
            .doc(_postId)
            .collection("comments")
            .get();
        int len = allDocs.docs.length;

        final comment = CommentModel(
          // username: (userDoc.data()! as dynamic)['name'],
          comment: text,
          datePublished: DateTime.now(),
          likes: [],
          // profilePhoto: (userDoc.data()! as dynamic)['image'],
          uid: _auth.currentUser!.uid,
          id: "Comment $len",
        );

        await _firebaseFirestore
            .collection('comments')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());
        //updating the comment count
        await _firebaseFirestore.collection('comments').doc(_postId).get();
      }
    } catch (e) {
      Get.snackbar("Error Occurred", e.toString());
    }
  }

// liking the comments
  likeComment(String id) async {
    var ref = _firebaseFirestore
        .collection('comments')
        .doc(_postId)
        .collection('comments')
        .doc(id);
    DocumentSnapshot snapshot = await ref.get();
    var uid = _auth.currentUser!.uid;
    if ((snapshot.data()! as dynamic)['likes'].contains(uid)) {
      await ref.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await ref.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  //replying to the comments
  postCommentReply(String text, String commentId) async {
    try {
      if (text.isNotEmpty) {
        // DocumentSnapshot userDoc = await _firebaseFirestore
        //     .collection("users")
        //     .doc(_auth.currentUser!.uid)
        //     .get();
        var allDocs = await _firebaseFirestore
            .collection("comments")
            .doc(_postId)
            .collection("comments")
            .doc(commentId)
            .collection('replies')
            .get();
        int len = allDocs.docs.length;

        final comment = CommentModel(
          // username: (userDoc.data()! as dynamic)['name'],
          comment: text,
          datePublished: DateTime.now(),
          likes: [],
          // profilePhoto: (userDoc.data()! as dynamic)['image'],
          uid: _auth.currentUser!.uid,
          id: "Reply $len",
        );

        await _firebaseFirestore
            .collection("comments")
            .doc(_postId)
            .collection("comments")
            .doc(commentId)
            .collection('replies')
            .doc('Reply $len')
            .set(comment.toJson());
      }
    } catch (e) {
      Get.snackbar("Error Occurred", e.toString());
    }
  }

  // liking the comments replies
  likeCommentReply(replyId, commentId) async {
    var ref = _firebaseFirestore
        .collection('comments')
        .doc(_postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId);
    DocumentSnapshot snapshot = await ref.get();
    var uid = _auth.currentUser!.uid;
    if ((snapshot.data()! as dynamic)['likes'].contains(uid)) {
      await ref.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await ref.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
