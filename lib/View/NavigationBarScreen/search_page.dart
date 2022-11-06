import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/NavigationBarScreen/search_screen.dart';
import 'package:ystyle/View/ProfilePages/user_detail_page.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';
import 'package:ystyle/widgets/transparent_textfield.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    onTap: () {
                                      Get.to(() => SearchScreen());
                                    },
                                    readOnly: true,
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trends For You',
                          style: blackFontStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBoxWidth(10.0),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  // Get.to(() => User_detail_page());
                                },
                                horizontalTitleGap: 0.0,
                                leading: Text(
                                  '1.',
                                  style: blackFontStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                title: Text(
                                  'Sequans',
                                  style: blackFontStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  '1,945 posts',
                                  style: greyFontStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBoxHeight(15.0),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(right: 10),
              height: 100,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Style',
                      style: blackFontStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBoxHeight(10.0),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                        'assets/images/background_image.jpg'),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBoxHeight(15.0),
          ],
        ),
      ),
    );
  }
}
