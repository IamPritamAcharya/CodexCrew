import 'package:flutter/material.dart';
import 'dart:ui';

class ImageList extends StatelessWidget {
  const ImageList({Key? key}) : super(key: key);

  static const List<Map<String, String>> clientsData = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1554048612-b6a482b224d1?w=400&h=300&fit=crop',
      'title': 'Photographers',
      'subtitle': 'Elevate your photography business with\nKamero.',
      'description':
          'Transform your photography workflow with our AI-powered platform. Kamero helps photographers streamline their business operations, from client management to photo delivery. Our intelligent system automatically organizes, tags, and enhances your photos, allowing you to focus on what you do best - capturing beautiful moments. With seamless integration and automated workflows, you can deliver exceptional experiences to your clients while growing your business efficiently.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=400&h=300&fit=crop',
      'title': 'Corporate Events',
      'subtitle':
          'Transform your business events with real-\ntime AI photo sharing.',
      'description':
          'Revolutionize your corporate events with instant AI-powered photo sharing and management. Our platform enables real-time photo distribution, automatic face recognition for attendee tagging, and seamless social media integration. Create memorable corporate experiences with features like live photo walls, instant printing stations, and branded photo albums. Perfect for conferences, team building events, product launches, and company celebrations.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=400&h=300&fit=crop',
      'title': 'School and Colleges',
      'subtitle':
          'Simplify photo management, create\ncollaborative yearbooks with AI.',
      'description':
          'Streamline educational photo management with our comprehensive AI solution. Create collaborative yearbooks, manage school events, and organize student photos effortlessly. Our platform offers secure photo sharing with parents, automated class photo organization, and easy yearbook creation tools. Teachers and administrators can efficiently manage photo permissions, create memorable school albums, and maintain organized digital archives of school memories.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=400&h=300&fit=crop',
      'title': 'Live Events & Concerts',
      'subtitle':
          'Amplify your event with seamless social\nsharing, personalized hashtags.',
      'description':
          'Enhance live events and concerts with dynamic photo sharing and social media amplification. Our platform provides real-time photo streaming, custom hashtag campaigns, and instant social media integration. Create immersive experiences with live photo feeds, fan engagement tools, and personalized photo memories. Perfect for music festivals, concerts, sporting events, and entertainment venues looking to maximize audience engagement and social media reach.',
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
            'Clients We Cater',
            style: TextStyle(
              fontSize: isWeb ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isWeb ? 16 : 12),

          Text(
            'Memso empowers photographers, event organizers, and institutions to share their stories through\na seamless AI-powered platform.',
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
                  child: Container(
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
                          child: Container(
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
