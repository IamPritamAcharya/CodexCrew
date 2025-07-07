import 'package:flutter/material.dart';

class HeroActionButtons extends StatelessWidget {
  final bool isDesktop;

  const HeroActionButtons({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ModernButton(
          text: 'Get Started',
          isPrimary: true,
          isDesktop: isDesktop,
          onTap: () {},
        ),
        SizedBox(width: isDesktop ? 16 : 0, height: isDesktop ? 0 : 16),
        ModernButton(
          text: 'Learn More',
          isPrimary: false,
          isDesktop: isDesktop,
          onTap: () {},
        ),
      ],
    );
  }
}

class ModernButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final bool isDesktop;
  final VoidCallback onTap;

  const ModernButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  _ModernButtonState createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter:
          (_) => widget.isDesktop ? setState(() => _isHovered = true) : null,
      onExit:
          (_) => widget.isDesktop ? setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.isDesktop ? null : double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isDesktop ? 50 : 24,
            vertical: widget.isDesktop ? 16 : 18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient:
                widget.isPrimary
                    ? LinearGradient(
                      colors: [
                        Color(
                          _isHovered && widget.isDesktop
                              ? 0xFF4F46E5
                              : 0xFF6366F1,
                        ),
                        Color(
                          _isHovered && widget.isDesktop
                              ? 0xFF7C3AED
                              : 0xFF8B5CF6,
                        ),
                      ],
                    )
                    : null,
            border:
                widget.isPrimary
                    ? null
                    : Border.all(
                      color: Colors.white.withOpacity(
                        _isHovered && widget.isDesktop ? 0.4 : 0.2,
                      ),
                    ),
            color:
                widget.isPrimary
                    ? null
                    : Colors.white.withOpacity(
                      _isHovered && widget.isDesktop ? 0.1 : 0.05,
                    ),
          ),
          transform:
              Matrix4.identity()
                ..scale(_isHovered && widget.isDesktop ? 1.05 : 1.0),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.isDesktop ? 16 : 18,
              fontWeight: FontWeight.w600,
              letterSpacing: _isHovered && widget.isDesktop ? 0.5 : 0.0,
            ),
          ),
        ),
      ),
    );
  }
}
