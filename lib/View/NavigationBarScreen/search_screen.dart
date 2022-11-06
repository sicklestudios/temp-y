import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/Models/user_details_model.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/ProfilePages/user_detail_page.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with WidgetsBindingObserver {
  List<UserDetailsModel> usersList = [];
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void onSearch(searchText) async {
    setState(() {
      isLoading = true;
    });
    log(searchText);
    await _firestore
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: searchText)
        .limit(10)
        .get()
        .then((value) {
      usersList.clear();
      for (var elements in value.docs) {
        usersList.add(
            UserDetailsModel.fromDocumentSnapshot(documentSnapshot: elements));
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Search Users"),
          elevation: 0,
        ),
        body: Column(
          children: [
            Card(
              elevation: 10.0,
              margin: EdgeInsets.zero,
              child: Container(
                child: Container(
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
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                                'assets/images/background_image.jpg'),
                          ),
                        ),
                        SizedBoxWidth(10.0),
                        Expanded(
                          flex: 8,
                          child: Container(
                            height: 40,
                            child: TextFormField(
                              controller: _search,
                              onChanged: (value) => onSearch(value),
                              cursorColor: primaryColor,
                              style: TextStyle(color: primaryColor),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 24,
                                  color: primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: whiteColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: whiteColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: whiteColor,
                                  ),
                                ),
                                hintStyle: customFontStyle(
                                  Color: primaryColor,
                                  fontSize: 12.0,
                                ),
                                fillColor: whiteColor,
                                filled: true,
                                hintText: "Search",
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading
                ? Center(
                    child: Container(
                      height: size.height / 20,
                      width: size.height / 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : usersList.isEmpty
                    ? Container()
                    : ListView.builder(
                        itemCount: usersList.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => User_detail_page(
                                    userModel: usersList[index],
                                  ));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(usersList[index].image!)),
                              title: Text(
                                usersList[index].name!,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          );
                        }))
          ],
        ));
  }
}
