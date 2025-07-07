
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
      body: Stack(
        children: [
          // Current page content
          child,
          // Floating Navigation Bar
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
    );
  }
}