import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleFooter extends StatelessWidget {
  const SimpleFooter({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
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

        _buildNavigationLinks(true),
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

       
        Expanded(flex: 1, child: _buildNavigationLinks(false)),

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
          'Your App Name',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Building amazing experiences for everyone.',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isMobile ? 14 : 16,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildNavigationLinks(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildNavLink('Home', isMobile),
        _buildNavLink('About', isMobile),
        _buildNavLink('Services', isMobile),
        _buildNavLink('Contact', isMobile),
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
        _buildContactItem(Icons.email, 'hello@yourapp.com', isMobile),
        _buildContactItem(Icons.phone, '+1 (555) 123-4567', isMobile),
        _buildContactItem(Icons.location_on, 'Your City, Country', isMobile),
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
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _buildSocialIcon(
              'https://cdn-icons-png.flaticon.com/512/2111/2111463.png',
              'https://www.instagram.com',
              isMobile ? 28 : 32,
            ),
            const SizedBox(width: 15),
            _buildSocialIcon(
              'https://cdn-icons-png.flaticon.com/512/174/174857.png',
              'https://www.linkedin.com',
              isMobile ? 28 : 32,
            ),
            const SizedBox(width: 15),
            _buildSocialIcon(
              'https://cdn-icons-png.flaticon.com/512/733/733579.png',
              'https://www.twitter.com',
              isMobile ? 28 : 32,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSection(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Text(
            '© 2025 Your App Name. All rights reserved.',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink('Privacy Policy', true),
              Text(' • ', style: TextStyle(color: Colors.grey[600])),
              _buildFooterLink('Terms of Service', true),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '© 2025 Your App Name. All rights reserved.',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        Row(
          children: [
            _buildFooterLink('Privacy Policy', false),
            const SizedBox(width: 20),
            _buildFooterLink('Terms of Service', false),
          ],
        ),
      ],
    );
  }

  Widget _buildNavLink(String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
        
          print('Navigate to $text');
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: isMobile ? 14 : 15,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey[400], size: isMobile ? 16 : 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: isMobile ? 14 : 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, bool isMobile) {
    return GestureDetector(
      onTap: () {

        print('Open $text');
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: isMobile ? 12 : 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String iconUrl, String url, double size) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[900],
        ),
        child: Image.network(
          iconUrl,
          width: size,
          height: size,
          color: Colors.white,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, size: size, color: Colors.grey[400]);
          },
        ),
      ),
    );
  }
}
