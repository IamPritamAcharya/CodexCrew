
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: AnimatedPatternPainter(_animation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.015)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;

    const double spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final accentPaint =
        Paint()
          ..color = Color(0xFF6366F1).withOpacity(0.05)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width; i += spacing * 4) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedPatternPainter extends CustomPainter {
  final double animationValue;

  AnimatedPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x =
          (size.width * 0.1 + (i * 47) % size.width) +
          math.sin(animationValue + i * 0.1) * 20;
      final y =
          (size.height * 0.1 + (i * 73) % size.height) +
          math.cos(animationValue + i * 0.15) * 15;

      final opacity = (math.sin(animationValue + i * 0.2) + 1) * 0.02;
      paint.color = Color(0xFF6366F1).withOpacity(opacity);

      canvas.drawCircle(
        Offset(x, y),
        1.5 + math.sin(animationValue + i * 0.3) * 0.5,
        paint,
      );
    }

    final wavePaint =
        Paint()
          ..color = Color(0xFF8B5CF6).withOpacity(0.05)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    final path = Path();
    final waveHeight = 30.0;
   
    final waveLength = 400.0; 

    for (int wave = 0; wave < 3; wave++) {
      final yOffset = size.height * 0.2 + wave * size.height * 0.3;
      path.reset();
      path.moveTo(0, yOffset);

      for (double x = 0; x <= size.width; x += 5) {
        final y =
            yOffset +
            math.sin((x / waveLength) * 2 * math.pi + animationValue + wave) *
                waveHeight;
        path.lineTo(x, y);
      }

      wavePaint.color = Color(0xFF6366F1 + wave * 0x001100).withOpacity(0.025);
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
