import 'dart:developer';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:ystyle/FirebaseController/home_page_controller.dart';
import 'package:ystyle/FirebaseController/profile_data_controller.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/custom_buttton.dart';

class CreatePostPage extends StatelessWidget {
  final TextEditingController postDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: GetBuilder<HomePageController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(Get.find<ProfileDataController>().imgUrl.toString()),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Get.find<ProfileDataController>().nameController.text.toString(),
                            style: blackFontStyle(fontSize: 12.0),
                          ),
                          Text(
                            "Write a new post",
                            style: greyFontStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: height * 0.2,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: postDescriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "What do you want talk about?",
                          hintStyle: greyFontStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  controller.downLoadProgress != null ?
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: controller.downLoadProgress!.toDouble() / 100.0,
                        minHeight: 5.0,
                        color: primaryColor,
                        backgroundColor: Colors.grey,
                      ),
                      Text(controller.downLoadProgress!.toStringAsFixed(2)+"%",style: blackFontStyle(fontSize: 12.0),),
                    ],
                  ): SizedBox(),
                  // button for file picker and camera
                  controller.fileFromGallery == null
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ImagePickerDialog(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Add Photo",
                                    style: blackFontStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                videoPickerDialog(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.video_call,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Add video",
                                    style: blackFontStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            controller.isVideo(controller.fileFromGallery!.path.toString())
                                ? ListTile(
                                    title: Text(
                                      basename(controller.fileFromGallery!.path.toString()),
                                      style: blackFontStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      "Video file is selected",
                                      style: blackFontStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  )
                                : Container(
                                    height: height * 0.4,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Image.file(
                                      controller.fileFromGallery!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: customMaterialButton(text: 'Post', ontap: () async{
                            if(postDescriptionController.text != "" ||  postDescriptionController.text.isNotEmpty || controller.fileFromGallery != null){
                              if(controller.fileFromGallery != null){
                                await controller.createPost(postDescription: postDescriptionController.text.toString());
                              }else{
                                await controller.createPostWithoutMedia(postDescription: postDescriptionController.text.toString());
                              }
                            }else{
                              Get.snackbar("Error", "Please write something");
                            }
                            postDescriptionController.clear();
                          }, color: primaryColor),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: customMaterialButton(
                              text: 'Cancel',
                              ontap: () {
                                controller.removeImage();
                              },
                              color: greyColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void ImagePickerDialog(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
              title: Text('Select Image', style: customFontStyle(Color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w500)),
              message: const Text('Choose from where you want to select image'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(
                    'Camera',
                    style: customFontStyle(Color: blackColor, fontSize: 12.0),
                  ),
                  onPressed: () async {
                    await Get.find<HomePageController>().pickImageFromCamera();
                    Get.back();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    'Gallery',
                    style: customFontStyle(Color: blackColor, fontSize: 12.0),
                  ),
                  onPressed: () async {
                    await Get.find<HomePageController>().pickImageFromGallery();
                    Get.back();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  'Cancel',
                  style: customFontStyle(Color: blackColor, fontSize: 12.0),
                ),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ));
  }

  void videoPickerDialog(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
              title: Text('Select Video', style: customFontStyle(Color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w500)),
              message: const Text('Choose from where you want to select video'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(
                    'Camera',
                    style: customFontStyle(Color: blackColor, fontSize: 12.0),
                  ),
                  onPressed: () {
                    Get.find<HomePageController>().pickVideoFromCamera();
                    Get.back();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    'Gallery',
                    style: customFontStyle(Color: blackColor, fontSize: 12.0),
                  ),
                  onPressed: () {
                    Get.find<HomePageController>().pickVideoFromGallery();
                    Get.back();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  'Cancel',
                  style: customFontStyle(Color: blackColor, fontSize: 12.0),
                ),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ));
  }
}
