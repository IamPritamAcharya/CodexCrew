import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BentoGrid extends StatefulWidget {
  const BentoGrid({super.key});

  @override
  _BentoGridState createState() => _BentoGridState();
}

class _BentoGridState extends State<BentoGrid> {
  List<String> _images = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreImages();
      }
    }
  }

  Future<void> _loadImages() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('gallery_images')
              .orderBy('created_at', descending: true)
              .limit(_pageSize)
              .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _hasMoreData = false;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _images =
            querySnapshot.docs
                .map((doc) => doc.data()['url'] as String)
                .toList();
        _lastDocument = querySnapshot.docs.last;
        _hasMoreData = querySnapshot.docs.length == _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreImages() async {
    if (_isLoadingMore || !_hasMoreData) return;

    try {
      setState(() {
        _isLoadingMore = true;
      });

      Query query = FirebaseFirestore.instance
          .collection('gallery_images')
          .orderBy('created_at', descending: true)
          .limit(_pageSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _hasMoreData = false;
          _isLoadingMore = false;
        });
        return;
      }

      final newImages =
          querySnapshot.docs
              .map(
                (doc) => (doc.data() as Map<String, dynamic>)['url'] as String,
              )
              .toList();

      setState(() {
        _images.addAll(newImages);
        _lastDocument = querySnapshot.docs.last;
        _hasMoreData = querySnapshot.docs.length == _pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load more images'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _images.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
              SizedBox(height: 16),
              Text(
                'Failed to load images',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                    _images.clear();
                    _lastDocument = null;
                    _hasMoreData = true;
                  });
                  _loadImages();
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1400),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  _buildBentoGrid(),
                  if (_isLoadingMore) _buildLoadingMoreIndicator(),
                  if (!_hasMoreData && _images.isNotEmpty) _buildEndMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.grey[600]),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Loading more images...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEndMessage() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.grey[500], size: 18),
          SizedBox(width: 8),
          Text(
            'You\'ve reached the end!',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 4; 
    } else if (isTablet) {
      crossAxisCount = 8;
    } else {
      crossAxisCount = 12; 
    }

    return StaggeredGrid.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children:
          _images.asMap().entries.map((entry) {
            final index = entry.key;
            final imageUrl = entry.value;

            return StaggeredGridTile.count(
              crossAxisCellCount: _getTileWidth(
                index,
                isMobile,
                isTablet,
                isDesktop,
              ),
              mainAxisCellCount: _getTileHeight(
                index,
                isMobile,
                isTablet,
                isDesktop,
              ),
              child: _buildImageTile(imageUrl, index),
            );
          }).toList(),
    );
  }

  int _getTileWidth(int index, bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
    
      final patterns = [
        [2, 2],
        [2, 2],
        [2, 2],
        [2, 2], 
        [2, 2], 
      ];
      final patternIndex = (index ~/ 8) % patterns.length;
      final positionInPattern = index % patterns[patternIndex].length;
      return patterns[patternIndex][positionInPattern];
    } else if (isTablet) {
 
      final patterns = [
        [4, 4], 
        [3, 2, 3], 
        [2, 4, 2], 
        [2, 3, 3], 
        [3, 3, 2], 
        [4, 2, 2], 
        [2, 2, 4], 
        [2, 2, 2, 2],
      ];
      final patternIndex = (index ~/ 15) % patterns.length;
      final positionInPattern = index % patterns[patternIndex].length;
      return patterns[patternIndex][positionInPattern];
    } else {
   
      final patterns = [
        [6, 6],
        [4, 4, 4],
        [5, 4, 3], 
        [3, 6, 3], 
        [4, 5, 3], 
        [3, 4, 5], 
        [6, 3, 3],
        [3, 3, 6], 
        [4, 4, 4], 
        [5, 7], 
        [7, 5], 
        [3, 3, 3, 3], 
      ];
      final patternIndex = (index ~/ 20) % patterns.length;
      final positionInPattern = index % patterns[patternIndex].length;
      return patterns[patternIndex][positionInPattern];
    }
  }

  int _getTileHeight(int index, bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
    
      final heights = [2, 3, 2, 2, 3, 2, 3, 2, 2, 3, 2, 3, 2, 2, 3];
      return heights[index % heights.length];
    } else if (isTablet) {
 
      final heights = [4, 3, 5, 3, 4, 3, 4, 5, 3, 4, 3, 5, 4, 3, 4];
      return heights[index % heights.length];
    } else {
 
      final heights = [
        4,
        3,
        5,
        3,
        4,
        6,
        3,
        4,
        5,
        3,
        4,
        3,
        5,
        4,
        3,
        5,
        4,
        3,
        4,
        6,
        3,
        4,
        5,
        3,
        4,
      ];
      return heights[index % heights.length];
    }
  }

  Widget _buildImageTile(String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _openFullScreenImage(imageUrl, index),
      child: Hero(
        tag: 'image_$index',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.grey[400]),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Image not available',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openFullScreenImage(String imageUrl, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.9),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenImageView(
            imageUrl: imageUrl,
            heroTag: 'image_$index',
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }
}

class FullScreenImageView extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageView({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: widget.heroTag,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: InteractiveViewer(
                          panEnabled: true,
                          boundaryMargin: EdgeInsets.all(20),
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.contain,
                            placeholder:
                                (context, url) => Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.black,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.white, size: 24),
                      splashRadius: 20,
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
}
