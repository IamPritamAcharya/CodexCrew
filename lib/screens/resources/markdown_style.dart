import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownStyles {
  static MarkdownStyleSheet get darkTheme {
    return MarkdownStyleSheet(
      p: const TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 16,
        fontFamily: 'ProductSans',
      ),
      pPadding: const EdgeInsets.symmetric(vertical: 8),
      h1: const TextStyle(
        color: Color(0xFFD8E6FF),
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'ProductSans',
      ),
      h1Padding: const EdgeInsets.symmetric(vertical: 10),
      h2: const TextStyle(
        color: Color(0xFFDBFFE1),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'ProductSans',
      ),
      h2Padding: const EdgeInsets.symmetric(vertical: 10),
      h3: const TextStyle(
        color: Color(0xFFFFEED8),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'ProductSans',
      ),
      h3Padding: const EdgeInsets.symmetric(vertical: 8),
      h4: const TextStyle(
        color: Color(0xFFFFDADA),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'ProductSans',
      ),
      h4Padding: const EdgeInsets.symmetric(vertical: 6),
      strong: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFFE6E6E6),
      ),
      em: const TextStyle(
        fontStyle: FontStyle.italic,
        color: Color(0xFFC5C5C5),
      ),
      del: const TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Color(0xFFAAAAAA),
      ),
      code: const TextStyle(
        fontFamily: 'Courier',
        fontSize: 14,
        color: Color(0xFFFFC107),
        backgroundColor: Color(0xFF333333),
      ),
      listBullet: const TextStyle(color: Colors.white, fontSize: 16),
      listBulletPadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      blockquotePadding: const EdgeInsets.all(12),
      blockquoteDecoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: const Border(
          left: BorderSide(color: Color(0xFFAAAAAA), width: 4),
        ),
      ),
      horizontalRuleDecoration: const BoxDecoration(color: Color(0xFFAAAAAA)),
      tableHead: const TextStyle(
        color: Color(0xFFD8E6FF),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        fontFamily: 'ProductSans',
      ),
      tableBody: const TextStyle(
        color: Color(0xFFF5F5F5),
        fontSize: 14,
        fontFamily: 'ProductSans',
      ),
      tablePadding: const EdgeInsets.symmetric(vertical: 6),
      tableBorder: TableBorder.all(
        color: Colors.white.withOpacity(0.1),
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.all(8),
      tableCellsDecoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
      a: const TextStyle(
        color: Color(0xFFADD8E6),
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w600,
      ),
      codeblockPadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
      ),
      img: const TextStyle(fontSize: 16, color: Colors.white),
    );
  }
}
