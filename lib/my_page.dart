import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:madcamp_week3/home_page.dart';
import 'package:madcamp_week3/main_page.dart';
import 'package:madcamp_week3/model/memo_provider.dart';
import 'package:madcamp_week3/model/screen_provider.dart';
import 'package:madcamp_week3/model/user_provider.dart';
import 'package:madcamp_week3/object/home_moon.dart';
import 'package:madcamp_week3/object/moon.dart';
import 'package:madcamp_week3/widget/my_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin{
  late AnimationController _fadecontroller;
  late Animation<double> _fadeanimation;
  bool _isFadeClicked = false;

  @override
  void initState() {
    super.initState();


    _fadecontroller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      });
    _fadeanimation =
        Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(
          parent: _fadecontroller,
          curve: Curves.easeOut,
        ));

    final sp = Provider.of<ScreenProvider>(context, listen: false);
    sp.addListener(() {
      if(sp.myCardClicked){
        _fadecontroller.forward(from: 0.0);
      }
      else{
        _fadecontroller.reverse();
      }
    });



    final memos = Provider.of<MemoProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    memos.loadMyMemos(userProvider.token);

  }

  @override
  void dispose() {
    _fadecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreenProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final memoProvider = Provider.of<MemoProvider>(context);


    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 100,
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
            SizedBox(width: 15,),

            Container(
              width: 30,
              child: FloatingActionButton(
                heroTag: 'logout',
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));

                  userProvider.logout();
                  Navigator.pop(context);

                },
                child: Icon(Icons.logout_outlined, color: Colors.white, size: 20,),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                tooltip: 'LOGOUT',
                elevation: 0,
                focusElevation: 0.1,
                hoverElevation: 0.1,
                focusColor: Colors.white.withOpacity(0.6),
                hoverColor: Colors.white.withOpacity(0.2),
                splashColor: Colors.transparent,
              ),
            ),
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

          Moon(),


          Center(
            child: ClipRect(
              child: OverflowBox(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 3,
                    sigmaY: 3,
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


          Opacity(
            opacity: 1-(_fadeanimation.value/15),
            child: Container(
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
                    itemCount: memoProvider.my_memo_lst.length,
                    itemBuilder: (context, index){
                      return Column(
                        children: [
                          MyCard(text: memoProvider.my_memo_lst[index].content,
                            date:'${memoProvider.my_memo_lst[index].date.split('-')[0]}년 ${memoProvider.my_memo_lst[index].date.split('-')[1]}월 ${memoProvider.my_memo_lst[index].date.split('-')[2]}일',),
                          SizedBox(height: 20,),
                        ],
                      );
                    },
                  )


                ],
              )
            ),
          ),


          if (_fadecontroller.value > 0)
            GestureDetector(
              onTap: (){
                screenProvider.setMyCardNoClicked();
              },
              child: Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      color: Colors.black.withOpacity(_fadeanimation.value/45),
                    ),

                    Center(
                      child: ClipRect(
                        child: OverflowBox(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: _fadeanimation.value,
                              sigmaY: _fadeanimation.value,
                            ),
                            child: Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                        child: Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width*0.85,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(screenProvider.myCardText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(_fadeanimation.value/15), fontSize: 55, fontFamily: 'GowunBatang',
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(screenProvider.myCardDate,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(_fadeanimation.value/15), fontSize: 30, fontFamily: 'GowunBatang',
                                      ),
                                    ),
                                  ],
                                )
                            )
                        )
                    )
                  ]
              ),
            ),



        ],
      ),
    );
  }
}
