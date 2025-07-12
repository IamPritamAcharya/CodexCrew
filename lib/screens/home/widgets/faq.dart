import 'package:flutter/material.dart';

class FAQSection extends StatefulWidget {
  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection>
    with SingleTickerProviderStateMixin {
  final Map<String, String> faqData = {
    "What does the Coding Club offer to students?":
        "The Coding Club provides a platform for students to explore programming, build real-world projects, participate in hackathons, and collaborate on open-source contributions. We host weekly coding sessions, workshops, and tech talks to help students enhance their technical skills and creativity.",
    "Do I need prior coding experience to join the club?":
        "Not at all! Our club welcomes students of all skill levels. Whether you're just starting out or already experienced, you'll find events and resources tailored to your level — plus a supportive community to help you grow.",
    "How can I become a member of the Coding Club?":
        "Joining is easy! Just attend one of our orientation sessions or sign up through our club portal. You'll need to provide basic details like your name, branch, and college email. Once registered, you’ll get access to all upcoming events, coding challenges, and project teams.",
    "I missed a workshop or event. Can I still access the content?":
        "Yes! We archive all of our sessions, workshops, and slides on our club’s internal platform or Google Drive. You can always revisit the material and even reach out to mentors if you have any questions.",
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
