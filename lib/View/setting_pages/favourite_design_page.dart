import 'package:flutter/material.dart';
import 'package:ystyle/Utils/constant.dart';

class Favourite_design_page extends StatefulWidget {
  const Favourite_design_page({
    Key? key,
  }) : super(key: key);

  @override
  State<Favourite_design_page> createState() => _Favourite_design_pageState();
}

class _Favourite_design_pageState extends State<Favourite_design_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SingleChildScrollView(
        child: Padding(
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
                return ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      'assets/images/model.jpg',
                      fit: BoxFit.cover,
                    ));
              }),
        ),
      ),
    );
  }
}
