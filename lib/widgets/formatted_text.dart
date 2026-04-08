import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormattedText extends StatelessWidget {
  final String text;

  const FormattedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _parseText(_decodeHtmlEntities(text)),
    );
  }

  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&#39;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  TextSpan _parseText(String text) {
    final List<TextSpan> spans = [];
    final baseStyle = GoogleFonts.inter(color: Colors.white, fontSize: 14);
    
    // Split by lines to handle bullet points
    final lines = text.split('\n');
    
    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      String line = lines[lineIndex];
      
      // Handle bullet points
      if (line.trim().startsWith('*')) {
        line = 'â€¢ ${line.trim().substring(1).trim()}';
      }
      
      // Split by ** for bold
      final parts = line.split('**');
      
      for (int i = 0; i < parts.length; i++) {
        if (i % 2 == 0) {
          // Regular text
          spans.add(TextSpan(text: parts[i], style: baseStyle));
        } else {
          // Bold text
          spans.add(TextSpan(
            text: parts[i], 
            style: baseStyle.copyWith(fontWeight: FontWeight.bold)
          ));
        }
      }
      
      // Add line break if not the last line
      if (lineIndex < lines.length - 1) {
        spans.add(TextSpan(text: '\n', style: baseStyle));
      }
    }
    
    return TextSpan(children: spans);
  }
}
