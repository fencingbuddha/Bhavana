import 'package:flutter/material.dart';

/// Semantic color tokens for Bhāvanā — water blues + soft moss.
/// Light and dark palettes target WCAG AA for body text on surfaces.
@immutable
class BhavanaColors {
  const BhavanaColors({
    required this.brightness,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onPrimary,
    required this.primaryFill,
    required this.onPrimaryFill,
    required this.secondary,
    required this.onSecondary,
    required this.border,
    required this.progress,
    required this.progressTrack,
    required this.destructiveQuiet,
    required this.onDestructiveQuiet,
    required this.overlay,
    required this.focusRing,
  });

  final Brightness brightness;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color onPrimary;
  final Color primaryFill;
  final Color onPrimaryFill;
  final Color secondary;
  final Color onSecondary;
  final Color border;
  final Color progress;
  final Color progressTrack;
  final Color destructiveQuiet;
  final Color onDestructiveQuiet;
  final Color overlay;
  final Color focusRing;

  /// Light: soft water wash. Body #1E333B on #E8F2F5 ≥ AA.
  static const light = BhavanaColors(
    brightness: Brightness.light,
    surface: Color(0xFFE8F2F5),
    surfaceRaised: Color(0xFFF7FBFC),
    surfaceSunken: Color(0xFFD7E6EB),
    onSurface: Color(0xFF1E333B),
    onSurfaceMuted: Color(0xFF4A6570),
    primary: Color(0xFF2F5F6E),
    onPrimary: Color(0xFFF7FBFC),
    primaryFill: Color(0xFF2F5F6E),
    onPrimaryFill: Color(0xFFF7FBFC),
    secondary: Color(0xFF5F8F72),
    onSecondary: Color(0xFFF7FBFC),
    border: Color(0xFFB7CDD6),
    progress: Color(0xFF3D7A8C),
    progressTrack: Color(0xFFC5D9E0),
    destructiveQuiet: Color(0xFF8A4F4F),
    onDestructiveQuiet: Color(0xFFF7FBFC),
    overlay: Color(0x661E333B),
    focusRing: Color(0xFF3D7A8C),
  );

  /// Dark: deep water. Body #E4EEF1 on #0F1C22 ≥ AA.
  static const dark = BhavanaColors(
    brightness: Brightness.dark,
    surface: Color(0xFF0F1C22),
    surfaceRaised: Color(0xFF172830),
    surfaceSunken: Color(0xFF0A1418),
    onSurface: Color(0xFFE4EEF1),
    onSurfaceMuted: Color(0xFFA3B8C2),
    primary: Color(0xFF8EBFCE),
    onPrimary: Color(0xFF0F1C22),
    primaryFill: Color(0xFF3D7A8C),
    onPrimaryFill: Color(0xFFF7FBFC),
    secondary: Color(0xFF9BC4A8),
    onSecondary: Color(0xFF0F1C22),
    border: Color(0xFF2A404A),
    progress: Color(0xFF8EBFCE),
    progressTrack: Color(0xFF243740),
    destructiveQuiet: Color(0xFFD4A0A0),
    onDestructiveQuiet: Color(0xFF0F1C22),
    overlay: Color(0x99000000),
    focusRing: Color(0xFF8EBFCE),
  );

  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primaryFill,
      onPrimary: onPrimaryFill,
      secondary: secondary,
      onSecondary: onSecondary,
      error: destructiveQuiet,
      onError: onDestructiveQuiet,
      surface: surface,
      onSurface: onSurface,
    );
  }
}
