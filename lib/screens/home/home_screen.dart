import 'package:codexcrew/screens/home/widgets/faq.dart';
import 'package:codexcrew/screens/home/widgets/footer.dart';
import 'package:codexcrew/screens/home/widgets/imageList.dart';

import 'package:codexcrew/screens/home/widgets/our_journey.dart';
import 'package:flutter/material.dart';
import 'widgets/hero_section.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ModernHeroSection(),
          ImageList(),
          OurJourneyWidget(),

          FAQSection(),
          SimpleFooter(),
        ],
      ),
    );
  }
}
