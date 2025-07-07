import 'package:codexcrew/temp.dart';
import 'package:codexcrew/screens/home/widgets/workshops.dart';
import 'package:flutter/material.dart';
import 'widgets/hero_section.dart';

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          ModernHeroSection(),
     
          WorkshopPage(),
          SectionPlaceholder(
            title: 'About Us',
            subtitle: 'Learn more about Codex Crew',
            backgroundColor: Color(0xFF0A0A0A),
          ),
          SectionPlaceholder(
            title: 'Our Projects',
            subtitle: 'Explore our latest work',
            backgroundColor: Color(0xFF111111),
          ),
          SectionPlaceholder(
            title: 'Team',
            subtitle: 'Meet the creative minds',
            backgroundColor: Color(0xFF0A0A0A),
          ),
          SectionPlaceholder(
            title: 'Contact',
            subtitle: 'Get in touch with us',
            backgroundColor: Color(0xFF111111),
          ),
        ],
      ),
    );
  }
}
