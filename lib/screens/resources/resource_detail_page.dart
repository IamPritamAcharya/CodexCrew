import 'package:codexcrew/screens/resources/markdown_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'resource_model.dart';

class ResourceDetailPage extends StatefulWidget {
  final Resource resource;

  const ResourceDetailPage({super.key, required this.resource});

  @override
  State<ResourceDetailPage> createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scrollController.addListener(_onScroll);

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1200;
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  double _getMaxWidth(BuildContext context) {
    if (_isDesktop(context)) return 1000;
    if (_isTablet(context)) return 800;
    return double.infinity;
  }

  double _getHorizontalPadding(BuildContext context) {
    if (_isDesktop(context)) return 48;
    if (_isTablet(context)) return 32;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Parallax Hero Section
          SliverToBoxAdapter(child: _buildParallaxHero(context)),

          // Content Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildContentSection(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxHero(BuildContext context) {
    final isMobile = _isMobile(context);
    // Clamp the parallax offset to prevent negative values or excessive translation
    final parallaxOffset = (_scrollOffset * 0.5).clamp(0.0, 100.0);
    final heroHeight = isMobile ? 300.0 : 400.0;

    return Container(
      height: heroHeight,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Parallax Background with bounds checking
          Transform.translate(
            offset: Offset(0, -parallaxOffset),
            child: Container(
              height: heroHeight + 100, // Ensure this is always positive
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F0F23),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Opacity(
                    opacity: 0.15,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1557804506-669a67965ba0?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Animated gradient overlay with proper opacity clamping
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(
                            (0.3 + (_scrollOffset / 1000)).clamp(0.0, 1.0),
                          ),
                          Colors.black.withOpacity(
                            (0.8 + (_scrollOffset / 2000)).clamp(0.0, 1.0),
                          ),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ... rest of your content
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: _getMaxWidth(context)),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(context) - 16,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main content with padding to avoid overlap with close button
              Container(
                padding: EdgeInsets.only(
                  left: _getHorizontalPadding(context),
                  right: _getHorizontalPadding(context),
                  top:
                      _getHorizontalPadding(context) +
                      40, // Extra top padding for close button
                  bottom: _getHorizontalPadding(context),
                ),
                child: MarkdownBody(
                  data: widget.resource.content,
                  styleSheet: MarkdownStyles.darkTheme.copyWith(
                    p: MarkdownStyles.darkTheme.p?.copyWith(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  selectable: true,
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      _launchUrl(href);
                    }
                  },
                  imageBuilder: (uri, title, alt) {
                    final proxiedUrl =
                        'https://api.allorigins.win/raw?url=${Uri.encodeComponent(uri.toString())}';

                    return Container(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                        maxHeight: 400,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          proxiedUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey.withOpacity(0.6),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    alt ?? 'Image not available',
                                    style: TextStyle(
                                      color: Colors.grey.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Close button positioned at top right
              Positioned(
                top: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.9),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch $url'),
              backgroundColor: Colors.red.withOpacity(0.8),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error opening link'),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    }
  }
}
