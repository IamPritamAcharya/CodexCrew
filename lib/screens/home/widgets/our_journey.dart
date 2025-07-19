import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OurJourneyWidget extends StatelessWidget {
  const OurJourneyWidget({super.key});

  static const List<Map<String, dynamic>> journeyStats = [
    {
      'icon': CupertinoIcons.down_arrow,
      'number': '1500+',
      'label': 'Total App Downloads',
    },
    {
      'icon': CupertinoIcons.calendar,
      'number': '2.5K+',
      'label': 'Events Covered',
    },
    {
      'icon': CupertinoIcons.photo_camera,
      'number': '15K+',
      'label': 'Photos Uploaded',
    },
    {'icon': CupertinoIcons.person, 'number': '25K+', 'label': 'Faces Scanned'},
    {'icon': CupertinoIcons.star, 'number': '4.8/5', 'label': 'Average Rating'},
    {
      'icon': CupertinoIcons.heart,
      'number': '500+',
      'label': 'Happy Customers',
    },
    {
      'icon': CupertinoIcons.location,
      'number': '50+',
      'label': 'Cities Covered',
    },
    {
      'icon': CupertinoIcons.clock,
      'number': '24/7',
      'label': 'Support Available',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

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
            'Our Journey So Far',
            style: TextStyle(
              fontSize: isWeb ? 42 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isWeb ? 16 : 8),

          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWeb ? 16 : 14,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
          SizedBox(height: isWeb ? 60 : 30),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1000) {
                return Column(
                  children: [
                    Row(
                      children:
                          journeyStats
                              .take(4)
                              .map(
                                (stat) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: _buildStatCard(stat, true),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children:
                          journeyStats
                              .skip(4)
                              .take(4)
                              .map(
                                (stat) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: _buildStatCard(stat, true),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                );
              } else if (constraints.maxWidth > 600) {
                return Column(
                  children: [
                    for (int i = 0; i < journeyStats.length; i += 2)
                      Column(
                        children: [
                          if (i > 0) const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _buildStatCard(journeyStats[i], true),
                                ),
                              ),
                              if (i + 1 < journeyStats.length)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: _buildStatCard(
                                      journeyStats[i + 1],
                                      true,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    for (int i = 0; i < journeyStats.length; i += 2)
                      Column(
                        children: [
                          if (i > 0) const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildStatCard(journeyStats[i], false),
                                ),
                              ),
                              if (i + 1 < journeyStats.length)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: _buildStatCard(
                                      journeyStats[i + 1],
                                      false,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat, bool isWeb) {
    return StatCardWidget(stat: stat, isWeb: isWeb);
  }
}

class StatCardWidget extends StatefulWidget {
  final Map<String, dynamic> stat;
  final bool isWeb;

  const StatCardWidget({super.key, required this.stat, required this.isWeb});

  @override
  State<StatCardWidget> createState() => _StatCardWidgetState();
}

class _StatCardWidgetState extends State<StatCardWidget>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _iconScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: widget.isWeb ? 240 : 140,
              padding: EdgeInsets.all(widget.isWeb ? 24 : 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: Container(
                            width: widget.isWeb ? 60 : 40,
                            height: widget.isWeb ? 60 : 30,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.stat['icon'],
                              size: widget.isWeb ? 24 : 20,
                              color:
                                  isHovered ? Color(0xFF6366F1) : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: widget.isWeb ? 16 : 12),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: widget.isWeb ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: isHovered ? Color(0xFF6366F1) : Colors.white,
                          ),
                          child: Text(widget.stat['number']),
                        ),
                        SizedBox(height: widget.isWeb ? 8 : 4),
                        Text(
                          widget.stat['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.isWeb ? 12 : 10,
                            color: Colors.grey[400],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: BorderLinesPainter(isHovered: isHovered),
                    size: Size.infinite,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BorderLinesPainter extends CustomPainter {
  final bool isHovered;

  BorderLinesPainter({this.isHovered = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint =
        Paint()
          ..color = isHovered ? Color(0xFF6366F1) : Colors.grey[500]!
          ..style = PaintingStyle.fill;

    final Paint linePaint =
        Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    final Color lineColor = isHovered ? Color(0xFF6366F1) : Colors.grey[600]!;

    linePaint.shader = LinearGradient(
      colors: [Colors.transparent, lineColor, lineColor, Colors.transparent],
      stops: [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(20, 0, size.width - 40, 1));

    canvas.drawLine(Offset(20, 0), Offset(size.width - 20, 0), linePaint);

    linePaint.shader = LinearGradient(
      colors: [Colors.transparent, lineColor, lineColor, Colors.transparent],
      stops: [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(20, size.height - 1, size.width - 40, 1));

    canvas.drawLine(
      Offset(20, size.height - 1),
      Offset(size.width - 20, size.height - 1),
      linePaint,
    );

    linePaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, lineColor, lineColor, Colors.transparent],
      stops: [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(0, 20, 1, size.height - 40));

    canvas.drawLine(Offset(0, 20), Offset(0, size.height - 20), linePaint);

    linePaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, lineColor, lineColor, Colors.transparent],
      stops: [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(size.width - 1, 20, 1, size.height - 40));

    canvas.drawLine(
      Offset(size.width - 1, 20),
      Offset(size.width - 1, size.height - 20),
      linePaint,
    );

    final double dotRadius = 2;

    canvas.drawCircle(Offset(0, 0), dotRadius, dotPaint);
    canvas.drawCircle(Offset(size.width, 0), dotRadius, dotPaint);
    canvas.drawCircle(Offset(0, size.height - 1), dotRadius, dotPaint);
    canvas.drawCircle(Offset(size.width, size.height - 1), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
