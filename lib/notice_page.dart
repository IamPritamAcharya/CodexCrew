import 'package:codexcrew/screens/resources/markdown_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class NoticeItem {
  final String name;
  final String downloadUrl;
  final String displayName;
  final String title;
  final DateTime date;

  NoticeItem({
    required this.name,
    required this.downloadUrl,
    required this.displayName,
    required this.title,
    required this.date,
  });

  factory NoticeItem.fromJson(Map<String, dynamic> json) {
    String name = json['name'] ?? '';
    return NoticeItem(
      name: name,
      downloadUrl: json['download_url'] ?? '',
      displayName: name
          .replaceAll('.md', '')
          .replaceAll('_', ' ')
          .replaceAll('-', ' '),
      title: '',
      date: DateTime.now(),
    );
  }

  NoticeItem copyWith({String? title, DateTime? date}) {
    return NoticeItem(
      name: name,
      downloadUrl: downloadUrl,
      displayName: displayName,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }
}

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<NoticeItem> notices = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.github.com/repos/IamPritamAcharya/codexcrewResources/contents?ref=notices',
        ),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> files = json.decode(response.body);

        List<NoticeItem> tempNotices =
            files
                .where((file) => file['name'].toString().endsWith('.md'))
                .map((file) => NoticeItem.fromJson(file))
                .toList();

        // Fetch metadata for each markdown file
        List<NoticeItem> enrichedNotices = [];
        for (NoticeItem notice in tempNotices) {
          try {
            final contentResponse = await http.get(
              Uri.parse(notice.downloadUrl),
            );
            if (contentResponse.statusCode == 200) {
              final content = contentResponse.body;
              final metadata = _parseMarkdownMetadata(content);
              enrichedNotices.add(
                notice.copyWith(
                  title: metadata['title'] ?? notice.displayName,
                  date: metadata['date'] ?? DateTime.now(),
                ),
              );
            } else {
              enrichedNotices.add(notice);
            }
          } catch (e) {
            enrichedNotices.add(notice);
          }
        }

        // Sort by date (newest first)
        enrichedNotices.sort((a, b) => b.date.compareTo(a.date));

        setState(() {
          notices = enrichedNotices;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load notices: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading notices: $e';
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> _parseMarkdownMetadata(String content) {
    final lines = content.split('\n');
    String? title;
    DateTime? date;
    int metadataEndIndex = 0;

    // Check if content starts with frontmatter (---)
    if (lines.isNotEmpty && lines[0].trim() == '---') {
      // Find the end of frontmatter
      for (int i = 1; i < lines.length; i++) {
        if (lines[i].trim() == '---') {
          metadataEndIndex = i + 1;
          break;
        }

        final line = lines[i].trim();
        if (line.toLowerCase().startsWith('title:')) {
          final titleValue = line.substring(6).trim();
          title = titleValue.replaceAll('"', '').replaceAll("'", "");
          if (title.isEmpty) title = null;
        } else if (line.toLowerCase().startsWith('date:')) {
          final dateStr = line
              .substring(5)
              .trim()
              .replaceAll('"', '')
              .replaceAll("'", "");
          if (dateStr.isNotEmpty) {
            try {
              date = DateTime.parse(dateStr);
            } catch (e) {
              // Try different date formats
              try {
                if (dateStr.contains('/')) {
                  final parts = dateStr.split('/');
                  if (parts.length == 3) {
                    date = DateTime(
                      int.parse(parts[2]),
                      int.parse(parts[1]),
                      int.parse(parts[0]),
                    );
                  }
                } else if (dateStr.contains('-')) {
                  final parts = dateStr.split('-');
                  if (parts.length == 3) {
                    date = DateTime(
                      int.parse(parts[0]),
                      int.parse(parts[1]),
                      int.parse(parts[2]),
                    );
                  }
                }
              } catch (e) {
                // If all parsing fails, use current date
                date = DateTime.now();
              }
            }
          }
        }
      }
    }

    return {
      'title': title,
      'date': date ?? DateTime.now(), // Always return a valid date
      'contentStartIndex': metadataEndIndex,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 120.0, bottom: 0.0),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFADD8E6)),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'ProductSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  error = null;
                });
                fetchNotices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFADD8E6),
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (notices.isEmpty) {
      return const Center(
        child: Text(
          'No notices found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'ProductSans',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notices.length,
      itemBuilder: (context, index) {
        final notice = notices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D3D3D), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => NoticeDetailPage(
                          title:
                              notice.title.isNotEmpty
                                  ? notice.title
                                  : notice.displayName,
                          markdownUrl: notice.downloadUrl,
                        ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFADD8E6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFADD8E6).withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        color: Color(0xFFADD8E6),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notice.title.isNotEmpty
                                ? notice.title
                                : notice.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'ProductSans',
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(notice.date),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'ProductSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    try {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
}

class NoticeDetailPage extends StatefulWidget {
  final String title;
  final String markdownUrl;

  const NoticeDetailPage({
    Key? key,
    required this.title,
    required this.markdownUrl,
  }) : super(key: key);

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  String markdownContent = '';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMarkdownContent();
  }

  Future<void> fetchMarkdownContent() async {
    try {
      final response = await http.get(Uri.parse(widget.markdownUrl));

      if (response.statusCode == 200) {
        String content = response.body;

        // Remove frontmatter before displaying
        final lines = content.split('\n');
        if (lines.isNotEmpty && lines[0].trim() == '---') {
          int endIndex = 0;
          for (int i = 1; i < lines.length; i++) {
            if (lines[i].trim() == '---') {
              endIndex = i + 1;
              break;
            }
          }
          if (endIndex > 0) {
            content = lines.sublist(endIndex).join('\n').trim();
          }
        }

        setState(() {
          markdownContent = content;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load content: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading content: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.only(top: 120.0, bottom: 0.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFADD8E6)),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'ProductSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  error = null;
                });
                fetchMarkdownContent();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFADD8E6),
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: MarkdownBody(
        data: markdownContent,
        styleSheet: MarkdownStyles.darkTheme,
        selectable: true,
        onTapLink: (text, href, title) {
          if (href != null) {
            _launchUrl(href);
          }
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: ${e.toString()}'),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    }
  }
}
