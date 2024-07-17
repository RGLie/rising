import 'dart:async';
import 'dart:math';
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

  late Timer _timer;
  Random _random = Random();
  String _text = "추억이";
  double _left = 0.0;
  double _top = 0.0;

  final List<String> _texts = [
    "추억이",
    "기억이",
    "행복이",
    "기쁨이",
    "그떄가",
    "그 시절이",
    "그리움이",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));


    _startTimer();


  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) { // 5초 주기로 텍스트 변경
      _startAnimationSequence();
    });
  }

  void _startAnimationSequence() {
    _controller.forward(from: 0.0).then((_) {
      Future.delayed(Duration(seconds: 1), () {
        _controller.reverse().then((_) {
          Future.delayed(Duration(seconds: 1), () {
            _changeTextAndPosition();
          });
        });
      });
    });
  }


  void _changeTextAndPosition() {
    setState(() {
      _text = _texts[_random.nextInt(_texts.length)];
      _left = _random.nextDouble() * (MediaQuery.of(context).size.width - 500);
      _top = _random.nextDouble() * 100; // 상단에서 100 픽셀 범위 내에서 랜덤 위치 설정
    });

    _controller.forward(from: 0.0).then((_) {
      Future.delayed(Duration(seconds: 1), () {
        _controller.reverse();
      });
    });
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

    if(_animation.value >= 10){
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));
    }


  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
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

            // AnimatedBuilder(
            //   animation: _animation,
            //   builder: (context, child) {
            //     return Positioned(
            //       left: _left,
            //       top: _top,
            //       child: Opacity(
            //         opacity: _animation.value/15,
            //         child: Text(
            //           _text,
            //           style: TextStyle(
            //               fontSize: 120,
            //               fontFamily: 'GowunBatang',
            //               color: Color(0xffdddddd)
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
        
            // Padding(
            //   padding: const EdgeInsets.only(left: 80.0, top: 50),
            //   child: DefaultTextStyle(
            //     style: const TextStyle(
            //       fontSize: 120,
            //       fontFamily: 'GowunBatang',
            //       color: Color(0xffdddddd)
            //     ),
            //     child: AnimatedTextKit(
            //       repeatForever: true,
            //       pause: Duration(seconds:  2),
            //       animatedTexts: [
            //         FadeAnimatedText('추억이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('기억이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('행복이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('기쁨이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('슬픔이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('사랑이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('그 시절이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('그리움이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('후회가', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('고마움이', duration: Duration(seconds: 3)),
            //         FadeAnimatedText('미안함이', duration: Duration(seconds: 3)),
            //       ],
            //       onTap: () {
            //       },
            //     ),
            //   ),
            // ),
        
            ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                maxWidth: double.maxFinite,
                child: Stack(
                  children: [
                    Text(
                      '떠오르다',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 320,
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
                        fontSize: 320,
                        height: 1.0
                      )
                    ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: OverflowBox(
                alignment: Alignment.bottomCenter,
                maxWidth: double.maxFinite,
                child: Transform.translate(
                  offset: Offset(0, -30),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'GowunBatang',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 7.0,
                          color: Colors.white,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        FlickerAnimatedText('시작하기 위해 화면을 길게 누르세요', speed: Duration(milliseconds: 2500)),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                  // child: Text('시작하기 위해 화면을 길게 누르세요',
                  //     style: TextStyle(
                  //         fontFamily: 'GowunBatang',
                  //         color: Colors.white,
                  //         fontSize: 20,
                  //         height: 1.0
                  //     )
                  // ),
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
