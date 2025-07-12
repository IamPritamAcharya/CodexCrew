import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownStyles {

  static const Color _codeBackground = Color(
    0xFF0D1117,
  ); 
  static const Color _codeDefault = Color(0xFFE6EDF3); 


  static const Color _paleBlue = Color(0xFF93C5FD);
  static const Color _paleTeal = Color(0xFF67E8F9);
  static const Color _paleGreen = Color(0xFF86EFAC);
  static const Color _paleYellow = Color(0xFFFDE047);
  static const Color _palePink = Color(0xFFF9A8D4);
  static const Color _paleRed = Color(0xFFFF6B6B);
  static const Color _palePurple = Color(0xFFC4B5FD);
  static const Color _paleGray = Color(0xFFCBD5E1);

  static const Color _primaryText = Color(0xFFF1F5F9);
  static const Color _secondaryText = Color(0xFFE2E8F0);
  static const Color _mutedText = Color(0xFF94A3B8);
  static const Color _dimText = Color(0xFF64748B);

  static const Color _surfacePrimary = Color(0xFF1E293B);

  static const Color _borderColor = Color(0xFF475569);

  static MarkdownStyleSheet get darkTheme {
    return MarkdownStyleSheet(
  
      h1: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: _palePurple,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      h2: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _paleBlue,
        height: 1.25,
        letterSpacing: -0.3,
      ),
      h3: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _paleTeal,
        height: 1.3,
        letterSpacing: -0.2,
      ),
      h4: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _paleGreen,
        height: 1.3,
        letterSpacing: -0.1,
      ),
      h5: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _paleYellow,
        height: 1.35,
      ),
      h6: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _palePink,
        height: 1.4,
      ),

      p: const TextStyle(
        fontSize: 16,
        color: _secondaryText,
        height: 1.75,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),

      code: const TextStyle(
        backgroundColor: _codeBackground,
        color: _codeDefault,
        fontFamily: 'JetBrains Mono, Fira Code, Monaco, Consolas, monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      codeblockDecoration: BoxDecoration(
        color: _codeBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF30363D), width: 1), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      codeblockPadding: const EdgeInsets.all(16),

      listBullet: const TextStyle(
        color: _palePurple,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      listIndent: 32,

      a: const TextStyle(
        color: _paleBlue,
        decoration: TextDecoration.underline,
        decorationColor: _paleBlue,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 1.5,
        fontWeight: FontWeight.w500,
      ),

      blockquote: const TextStyle(
        color: _mutedText,
        fontStyle: FontStyle.italic,
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      ),
      blockquoteDecoration: BoxDecoration(
        color: _surfacePrimary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: _paleGray, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      blockquotePadding: const EdgeInsets.all(16),

      tableHead: const TextStyle(
        color: _primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.3,
      ),
      tableBody: const TextStyle(
        color: _secondaryText,
        fontSize: 14,
        height: 1.4,
      ),
      tableHeadAlign: TextAlign.left,
      tableBorder: TableBorder.all(
        color: _borderColor,
        width: 1,
        borderRadius: BorderRadius.circular(6),
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      tableCellsDecoration: BoxDecoration(
        color: _surfacePrimary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),

      horizontalRuleDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            _paleGray.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),

      em: const TextStyle(
        fontStyle: FontStyle.italic,
        color: _paleYellow,
        fontWeight: FontWeight.w500,
      ),
      strong: const TextStyle(
        fontWeight: FontWeight.w700,
        color: _primaryText,
        letterSpacing: 0.2,
      ),
      del: const TextStyle(
        decoration: TextDecoration.lineThrough,
        decorationColor: _paleRed,
        decorationThickness: 2,
        color: _dimText,
      ),

      checkbox: const TextStyle(
        color: _paleGreen,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      textAlign: WrapAlignment.start,

      h1Padding: const EdgeInsets.only(top: 32, bottom: 16),
      h2Padding: const EdgeInsets.only(top: 24, bottom: 12),
      h3Padding: const EdgeInsets.only(top: 20, bottom: 10),
      h4Padding: const EdgeInsets.only(top: 16, bottom: 8),
      h5Padding: const EdgeInsets.only(top: 12, bottom: 6),
      h6Padding: const EdgeInsets.only(top: 10, bottom: 4),
      pPadding: const EdgeInsets.only(bottom: 12),
      listBulletPadding: const EdgeInsets.only(bottom: 4),

      
      blockSpacing: 16,

      
      superscriptFontFeatureTag: 'sups',
      textScaler: TextScaler.linear(1.0),
    );
  }

  static MarkdownStyleSheet get lightTheme {
    return MarkdownStyleSheet(
    
      h1: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: Color(0xFF8B5CF6), 
        height: 1.2,
        letterSpacing: -0.5,
      ),
      h2: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3B82F6), 
        height: 1.25,
        letterSpacing: -0.3,
      ),
      h3: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF06B6D4), 
        height: 1.3,
        letterSpacing: -0.2,
      ),
      h4: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF10B981), 
        height: 1.3,
        letterSpacing: -0.1,
      ),
      h5: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF59E0B), 
        height: 1.35,
      ),
      h6: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFEC4899), 
        height: 1.4,
      ),

      p: const TextStyle(
        fontSize: 16,
        color: Color(0xFF374151),
        height: 1.75,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),

      code: const TextStyle(
        backgroundColor: Color(0xFFF6F8FA), 
        color: Color(0xFF24292F), 
        fontFamily: 'JetBrains Mono, Fira Code, Monaco, Consolas, monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      codeblockDecoration: BoxDecoration(
        color: Color(0xFFF6F8FA), 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFFD0D7DE),
          width: 1,
        ), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      codeblockPadding: const EdgeInsets.all(16),

      listBullet: const TextStyle(
        color: Color(0xFF8B5CF6), 
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      listIndent: 32,

      a: const TextStyle(
        color: Color(0xFF3B82F6),
        decoration: TextDecoration.underline,
        decorationColor: Color(0xFF3B82F6),
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 1.5,
        fontWeight: FontWeight.w500,
      ),

      blockquote: const TextStyle(
        color: Color(0xFF6B7280),
        fontStyle: FontStyle.italic,
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      ),
      blockquoteDecoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: Color(0xFFE5E7EB), width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      blockquotePadding: const EdgeInsets.all(16),

      tableHead: const TextStyle(
        color: Color(0xFF111827),
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.3,
      ),
      tableBody: const TextStyle(
        color: Color(0xFF374151),
        fontSize: 14,
        height: 1.4,
      ),
      tableHeadAlign: TextAlign.left,
      tableBorder: TableBorder.all(
        color: Color(0xFFE5E7EB),
        width: 1,
        borderRadius: BorderRadius.circular(6),
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      tableCellsDecoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(4),
      ),

      horizontalRuleDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFFE5E7EB), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(1),
      ),

      em: const TextStyle(
        fontStyle: FontStyle.italic,
        color: Color(0xFFF59E0B),
        fontWeight: FontWeight.w500,
      ),
      strong: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Color(0xFF111827),
        letterSpacing: 0.2,
      ),
      del: const TextStyle(
        decoration: TextDecoration.lineThrough,
        decorationColor: Color(0xFFEF4444),
        decorationThickness: 2,
        color: Color(0xFF9CA3AF),
      ),

      checkbox: const TextStyle(
        color: Color(0xFF10B981),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      textAlign: WrapAlignment.start,

      h1Padding: const EdgeInsets.only(top: 32, bottom: 16),
      h2Padding: const EdgeInsets.only(top: 24, bottom: 12),
      h3Padding: const EdgeInsets.only(top: 20, bottom: 10),
      h4Padding: const EdgeInsets.only(top: 16, bottom: 8),
      h5Padding: const EdgeInsets.only(top: 12, bottom: 6),
      h6Padding: const EdgeInsets.only(top: 10, bottom: 4),
      pPadding: const EdgeInsets.only(bottom: 12),
      listBulletPadding: const EdgeInsets.only(bottom: 4),

      blockSpacing: 16,

      superscriptFontFeatureTag: 'sups',
      textScaler: TextScaler.linear(1.0),
    );
  }
}
