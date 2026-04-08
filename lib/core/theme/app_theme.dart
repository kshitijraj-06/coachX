import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFF212121);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color darkBackground = Color(0xFF121212);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      background: lightBackground,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      bodyLarge: GoogleFonts.inter(
        color: accentColor,
      ),
      bodyMedium: GoogleFonts.inter(
        color: accentColor,
      ),
      bodySmall: GoogleFonts.inter(
        color: accentColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: Color(0xFF1E1E1E),
      background: darkBackground,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.inter(
        color: Colors.white70,
      ),
      bodyMedium: GoogleFonts.inter(
        color: Colors.white70,
      ),
      bodySmall: GoogleFonts.inter(
        color: Colors.white70,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
