import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:ystyle/Models/chat_model.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/service/local_push_notification.dart';

class ChatController extends GetxController {
  final Rx<List<ChatContact>> _contacts = Rx<List<ChatContact>>([]);
  final Rx<List<Message>> _message = Rx<List<Message>>([]);
  List<ChatContact> get contacts => _contacts.value;
  List<Message> get message => _message.value;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  getChatContacts() {
    _contacts.bindStream(firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        // var userData = await firestore
        //     .collection('users')
        //     .doc(chatContact.contactId)
        //     .get();
        // var user =
        //     UserDetailsModel.fromDocumentSnapshot(documentSnapshot: userData);

        contacts.add(
          ChatContact(
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    }));
  }

  getChatStream(String recieverUserId) {
    _message.bindStream(firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    }));
  }

  void _saveDataToContactsSubcollection(
    String senderUserId,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
// users -> reciever user id => chats -> current user id -> set data
    var recieverChatContact = ChatContact(
      contactId: senderUserId,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );
    // users -> current user id  => chats -> reciever user id -> set data
    var senderChatContact = ChatContact(
      contactId: recieverUserId,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required String senderUsername,
    required String? recieverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
    );

    // users -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    // users -> reciever id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(recieverUserId).get();
    //receivers token for sending notification to the user
    String token = documentSnapshot.get('token');
    sendNotification(recieverUserId, token, text);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserDetailsModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserDetailsModel? recieverUserData;

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser.uid!,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        username: senderUser.name!,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUser.name!,
      );
    } catch (e) {
      Get.snackbar("Error Occurred", e.toString());
    }
  }

//   void sendFileMessage({
//     required BuildContext context,
//     required File file,
//     required String recieverUserId,
//     required UserModel senderUserData,
//     required ProviderRef ref,
//     required MessageEnum messageEnum,
//     required MessageReply? messageReply,
//     required bool isGroupChat,
//   }) async {
//     try {
//       var timeSent = DateTime.now();
//       var messageId = const Uuid().v1();

//       String imageUrl = await ref
//           .read(commonFirebaseStorageRepositoryProvider)
//           .storeFileToFirebase(
//             'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
//             file,
//           );

//       UserModel? recieverUserData;
//       if (!isGroupChat) {
//         var userDataMap =
//             await firestore.collection('users').doc(recieverUserId).get();
//         recieverUserData = UserModel.fromMap(userDataMap.data()!);
//       }

//       String contactMsg;

//       switch (messageEnum) {
//         case MessageEnum.image:
//           contactMsg = '📷 Photo';
//           break;
//         case MessageEnum.video:
//           contactMsg = '📸 Video';
//           break;
//         case MessageEnum.audio:
//           contactMsg = '🎵 Audio';
//           break;
//         case MessageEnum.gif:
//           contactMsg = 'GIF';
//           break;
//         default:
//           contactMsg = 'GIF';
//       }
//       _saveDataToContactsSubcollection(
//         senderUserData,
//         recieverUserData,
//         contactMsg,
//         timeSent,
//         recieverUserId,
//         isGroupChat,
//       );

//       _saveMessageToMessageSubcollection(
//         recieverUserId: recieverUserId,
//         text: imageUrl,
//         timeSent: timeSent,
//         messageId: messageId,
//         username: senderUserData.name,
//         messageType: messageEnum,
//         messageReply: messageReply,
//         recieverUserName: recieverUserData?.name,
//         senderUsername: senderUserData.name,
//         isGroupChat: isGroupChat,
//       );
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   void sendGIFMessage({
//     required BuildContext context,
//     required String gifUrl,
//     required String recieverUserId,
//     required UserModel senderUser,
//     required MessageReply? messageReply,
//     required bool isGroupChat,
//   }) async {
//     try {
//       var timeSent = DateTime.now();
//       UserModel? recieverUserData;

//       if (!isGroupChat) {
//         var userDataMap =
//             await firestore.collection('users').doc(recieverUserId).get();
//         recieverUserData = UserModel.fromMap(userDataMap.data()!);
//       }

//       var messageId = const Uuid().v1();

//       _saveDataToContactsSubcollection(
//         senderUser,
//         recieverUserData,
//         'GIF',
//         timeSent,
//         recieverUserId,
//         isGroupChat,
//       );

//       _saveMessageToMessageSubcollection(
//         recieverUserId: recieverUserId,
//         text: gifUrl,
//         timeSent: timeSent,
//         messageType: MessageEnum.gif,
//         messageId: messageId,
//         username: senderUser.name,
//         messageReply: messageReply,
//         recieverUserName: recieverUserData?.name,
//         senderUsername: senderUser.name,
//         isGroupChat: isGroupChat,
//       );
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   void setChatMessageSeen(
//     BuildContext context,
//     String recieverUserId,
//     String messageId,
//   ) async {
//     try {
//       await firestore
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('chats')
//           .doc(recieverUserId)
//           .collection('messages')
//           .doc(messageId)
//           .update({'isSeen': true});

//       await firestore
//           .collection('users')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(auth.currentUser!.uid)
//           .collection('messages')
//           .doc(messageId)
//           .update({'isSeen': true});
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
  // }
}
