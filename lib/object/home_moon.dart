import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HomeMoon extends StatefulWidget {
  @override
  _HomeMoonState createState() => _HomeMoonState();
}

class _HomeMoonState extends State<HomeMoon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final int numberOfStars = 100;
  final List<Star> stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _generateStars();
  }

  void _generateStars() {
    final random = Random();
    for (int i = 0; i < numberOfStars; i++) {
      stars.add(Star(
        position: Offset(random.nextDouble(), random.nextDouble()),
        size: random.nextDouble() * 2 + 1, // Star size between 1 and 3
      ));
    }
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
            painter: MoonPainter(_animation.value, stars),
          );
        },
      ),
    );
  }
}

class MoonPainter extends CustomPainter {
  final double animationValue;
  final List<Star> stars;
  final Paint starPaint = Paint()..color = Colors.white;

  MoonPainter(this.animationValue, this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = 500 + size.width / 2;
    final centerY = size.height + 500; // Positioning the center lower in the screen
    final radius = 50.0; // Radius of the moon
    final orbitRadius = size.width / 1.2; // Radius of the orbit

    final angle = (0.56 + (animationValue * (0.8 - 0.56))) * 2 * pi; // Full circle
    final moonCenter = Offset(
      centerX + orbitRadius * cos(angle),
      centerY + orbitRadius * sin(angle),
    );

    final gradient = ui.Gradient.linear(
      Offset(moonCenter.dx, moonCenter.dy - radius),
      Offset(moonCenter.dx, moonCenter.dy + radius),
      [
        Color(0xffEEEDF6),
        Color(0xff9A8ACC)
      ],
    );

    // Draw the stars
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
