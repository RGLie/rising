import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Moon extends StatefulWidget {
  @override
  _MoonState createState() => _MoonState();
}

class _MoonState extends State<Moon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final int numberOfStars = 100;
  final List<Star> stars = [];
  final Random random = Random();
  double shootingStarPosition = -1.0;
  Offset shootingStarStart = Offset.zero;
  Offset shootingStarEnd = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 90),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _generateStars();
    _scheduleShootingStar();
  }

  void _generateStars() {
    for (int i = 0; i < numberOfStars; i++) {
      stars.add(Star(
        position: Offset(random.nextDouble(), random.nextDouble()),
        size: random.nextDouble() * 2 + 1,
      ));
    }
  }

  void _scheduleShootingStar() {
    Future.delayed(Duration(seconds: random.nextInt(3) + 1), () {
      setState(() {
        shootingStarPosition = 0.0;
        shootingStarStart = Offset(random.nextDouble(), random.nextDouble() * 0.5);
        shootingStarEnd = Offset(random.nextDouble(), random.nextDouble() * 0.5 + 0.5);
      });
      _animateShootingStar();
    });
  }

  void _animateShootingStar() {
    const shootingStarDuration = Duration(milliseconds: 500);
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        shootingStarPosition += 0.04;
        if (shootingStarPosition >= 1.0) {
          shootingStarPosition = -1.0;
          timer.cancel();
          _scheduleShootingStar();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, snapshot) {
          return CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: MoonPainter(_animation.value, stars, shootingStarPosition, shootingStarStart, shootingStarEnd),
          );
        },
      ),
    );
  }
}

class MoonPainter extends CustomPainter {
  final double animationValue;
  final List<Star> stars;
  final double shootingStarPosition;
  final Offset shootingStarStart;
  final Offset shootingStarEnd;
  final Paint starPaint = Paint()..color = Colors.white;

  MoonPainter(this.animationValue, this.stars, this.shootingStarPosition, this.shootingStarStart, this.shootingStarEnd);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height + 330;
    final radius = 50.0;
    final orbitRadius = size.width / 1.4;

    if (shootingStarPosition >= 0.0) {
      final shootingStarCurrentPosition = Offset.lerp(
        Offset(shootingStarStart.dx * size.width, shootingStarStart.dy * size.height),
        Offset(shootingStarEnd.dx * size.width, shootingStarEnd.dy * size.height),
        shootingStarPosition,
      );

      if (shootingStarCurrentPosition != null) {
        final shootingStarPath = Path()
          ..moveTo(shootingStarStart.dx * size.width, shootingStarStart.dy * size.height)
          ..lineTo(shootingStarCurrentPosition.dx, shootingStarCurrentPosition.dy);

        canvas.drawPath(
          shootingStarPath,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke,
        );
      }
    }

    final angle = (0.595 + (animationValue * (0.9 - 0.595))) * 2 * pi;
    final moonCenter = Offset(
      centerX + orbitRadius * cos(angle),
      centerY + orbitRadius * sin(angle),
    );

    final gradient = ui.Gradient.linear(
      Offset(moonCenter.dx, moonCenter.dy - radius),
      Offset(moonCenter.dx, moonCenter.dy + radius),
      [
        Color(0xffEEEDF6),
        Color(0xff9A8ACC),
      ],
    );

    for (final star in stars) {
      canvas.drawCircle(
        Offset(star.position.dx * size.width, star.position.dy * size.height),
        star.size,
        starPaint,
      );
    }

    final Paint paint = Paint()
      ..shader = gradient
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(15));

    final Paint paint2 = Paint()..shader = gradient;

    canvas.drawCircle(moonCenter, radius + 3, paint);
    canvas.drawCircle(moonCenter, radius, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}

class Star {
  final Offset position;
  final double size;

  Star({required this.position, required this.size});
}
