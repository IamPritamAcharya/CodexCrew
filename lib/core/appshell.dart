import 'package:codexcrew/core/background.dart';
import 'package:codexcrew/core/nav_config.dart';
import 'package:codexcrew/core/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).fullPath ?? '/';
    final currentItem = NavConfig.getByRoute(currentRoute);

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: Stack(
          children: [
            _buildAnimatedBackground(),

            _buildGridPattern(),

            _buildFloatingOrbs(),

            _buildNoiseOverlay(),

            child,

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FloatingNavBarWrapper(
                currentPage: currentItem.name,
                onNavigate: (pageName) {
                  final navItem = NavConfig.getByName(pageName);
                  context.go(navItem.route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF050505),
          Color(0xFF0A0A0A),
          Color(0xFF080808),
          Color(0xFF000000),
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(child: AnimatedBackground());
  }

  Widget _buildGridPattern() {
    return Positioned.fill(child: CustomPaint(painter: GridPatternPainter()));
  }

  Widget _buildFloatingOrbs() {
    return Stack(
      children: [
        Positioned(
          top: -150,
          right: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFF6366F1).withOpacity(0.08),
                  Color(0xFF8B5CF6).withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFF06B6D4).withOpacity(0.05),
                  Color(0xFF0891B2).withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 200,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFEC4899).withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoiseOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.01),
              Colors.transparent,
              Colors.white.withOpacity(0.005),
            ],
          ),
        ),
      ),
    );
  }
}
