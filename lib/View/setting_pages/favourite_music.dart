import 'package:flutter/material.dart';
import 'package:ystyle/Utils/constant.dart';
import 'package:ystyle/widgets/custom_sizedBox.dart';

class Favourite_music_page extends StatelessWidget {
  const Favourite_music_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 15,
                          itemBuilder: (context, index){
                            return ListTile(
                              horizontalTitleGap: 0.0,
                              trailing: Text('05.40',style: greyFontStyle(fontSize: 14.0, fontWeight: FontWeight.w300),),
                              title: Text('A Castle Full Of Recal', style: blackFontStyle(fontSize: 14.0, fontWeight: FontWeight.w600),),
                              subtitle: Text('Deep Purple',style: greyFontStyle(fontSize: 12.0, fontWeight: FontWeight.w600),),
                            );
                          })
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
