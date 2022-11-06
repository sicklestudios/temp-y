import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart';
import 'package:ystyle/FirebaseController/all_chats_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';
import '../ChatScreen/chat_screen.dart';

class Favourite_page extends StatefulWidget {
  const Favourite_page({
    Key? key,
  }) : super(key: key);

  @override
  State<Favourite_page> createState() => _Favourite_pageState();
}

class _Favourite_pageState extends State<Favourite_page>
    with TickerProviderStateMixin {
  ChatController chatController = Get.put(ChatController());
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    chatController.getChatContacts();
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message',
                  style: blackFontStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  'You have 2 new message',
                  style: greyFontStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
          SizedBoxHeight(10.0),
          Obx(() {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: chatController.contacts.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    child: ListTile(
                      onTap: () {
                        Get.to(() => ChatScreen(
                              receiverUid:
                                  chatController.contacts[index].contactId,
                            ));
                      },
                      leading: Stack(
                        children: [
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          FutureBuilder(
                              future: getUserProfileImage(
                                  chatController.contacts[index].contactId),
                              builder: (context, snapshot) {
                                return CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage:
                                      AssetImage('assets/images/favourite.jpg'),
                                );
                              }),
                        ],
                      ),
                      title: FutureBuilder(
                          future: getUserName(
                              chatController.contacts[index].contactId),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data.toString(),
                              style: blackFontStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0),
                            );
                          }),
                      subtitle: Text(
                        chatController.contacts[index].lastMessage,
                        style: greyFontStyle(fontSize: 12.0),
                      ),
                      trailing: Text(
                        format(chatController.contacts[index].timeSent),
                        style: greyFontStyle(fontSize: 12.0),
                      ),
                    ),
                  );
                });
          }),
        ],
      ),
    ));
  }
}
