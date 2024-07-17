import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/screen_provider.dart';

class MyCard extends StatelessWidget {
  final String text;
  final String date;

  const MyCard({super.key, required this.text, required this.date});

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreenProvider>(context);



    return Container(
      width: 400,
      child: Card(
        surfaceTintColor: Color(0xfff1ebff),
        color: Color(0xfff1ebff),
        // margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        elevation: 3, // 카드 하단 그림자 크기
        // shadowColor: Colors.black.withOpacity(0.7),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // splashColor: myColor.background,
          onTap: () {
            screenProvider.setMyCardClicked();
            screenProvider.setMyCardText(text);
            screenProvider.setMyCardDate(date);

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ScrumPage(
            //             index: index, tags: arrived_tags)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2),
            child: ListTile(

              title: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                date,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff555555)
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
