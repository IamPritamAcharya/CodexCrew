
import 'package:flutter/material.dart';

class HeroTitle extends StatelessWidget {
  final bool isDesktop;

  const HeroTitle({Key? key, required this.isDesktop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (bounds) => LinearGradient(
            colors: [Colors.white, Color(0xFF6366F1)],
          ).createShader(bounds),
      child: Text(
        'CODEX\nCREW',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isDesktop ? 180 : 96,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 0.85,
          letterSpacing: -4,
        ),
      ),
    );
  }
}



class HeroSubtitle extends StatelessWidget {
  final bool isDesktop;

  const HeroSubtitle({Key? key, required this.isDesktop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Text(
        'Where Code Meets Creativity',
        style: TextStyle(
          fontSize: isDesktop ? 24 : 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.9),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}