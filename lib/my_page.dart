import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:madcamp_week3/home_page.dart';
import 'package:madcamp_week3/main_page.dart';
import 'package:madcamp_week3/object/home_moon.dart';
import 'package:madcamp_week3/widget/my_card.dart';
import 'package:page_transition/page_transition.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 50,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 0.5,
            color: Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5,),
            Container(
              width: 30,
              child: FloatingActionButton(
                heroTag: 'back',
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));

                },
                child: Icon(Icons.undo_outlined, color: Colors.white, size: 20,),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                tooltip: 'BACK',
                elevation: 0,
                focusElevation: 0.1,
                hoverElevation: 0.1,
                focusColor: Colors.white.withOpacity(0.6),
                hoverColor: Colors.white.withOpacity(0.2),
                splashColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 5,),
          ],
        ),
      ),
      body: Stack(
        children: [

          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xffD58BD6),
                  Color(0xff805EC5),
                  Color(0xff313181),
                ],
              ),
            ),
          ),

          HomeMoon(),
          Center(
            child: ClipRect(
              child: OverflowBox(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.black.withOpacity(0.3),
          ),

          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Text('떠오르다',
                    style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'GowunBatang',)
                ),

                SizedBox(height: 30,),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        MyCard(),
                        SizedBox(height: 20,),
                      ],
                    );
                  },
                )


              ],
            )
          )



        ],
      ),
    );
  }
}
