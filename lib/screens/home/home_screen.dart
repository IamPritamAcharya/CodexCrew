import 'package:codexcrew/screens/home/widgets/faq.dart';
import 'package:codexcrew/screens/home/widgets/footer.dart';
import 'package:codexcrew/screens/home/widgets/imageList.dart';

import 'package:codexcrew/screens/home/widgets/our_journey.dart';
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
          ImageList(),
          OurJourneyWidget(),
          WorkshopPage(),

          FAQSection(),
          SimpleFooter(),
        ],
      ),
    );
  }
}
