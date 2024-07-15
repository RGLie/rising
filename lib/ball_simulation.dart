import 'dart:math';
import 'package:madcamp_week3/object/myball.dart';
import 'package:flutter/material.dart';

class BallSimulation extends StatefulWidget {
  @override
  _BallSimulationState createState() => _BallSimulationState();
}

class _BallSimulationState extends State<BallSimulation>
    with SingleTickerProviderStateMixin {
  bool isClick = false;
  bool isClickAfter = true;
  bool collapse = false;

  late AnimationController _animationController;
  double baseTime = 0.016;
  double accel = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1)
    );
    _animationController.repeat();
  }

  // @override
  // void dispose(){
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var ball = myBall.origin(screenWidth/2, screenHeight);
    var ball2 = myBall.origin(100+screenWidth/2, screenHeight);
    var ball3 = myBall.origin(200+screenWidth/2, screenHeight);
    var ball4 = myBall.origin(300+screenWidth/2, screenHeight);

    dynamic ball_lst = [ball, ball2, ball3, ball4];


    return Center(
        child: GestureDetector(
          onHorizontalDragDown: (details) {
            setState(() {
              if (ball.isBallRegion(details.localPosition.dx, details.localPosition.dy)) {
                isClick=true;
                // ball.stop();
              }
            });
          },
          onHorizontalDragEnd: (details) {
            if (isClick) {
              setState(() {
                isClick = false;
                isClickAfter = true;
              });
            }
          },
          onHorizontalDragUpdate: (details) {
            if (isClick) {
              setState(() {
                ball.setPosition(details.localPosition.dx, details.localPosition.dy);
                ball.updateDraw();
              });
            }
          },

          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Color(0xffebfaff),
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {

                  for(int i =0; i<ball_lst.length; i++){
                    if (!isClick) {
                      if (ball_lst[i].yVel!=0 || isClickAfter) {
                        // ball.addYvel(baseTime * accel);
                        ball_lst[i].subYpos( ball.yVel * baseTime);
                        ball_lst[i].updateAnimation(_animationController.value);
                        isClickAfter=false;
                        // if ((ball.yVel>0)&&(ball.yVel.abs()* _animationController.value*baseTime + ball.yPos + ball.ballRad >= (screenHeight-100))) {
                        //   ball.mulYvel(-0.7);
                        //   ball.outVel();
                        //
                        // }
                      }
                    }
                  }

                  return CustomPaint(
                    painter: _paint(balls : ball_lst, ballPath: ball.draw, opacity: ball.yPos/screenHeight, height: screenHeight),
                  );
                }
            ),
          ),
        )
    );
  }
}

class _paint extends CustomPainter {
  final balls;
  final Path ballPath;
  final double opacity;
  final double height;

  _paint({
    required this.balls,
    required this.ballPath,
    required this.opacity,
    required this.height
  });

  @override
  void paint(Canvas canvas, Size size) {



    for(int i = 0; i<balls.length; i++){
      Path path = Path();

      Paint paint = Paint()
        ..color = Color.fromRGBO(0, 0, 0, balls[i].yPos/height)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      path.addPath(balls[i].draw, Offset.zero);


      canvas.drawPath(path, paint);
    }



  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}


