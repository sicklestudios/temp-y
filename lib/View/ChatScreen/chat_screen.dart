import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/FirebaseController/all_chats_controller.dart';
import 'package:ystyle/FirebaseController/comment_controller.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';
import 'package:ystyle/widgets/my_message_card.dart';
import 'package:ystyle/widgets/senders_message_card.dart';

//chat screen
class ChatScreen extends StatefulWidget {
  final String receiverUid;
  const ChatScreen({Key? key, required this.receiverUid}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController = Get.put(ChatController());
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _chatController = TextEditingController();
  UserDetailsModel? currentUserModel;
  @override
  void initState() {
    super.initState();
    getUserData();
    chatController.getChatStream(widget.receiverUid);
  }

  getUserData() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
              currentUserModel =
                  UserDetailsModel.fromDocumentSnapshot(documentSnapshot: value)
            });
    setState(() {});
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: greyColor,
              size: 16,
            ),
          ),
          backgroundColor: Colors.grey.shade100,
          elevation: 0.0,
          title: Row(
            children: [
              Stack(
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
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/images/favourite.jpg'),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: getUserName(widget.receiverUid),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data.toString(),
                          style: blackFontStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        );
                      }),
                  // Text('Online', style: greyFontStyle(fontSize: 12.0),),
                ],
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Obx(() {
              return ListView.builder(
                  itemCount: chatController.message.length,
                  itemBuilder: (context, index) {
                    var message = chatController.message;
                    if (message[index].senderId == _auth.currentUser!.uid) {
                      //its me
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MyMessageCard(
                              message: message[index].text, image: ""),
                        ],
                      );
                    }
                    //other user
                    return SenderMessageCard(
                        message: message[index].text, image: "");
                  });
            }),
            // textFormField
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 60.0,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: greyColor,
                      size: 25,
                    ),
                    SizedBoxWidth(10.0),
                    Icon(
                      Icons.face,
                      color: greyColor,
                      size: 25,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: _chatController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: greyFontStyle(fontSize: 12.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_chatController.text != "")
                          chatController.sendTextMessage(
                              context: context,
                              text: _chatController.text,
                              recieverUserId: widget.receiverUid,
                              senderUser: currentUserModel!);
                        _chatController.text = "";
                      },
                      icon: Icon(
                        Icons.send,
                        color: secondaryColor,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
