import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({super.key});

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  List<DocumentSnapshot>? _cachedWorkshops; 

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;

        return Container(
          width: double.infinity,

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(isDesktop),
              _buildWorkshopsSection(isDesktop),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 80 : 60,
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.white, Color(0xFF6366F1)],
                ).createShader(bounds),
            child: Text(
              'WORKSHOPS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 64 : 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -2,
              ),
            ),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Text(
              'Learn, Build, and Grow with Us',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopsSection(bool isDesktop) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('workshops')
              .orderBy('date', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
       
          if (_cachedWorkshops != null) {
            return _buildWorkshopPageView(_cachedWorkshops!, isDesktop);
          }
          return _buildLoadingState();
        }
        if (snapshot.hasError) {
          return _buildErrorState();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(isDesktop);
        }

        final workshops = snapshot.data!.docs;

        if (_cachedWorkshops == null ||
            _cachedWorkshops!.length != workshops.length) {
          _cachedWorkshops = workshops;
       
          if (_currentIndex >= workshops.length) {
            _currentIndex = workshops.length - 1;
 
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  _currentIndex,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          }
        }

        return _buildWorkshopPageView(workshops, isDesktop);
      },
    );
  }

  Widget _buildWorkshopPageView(
    List<DocumentSnapshot> workshops,
    bool isDesktop,
  ) {
    return Container(
      height: isDesktop ? 800 : 500,
      constraints: BoxConstraints(maxWidth: 1200),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: workshops.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final data = workshops[index].data() as Map<String, dynamic>;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20),
                child: WorkshopCard(
                  title: data['title'] ?? 'No Title',
                  date: data['date'] ?? 'No Date',
                  description: data['description'] ?? 'No Description',
                  images: List<String>.from(data['images'] ?? []),
                  isDesktop: isDesktop,
                  onTap: () => _showWorkshopModal(context, data, isDesktop),
                ),
              );
            },
          ),
          if (isDesktop && workshops.length > 1) ...[
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildArrowButton(
                  Icons.arrow_back_ios,
                  _currentIndex > 0
                      ? () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                      : null,
                ),
              ),
            ),
            Positioned(
              right: 60,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildArrowButton(
                  Icons.arrow_forward_ios,
                  _currentIndex < workshops.length - 1
                      ? () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                      : null,
                ),
              ),
            ),
          ],
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                workshops.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentIndex == index
                              ? Color(0xFF6366F1)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback? onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color:
              onPressed != null ? Colors.white : Colors.white.withOpacity(0.3),
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 800,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Error loading workshops',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop) {
    return Container(
      height: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              color: Color(0xFF6366F1),
              size: isDesktop ? 64 : 48,
            ),
            SizedBox(height: 16),
            Text(
              'No workshops available',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkshopModal(
    BuildContext context,
    Map<String, dynamic> data,
    bool isDesktop,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkshopModal(data: data, isDesktop: isDesktop),
    );
  }
}

class WorkshopCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final List<String> images;
  final bool isDesktop;
  final VoidCallback onTap;

  const WorkshopCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.images,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              if (images.isNotEmpty)
                Expanded(
                  flex: isDesktop ? 3 : 2,
                  child: Image.network(
                    images.first,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Color(0xFF1A1A1A),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white.withOpacity(0.3),
                            size: 48,
                          ),
                        ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 24 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF6366F1).withOpacity(0.2),
                        ),
                        child: Text(
                          date,
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: isDesktop ? 14 : 13,
                            color: Colors.white.withOpacity(0.7),
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF6366F1).withOpacity(0.5),
                          ),
                          color: Color(0xFF6366F1).withOpacity(0.1),
                        ),
                        child: Text(
                          'Learn More',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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

class WorkshopModal extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isDesktop;

  const WorkshopModal({super.key, required this.data, required this.isDesktop});

  @override
  State<WorkshopModal> createState() => _WorkshopModalState();
}

class _WorkshopModalState extends State<WorkshopModal> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = List<String>.from(widget.data['images'] ?? []);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.data['title'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: widget.isDesktop ? 24 : 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF6366F1).withOpacity(0.2),
            ),
            child: Text(
              widget.data['date'] ?? 'No Date',
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
          if (images.isNotEmpty)
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _imageController,
                    onPageChanged:
                        (index) => setState(() => _currentImageIndex = index),
                    itemCount: images.length,
                    itemBuilder:
                        (context, index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Color(0xFF2A2A2A),
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentImageIndex == index
                                      ? Color(0xFF6366F1)
                                      : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.data['description'] ?? 'No Description',
                style: TextStyle(
                  fontSize: widget.isDesktop ? 16 : 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.6,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
