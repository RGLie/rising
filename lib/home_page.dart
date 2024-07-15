import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madcamp_week3/main_page.dart';
import 'package:madcamp_week3/object/home_moon.dart';
import 'package:madcamp_week3/object/moon.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _onLongPress() {

    setState(() {
      _isPressed = true;
      _controller.forward(from: 0.0);
    });


  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isPressed = false;
      _controller.stop();
    });

    if(_animation.value >= 13){
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));
    }


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: _onLongPress,
        onLongPressEnd: _onLongPressEnd,
        onTap: (){

          Fluttertoast.showToast(
              msg: "시작하기 위해 길게 누르세요",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              webPosition: "center",
              // backgroundColor: Colors.white,
              webBgColor: "linear-gradient(to right, #D58BD6, #805EC5, #805EC5)",
              textColor: Colors.white,
              fontSize: 16.0
          );

        },
        child: Stack(
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
        
            Padding(
              padding: const EdgeInsets.only(left: 80.0, top: 50),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 120,
                  fontFamily: 'GowunBatang',
                  color: Color(0xffdddddd)
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: Duration(seconds:  2),
                  animatedTexts: [
                    FadeAnimatedText('추억이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('기억이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('행복이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('기쁨이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('슬픔이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('사랑이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('그 시절이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('그리움이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('후회가', duration: Duration(seconds: 3)),
                    FadeAnimatedText('고마움이', duration: Duration(seconds: 3)),
                    FadeAnimatedText('미안함이', duration: Duration(seconds: 3)),
                  ],
                  onTap: () {
                  },
                ),
              ),
            ),
        
            ClipRect(
              child: OverflowBox(
                alignment: Alignment.bottomLeft,
                maxWidth: double.maxFinite,
                child: Transform.translate(
                  offset: Offset(140, 0),
                  child: Stack(
                    children: [
                      Text(
                        '떠오르다',
                        style: TextStyle(
                          fontSize: 550,
                          height: 1.0,
                          fontFamily: 'GowunBatang',
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 20.0,
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 30.0,
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      // 원래 텍스트
                      Text('떠오르다',
                        style: TextStyle(
                          fontFamily: 'GowunBatang',
                          color: Colors.white,
                          fontSize: 550,
                          height: 1.0
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_isPressed)
              Center(
                child: ClipRect(
                  child: OverflowBox(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _animation.value,
                        sigmaY: _animation.value,
                      ),
                      child: Container(
                        width: _animation.value * 200,
                        height: _animation.value * 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        
          ],
        ),
      ),
    );
  }
}
