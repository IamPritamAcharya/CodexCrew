import 'package:codexcrew/screens/home/widgets/hero_buttons.dart';
import 'package:codexcrew/screens/home/widgets/hero_title.dart';
import 'package:flutter/material.dart';

class ModernHeroSection extends StatelessWidget {
  const ModernHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 768;

    return Container(
      height: screenHeight,
      width: screenWidth,
      color: Colors.transparent,
      child: Stack(
        children: [_buildMainContent(isDesktop), _buildBottomScrollIndicator()],
      ),
    );
  }

  Widget _buildMainContent(bool isDesktop) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isDesktop) SizedBox(height: 20),
            HeroTitle(isDesktop: isDesktop),
            SizedBox(height: isDesktop ? 40 : 32),

            HeroSubtitle(isDesktop: isDesktop),
            SizedBox(height: isDesktop ? 56 : 48),

            HeroActionButtons(isDesktop: isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomScrollIndicator() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Scroll to explore',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
