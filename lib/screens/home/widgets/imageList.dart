import 'package:flutter/material.dart';
import 'dart:ui';

class ImageList extends StatelessWidget {
  const ImageList({super.key});

  static const List<Map<String, String>> clientsData = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=400&h=300&fit=crop',
      'title': 'Hackathons',
      'subtitle':
          'Power your coding events with real-time\nAI-powered media tools.',
      'description':
          'Make your hackathons unforgettable with our intelligent photo management platform. Automatically capture, organize, and tag moments during the event, enabling seamless sharing on social media. Use live feeds and branded albums to highlight creativity, teamwork, and innovation. Perfect for showcasing talent, building community, and engaging sponsors and attendees in real time.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=400&h=300&fit=crop',
      'title': 'Tech Talks & Seminars',
      'subtitle':
          'Automate content capture for your tech\nsessions and workshops.',
      'description':
          'Effortlessly document your tech talks and coding seminars with AI-assisted photo organization and sharing. Whether it\'s a guest speaker session or hands-on workshop, our platform helps you preserve key moments, create branded event albums, and share content with your community instantly. Engage attendees, promote your club, and build a digital legacy for every session.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=400&h=300&fit=crop',
      'title': 'Coding Bootcamps',
      'subtitle': 'Track learning journeys with smart\nevent photo curation.',
      'description':
          'Document your coding bootcamps and training sessions with ease. Our AI-based platform organizes photos by activity, session, and participant, helping clubs showcase progress and enthusiasm. Share curated stories on social media, build project timelines, and create recap albums to highlight growth, collaboration, and success stories across the club.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=400&h=300&fit=crop',
      'title': 'Club Showcases & Demos',
      'subtitle': 'Boost visibility with live sharing,\ninteractive galleries.',
      'description':
          'Elevate your demo days and club showcases with instant photo sharing, interactive displays, and branded galleries. Capture innovation in action and let your members shine. Perfect for project expos, app demos, and inter-club events, our platform ensures that your club’s achievements are professionally documented and widely celebrated.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 100 : 20,
        vertical: isWeb ? 100 : 40,
      ),
      child: Column(
        children: [
          Text(
            'Club Activities',
            style: TextStyle(
              fontSize: isWeb ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isWeb ? 16 : 12),

          Text(
            'Fueling innovation, collaboration, and creativity — where code meets community in every campus event.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWeb ? 16 : 14,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
          SizedBox(height: isWeb ? 50 : 30),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                return Row(
                  children:
                      clientsData
                          .map(
                            (client) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: _buildCard(context, client, true),
                              ),
                            ),
                          )
                          .toList(),
                );
              } else if (constraints.maxWidth > 800) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildCard(context, clientsData[0], true),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildCard(context, clientsData[1], true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildCard(context, clientsData[2], true),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildCard(context, clientsData[3], true),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children:
                      clientsData
                          .map(
                            (client) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildCard(context, client, false),
                            ),
                          )
                          .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Map<String, String> clientData,
    bool isWeb,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: isWeb ? 200 : 180,
                    width: double.infinity,
                    child: Image.network(
                      clientData['imageUrl']!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        Color fallbackColor;
                        if (clientData['title'] == 'Photographers') {
                          fallbackColor = Colors.green.shade700;
                        } else if (clientData['title'] == 'Corporate Events') {
                          fallbackColor = Colors.orange.shade600;
                        } else if (clientData['title'] ==
                            'School and Colleges') {
                          fallbackColor = Colors.blue.shade600;
                        } else {
                          fallbackColor = Colors.purple.shade700;
                        }

                        return Container(
                          color: fallbackColor,
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(isWeb ? 24 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientData['title']!,
                        style: TextStyle(
                          fontSize: isWeb ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isWeb ? 12 : 10),
                      Text(
                        clientData['subtitle']!,
                        style: TextStyle(
                          fontSize: isWeb ? 14 : 13,
                          color: Colors.grey[300],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: isWeb ? 20 : 16),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _showBottomSheet(context, clientData),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWeb ? 20 : 16,
                              vertical: isWeb ? 12 : 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Read More',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isWeb ? 14 : 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: isWeb ? 8 : 6),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: isWeb ? 16 : 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Map<String, String> clientData) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * (isWeb ? 0.8 : 0.85),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isWeb ? 24 : 20),
                topRight: Radius.circular(isWeb ? 24 : 20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 24 : 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          clientData['title']!,
                          style: TextStyle(
                            fontSize: isWeb ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isWeb ? 24 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: isWeb ? 250 : 200,
                            width: double.infinity,
                            child: Image.network(
                              clientData['imageUrl']!,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[800],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                Color fallbackColor;
                                if (clientData['title'] == 'Photographers') {
                                  fallbackColor = Colors.green.shade700;
                                } else if (clientData['title'] ==
                                    'Corporate Events') {
                                  fallbackColor = Colors.orange.shade600;
                                } else if (clientData['title'] ==
                                    'School and Colleges') {
                                  fallbackColor = Colors.blue.shade600;
                                } else {
                                  fallbackColor = Colors.purple.shade700;
                                }

                                return Container(
                                  color: fallbackColor,
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: isWeb ? 24 : 20),

                        Text(
                          clientData['subtitle']!,
                          style: TextStyle(
                            fontSize: isWeb ? 18 : 16,
                            color: Colors.grey[300],
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: isWeb ? 24 : 20),

                        Text(
                          clientData['description']!,
                          style: TextStyle(
                            fontSize: isWeb ? 16 : 15,
                            color: Colors.grey[200],
                            height: 1.7,
                          ),
                        ),

                        SizedBox(height: isWeb ? 40 : 30),

                        isWeb
                            ? Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    'Contact Us',
                                    true,
                                    () => Navigator.pop(context),
                                    isWeb,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildActionButton(
                                    'Learn More',
                                    false,
                                    () => Navigator.pop(context),
                                    isWeb,
                                  ),
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                _buildActionButton(
                                  'Contact Us',
                                  true,
                                  () => Navigator.pop(context),
                                  isWeb,
                                ),
                                const SizedBox(height: 12),
                                _buildActionButton(
                                  'Learn More',
                                  false,
                                  () => Navigator.pop(context),
                                  isWeb,
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildActionButton(
    String text,
    bool isPrimary,
    VoidCallback onPressed,
    bool isWeb,
  ) {
    return SizedBox(
      width: isWeb ? null : double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.white : Colors.transparent,
          foregroundColor: isPrimary ? Colors.black : Colors.white,
          side:
              isPrimary
                  ? null
                  : const BorderSide(color: Colors.white, width: 1.5),
          padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: isPrimary ? 8 : 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isWeb ? 16 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
