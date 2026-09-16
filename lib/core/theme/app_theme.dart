import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Calm water-inspired Material 3 theme — soft blues and greens.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF5B8FA8);
  static const Color _waterDeep = Color(0xFF3D6B7A);
  static const Color _waterSoft = Color(0xFFE8F2F5);
  static const Color _moss = Color(0xFF6B9B7A);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      primary: _waterDeep,
      secondary: _moss,
      surface: _waterSoft,
    );

    final baseText = GoogleFonts.nunitoTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _waterSoft,
      textTheme: baseText.apply(
        bodyColor: const Color(0xFF2A3F47),
        displayColor: const Color(0xFF2A3F47),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _waterSoft,
        foregroundColor: _waterDeep,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _waterDeep,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _waterDeep,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _waterDeep,
          side: BorderSide(color: _waterDeep.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        indicatorColor: _seed.withValues(alpha: 0.2),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
