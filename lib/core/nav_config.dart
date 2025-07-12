import 'package:codexcrew/screens/admin/admin_page.dart';
import 'package:codexcrew/screens/gallery/bento_grid.dart';
import 'package:codexcrew/screens/hallOfFame/hall_of_fame.dart';
import 'package:codexcrew/screens/home/home_screen.dart';
import 'package:codexcrew/screens/leaderboards/leaderboards.dart';
import 'package:flutter/material.dart';

class NavItem {
  final String name;
  final String route;
  final Widget page;
  final IconData icon;

  const NavItem({
    required this.name,
    required this.route,
    required this.page,
    required this.icon,
  });
}

class NavConfig {
  static List<NavItem> items = [
    NavItem(
      name: 'Home',
      route: '/',
      page: HomePageContent(),
      icon: Icons.home,
    ),
    NavItem(
      name: 'Leaderboards',
      route: '/leaderboards',
      page: LeaderboardPage(),
      icon: Icons.leaderboard,
    ),
    NavItem(
      name: 'Admin',
      route: '/admin',
      page: AdminPage(),
      icon: Icons.code,
    ),
    NavItem(
      name: 'Alumni',
      route: '/alumni',
      page: HallOfFamePage(),
      icon: Icons.group,
    ),
    NavItem(
      name: 'Gallery',
      route: '/gallery',
      page: BentoGrid(),
      icon: Icons.contact_mail,
    ),

  ];

  static NavItem getByRoute(String route) {
    return items.firstWhere((item) => item.route == route);
  }

  static NavItem getByName(String name) {
    return items.firstWhere((item) => item.name == name);
  }
}
