import 'package:flutter/material.dart';

class FAQSection extends StatefulWidget {
  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection>
    with SingleTickerProviderStateMixin {
  final Map<String, String> faqData = {
    "How does Memzo's AI Photo Sharing feature help both the photographers and guests in an event?":
        "Memzo revolutionizes photo sharing for Events, providing a seamless experience for clients and guests alike. Through our innovative mobile app and web platform, powered by advanced AI Face Recognition technology, photographers can instantly and securely share photos. Guests can effortlessly view their photos by simply taking a selfie, setting a new benchmark for efficiency, engagement, and brand exposure.",
    "What subscription model does Memzo offer?":
        "Memzo offers flexible subscription plans tailored to different user needs. Our plans include basic, professional, and enterprise tiers with varying features and pricing to accommodate photographers of all scales.",
    "How do I create an account on Memzo?":
        "Creating an account on Memzo is simple! Visit our website or download our mobile app, click on 'Sign Up', fill in your details including name, email, and password, verify your email address, and you're ready to start using Memzo's features.",
    "I forgot my Memzo password/am unable to log in to my account. How can I reset it?":
        "If you've forgotten your password, click on 'Forgot Password' on the login page, enter your registered email address, check your email for a reset link, click the link and create a new password. If you're still having trouble, contact our support team for assistance.",
  };

  Set<String> expandedQuestions = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      constraints: BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'FAQs',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Got questions? We\'ve got answers!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white38),
          ),
          SizedBox(height: 30),
          ...faqData.entries.map((entry) {
            final question = entry.key;
            final answer = entry.value;
            final isExpanded = expandedQuestions.contains(question);

            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white38),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedQuestions.remove(question);
                        } else {
                          expandedQuestions.add(question);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              question,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xFF6366F1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints:
                          isExpanded
                              ? BoxConstraints()
                              : BoxConstraints(maxHeight: 0),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: isExpanded ? 1 : 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white54,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
