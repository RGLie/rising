import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:madcamp_week3/constants/colors.dart';

class PhysicsDemo extends StatefulWidget {
  @override
  _PhysicsDemoState createState() => _PhysicsDemoState();
}

class _PhysicsDemoState extends State<PhysicsDemo> with SingleTickerProviderStateMixin {
  double height = 800;
  double width = 1400;

  double mouse_x = 0.0;
  double mouse_y = 0.0;


  bool mouse_clicked = false;
  double mouse_ix = 0;
  double mouse_iy = 0;
  double mouse_fx = 0;
  double mouse_fy = 0;

  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Ball> balls;

  @override
  void initState() {
    super.initState();
    balls = [
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.red),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.green),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.blue),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.yellow),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.red),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.green),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.blue),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.yellow),

      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.yellow),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.red),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.green),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.blue),
      Ball(x: makeRandomStartPosition(), y: height, vx: makeRandomVelocityX(), vy: makeRandomVelocityY(), ax:0, ay:0, radius: makeRandomRadius(), color: Colors.yellow),
      // Ball(x: makeRandomStartPosition(), y: height, vx: 2, vy: -1.5, ax:0, ay:0, radius: 35, color: Colors.green),
      // Ball(x: makeRandomStartPosition(), y: height, vx: -0.3, vy: -1.2, ax:0, ay:0, radius: 30, color: Colors.blue),
      // Ball(x: makeRandomStartPosition(), y: height, vx: -0.8, vy: -1.5, ax:0, ay:0, radius: 30, color: Colors.yellow),
    ];
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _updatePhysics();
      });
    });

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }


  void _updatePhysics() {

    setState(() {
      for (var ball in balls) {
        // ball.vy += ball.gravity;
        ball.vy += ball.ay;
        ball.vx += ball.ax;

        ball.x += ball.vx;
        ball.y += ball.vy;


        // x axis velocity가 0으로 수렴
        if(ball.vx.abs()>0.1){
          if(ball.vx > 0){
            ball.vx = pow(sqrt(ball.vx)-0.02, 2).toDouble();
          }
          else{
            ball.vx = -pow(sqrt(-ball.vx)-0.02, 2).toDouble();
          }

        }

        // 클릭시 사라짐
        if(ball.isClick){
          ball.opacity /= 1.18;
        }

        // 바운더리 체크 및 반사 처리
        if (ball.y > height) {
          ball.vy *= -1;
          // ball.y = height;
          // ball.vy *= ball.bounce;

        }
        else if(ball.y < 0){
          ball.y = height;
          ball.x = makeRandomStartPosition();
          ball.vx = makeRandomVelocityX();
          ball.vy = makeRandomVelocityY();
          ball.radius = makeRandomRadius();
          ball.isClick = false;
          ball.opacity = 1;
        }
        // if (ball.x > width || ball.x < 0) {
        //   ball.vx *= -1;
        // }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Center(
      child: MouseRegion(
        // cursor: SystemMouseCursors.copy,
        onHover: (details){
          double newpos_x = details.position.dx-((MediaQuery.of(context).size.width-width)/2);
          double newpos_y= details.position.dy-((MediaQuery.of(context).size.height-height)/2);

          for (var ball in balls) {
            var dist = getDistanceSquare(newpos_x, newpos_y, ball.x, ball.y);
            if(dist < pow(ball.radius, 2)*2){
              ball.isHover = true;
              if(newpos_x < ball.x){
                ball.vx += 0.1;
              }
              else{
                ball.vx -= 0.1;
              }
            }
            else{
              ball.isHover = false;
            }
            // else if(ball.vx.abs()>0.1){
            //   if(ball.vx > 0){
            //     ball.vx = pow(sqrt(ball.vx)-0.01, 2).toDouble();
            //   }
            //   else{
            //     ball.vx = -pow(sqrt(-ball.vx)-0.01, 2).toDouble();
            //   }
            //
            // }

          }
          // double ratio = (ball.y/mapSize[0])+0.2;
          // setState(() {
          //   mouse_x = details.position.dx;
          //   mouse_y = details.position.dy;
          // });
        },
        child: GestureDetector(
          onTap: (){
            for(var ball in balls){
              if(ball.isHover){
                ball.isClick = true;
                // _openAnimateDialog(context);
              }
            }
          },
          onHorizontalDragDown: (details) {
              // if (ball.isBallRegion(details.localPosition.dx, details.localPosition.dy)) {}
            setState(() {
              mouse_ix = details.localPosition.dx;
              mouse_iy = details.localPosition.dy;
              mouse_clicked = true;
            });

          },
          onHorizontalDragEnd: (details) {
            setState(() {
              mouse_clicked = false;
            });
            double a = mouse_fx - mouse_ix;
            for(var ball in balls){
              ball.vx += a > 0 ? -makeRandomVelocityY() : makeRandomVelocityY();
            }

          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              mouse_fx = details.localPosition.dx;
              mouse_fy = details.localPosition.dy;
            });

          },
          child: Container(
            width: width,
            height: height,
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BallPainter(balls, [height, width]),
                );
              },
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }


  num getDistanceSquare(double x, double y, double dx, double dy){
    return pow(x-dx, 2)+pow(y-dy, 2);
  }

  double makeRandomStartPosition(){
    return (width/2) -400 + Random().nextInt(800).toDouble();
  }

  double makeRandomRadius(){
    return  25+Random().nextInt(20).toDouble();
  }

  double makeRandomVelocityX(){
    return -2+Random().nextDouble()*4;
  }

  double makeRandomVelocityY(){
    return -0.5-Random().nextDouble()*1.2;
  }
}



class Ball {
  double x;
  double y;
  double vx;
  double vy;
  double ax;
  double ay;
  double radius;
  bool isHover = false;
  bool isClick = false;
  double opacity = 1;
  final double gravity = 0.1;
  final double bounce = -0.7;
  final Color color;

  Ball({required this.x, required this.y, required this.vx, required this.vy, required this.ax, required this.ay, required this.radius, required this.color});
}

class BallPainter extends CustomPainter {
  final List<Ball> balls;
  final List<double> mapSize;

  BallPainter(this.balls, this.mapSize);



  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      double ratio = (ball.y/mapSize[0])+0.01;
      ratio = (sqrt(ratio));

      if(ball.isHover){
        final paint2 = Paint()
          ..color = Color(0xffffa91f).withOpacity(ball.opacity)
          ..imageFilter = ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0, tileMode: TileMode.decal)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(ball.x, ball.y), ball.radius*ratio, paint2);
      }
      else{
        final paint2 = Paint()
          ..color = Color(0xffF8D74C).withOpacity(ball.opacity)
          ..imageFilter = ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0, tileMode: TileMode.decal)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(ball.x, ball.y), ball.radius*ratio, paint2);
      }



      final paint = Paint()
        ..color = Colors.white.withOpacity(ball.opacity)
        ..imageFilter = ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0, tileMode: TileMode.decal)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(ball.x, ball.y+(10*ratio)), ball.radius*0.6*ratio, paint);
      // canvas.drawRect(
      //   Rect.fromLTWH(0, 0, size.width, size.height),
      //   Paint()
      //     ..imageFilter = ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      // );
      // canvas.drawShadow(path.shift(Offset(0, -5)), Colors.black, 2.0, true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}