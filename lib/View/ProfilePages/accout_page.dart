import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/View/ProfilePages/profile_details_page.dart';
import 'package:ystyle/View/setting_pages/favourite_design_page.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin{

  int? val = 1;
  int _initialIndex = 0;
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, animationDuration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 10.0,
                margin: EdgeInsets.zero,
                child: Container(
                  child: Container(
                    width: double.infinity,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                    'assets/images/background_image.jpg'),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '765',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Follower',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '765',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBoxHeight(5.0),
                          Text(
                            'Sara Tiler',
                            style: whiteFontStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'London, England',
                            style: whiteFontStyle(
                                fontSize: 12.0, ),
                          ),
                          SizedBoxHeight(5.0),
                          InkWell(
                            onTap: (){
                            Get.to(()=> ProfileDetailPage());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 6),
                                child: Text(
                                  'Profile',
                                  style: whiteFontStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600),
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
                height: MediaQuery.of(context).size.height * 0.78,
                child: DefaultTabController(
                  initialIndex: _initialIndex,
                  length: 2,
                  child: Scaffold(
                    backgroundColor: appColor,
                    appBar: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      indicatorColor: whiteColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 60.0),
                      tabs: [
                        Tab(text: "My Post"),
                        Tab(text: "Favourite Post"),
                      ],
                    ),
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                          Favourite_design_page(),
                          Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5.0,
                                  crossAxisSpacing: 5.0),
                              shrinkWrap: true,
                              itemCount: 15,
                              itemBuilder: (BuildContext ctx, index) {
                                return Container(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Image.asset(
                                          'assets/images/favourite.jpg',
                                          fit: BoxFit.cover,
                                        )));
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
            ],
          ),
        ));
  }
}
