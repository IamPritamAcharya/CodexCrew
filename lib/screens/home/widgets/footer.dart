import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleFooter extends StatelessWidget {
  const SimpleFooter({super.key});

  static const Map<String, String> brandInfo = {
    'name': 'Codex Crew',
    'tagline': 'Building amazing experiences for everyone.',
  };

  static const Map<String, Map<String, dynamic>> contactInfo = {
    'email': {
      'icon': Icons.email,
      'label': 'codexcrew@gmail.com',
      'action': 'mailto:codexcrew@gmail.com',
    },
    'phone': {
      'icon': Icons.phone,
      'label': '+91 6370486583',
      'action': 'tel:+916370486583',
    },
    'location': {
      'icon': Icons.location_on,
      'label': 'Sarang, Odisha',
      'action':
          'https://www.google.com/maps/place/Indira+Gandhi+Institute+Of+Technology,+Sarang/@20.9350375,85.2632969,17z/data=!3m1!4b1!4m6!3m5!1s0x3a18b5e2246737db:0x464c86301dac34cb!8m2!3d20.9350375!4d85.2632969!16s%2Fm%2F02vkz4b?entry=ttu&g_ep=EgoyMDI1MDcwOS4wIKXMDSoASAFQAw%3D%3D',
    },
  };

  static const Map<String, Map<String, String>> socialMedia = {
    'instagram': {
      'name': 'Instagram',
      'url': 'https://www.instagram.com/codexcrew.igit/',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2111/2111463.png',
    },
    'linkedin': {
      'name': 'LinkedIn',
      'url': 'https://www.linkedin.com/company/codexcrew/',
      'icon': 'https://cdn-icons-png.flaticon.com/512/174/174857.png',
    },
  };

  static const Map<String, String> copyrightInfo = {
    'year': '2025',
    'company': 'Codex Crew',
    'text': 'All rights reserved.',
  };

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _handleNavigation(String route) {
    print('Navigate to $route');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 40,
        horizontal: isMobile ? 16 : 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobile) _buildMobileLayout() else _buildDesktopLayout(isTablet),
          SizedBox(height: isMobile ? 20 : 30),
          Container(
            height: 1,
            color: Colors.grey[800],
            margin: const EdgeInsets.only(bottom: 20),
          ),
          _buildBottomSection(isMobile),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBrandSection(true),
        const SizedBox(height: 25),
        _buildContactInfo(true),
        const SizedBox(height: 25),
        _buildSocialMedia(true),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: _buildBrandSection(false)),
        if (!isTablet) const SizedBox(width: 40),
        Expanded(flex: 1, child: _buildContactInfo(false)),
        if (!isTablet) const SizedBox(width: 40),
        Expanded(flex: 1, child: _buildSocialMedia(false)),
      ],
    );
  }

  Widget _buildBrandSection(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          brandInfo['name']!,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          brandInfo['tagline']!,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isMobile ? 14 : 16,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildContactInfo(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...contactInfo.entries.map(
          (entry) => _buildContactItem(
            entry.value['icon'] as IconData,
            entry.value['label'] as String,
            entry.value['action'] as String,
            isMobile,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMedia(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 15,
          runSpacing: 10,
          children:
              socialMedia.entries
                  .map(
                    (entry) => _buildSocialIcon(
                      entry.value['icon']!,
                      entry.value['url']!,
                      entry.value['name']!,
                      isMobile ? 28 : 32,
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildBottomSection(bool isMobile) {
    String copyrightText =
        '© ${copyrightInfo['year']} ${copyrightInfo['company']}. ${copyrightInfo['text']}';

    if (isMobile) {
      return Column(
        children: [
          Text(
            copyrightText,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          copyrightText,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String text,
    String action,
    bool isMobile,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _launchURL(action),
          child: HoverableContactItem(
            icon: icon,
            text: text,
            isMobile: isMobile,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    String iconUrl,
    String url,
    String name,
    double size,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Tooltip(
          message: name,
          child: HoverableSocialIcon(iconUrl: iconUrl, size: size),
        ),
      ),
    );
  }
}

class HoverableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextStyle hoverStyle;

  const HoverableText({
    super.key,
    required this.text,
    required this.style,
    required this.hoverStyle,
  });

  @override
  State<HoverableText> createState() => _HoverableTextState();
}

class _HoverableTextState extends State<HoverableText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: _isHovered ? widget.hoverStyle : widget.style,
        child: Text(widget.text),
      ),
    );
  }
}

class HoverableContactItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isMobile;

  const HoverableContactItem({
    super.key,
    required this.icon,
    required this.text,
    required this.isMobile,
  });

  @override
  State<HoverableContactItem> createState() => _HoverableContactItemState();
}

class _HoverableContactItemState extends State<HoverableContactItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: _isHovered ? Colors.white : Colors.grey[400],
              size: widget.isMobile ? 16 : 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.grey[300],
                fontSize: widget.isMobile ? 14 : 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverableSocialIcon extends StatefulWidget {
  final String iconUrl;
  final double size;

  const HoverableSocialIcon({
    super.key,
    required this.iconUrl,
    required this.size,
  });

  @override
  State<HoverableSocialIcon> createState() => _HoverableSocialIconState();
}

class _HoverableSocialIconState extends State<HoverableSocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _isHovered ? Colors.grey[700] : Colors.grey[900],
        ),
        child: Image.network(
          widget.iconUrl,
          width: widget.size,
          height: widget.size,
          color: _isHovered ? Colors.grey[200] : null,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              size: widget.size,
              color: Colors.grey[400],
            );
          },
        ),
      ),
    );
  }
}
