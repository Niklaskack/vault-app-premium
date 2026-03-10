import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VaultTheme {
  // Deep space/navy blues matching the preview background
  static const Color primaryBackground = Color(0xFF0D1B2A); 
  static const Color secondaryBackground = Color(0xFF1B263B);
  
  // Accents and glowing colors from the previews
  static const Color accentBlue = Color(0xFF415A77);
  static const Color glowCyan = Color(0xFF00E5FF);
  static const Color textWhite = Color(0xFFE0E1DD);

  static final ThemeData light = dark; // Force dark mode aesthetic for the entire app to match preview

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryBackground,
    colorScheme: const ColorScheme.dark(
      primary: glowCyan,
      secondary: accentBlue,
      surface: secondaryBackground,
      onPrimary: Colors.white,
      onSurface: textWhite,
    ),
    textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: GoogleFonts.montserrat(color: textWhite),
      bodyMedium: GoogleFonts.montserrat(color: textWhite),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentBlue,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: glowCyan.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
  );
}
