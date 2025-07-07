import 'package:flutter/material.dart';

class ModernHeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 768;

    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: _buildBackgroundDecoration(),
      child: Stack(
        children: [
      
          _buildBackgroundOrb(),
  
          _buildMainContent(isDesktop),
      
          _buildBottomScrollIndicator(),
        ],
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topLeft,
        radius: 1.5,
        colors: [Color(0xFF0F0F0F), Color(0xFF000000)],
      ),
    );
  }

  Widget _buildBackgroundOrb() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0xFF6366F1).withOpacity(0.1), Colors.transparent],
          ),
        ),
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

class HeroActionButtons extends StatelessWidget {
  final bool isDesktop;

  const HeroActionButtons({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ModernButton(
          text: 'Get Started',
          isPrimary: true,
          isDesktop: isDesktop,
          onTap: () {

          },
        ),
        SizedBox(width: isDesktop ? 16 : 0, height: isDesktop ? 0 : 16),
        ModernButton(
          text: 'Learn More',
          isPrimary: false,
          isDesktop: isDesktop,
          onTap: () {

          },
        ),
      ],
    );
  }
}

class ModernButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final bool isDesktop;
  final VoidCallback onTap;

  const ModernButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isDesktop ? null : double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 50 : 24,
          vertical: isDesktop ? 16 : 18,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient:
              isPrimary
                  ? LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                  : null,
          border:
              isPrimary
                  ? null
                  : Border.all(color: Colors.white.withOpacity(0.2)),
          color: isPrimary ? null : Colors.white.withOpacity(0.05),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
