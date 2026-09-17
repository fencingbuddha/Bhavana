import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens_color.dart';

/// Nunito humanist sans. Timer uses tabular figures.
@immutable
class BhavanaTypography {
  const BhavanaTypography._(this.textTheme, this.timer);

  final TextTheme textTheme;
  final TextStyle timer;

  factory BhavanaTypography.forColors(BhavanaColors colors) {
    final base = GoogleFonts.nunitoTextTheme().apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );

    final textTheme = base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: colors.onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurfaceMuted,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: colors.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: colors.onSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
        color: colors.onSurfaceMuted,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurfaceMuted,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurfaceMuted,
      ),
    );

    final timer = GoogleFonts.nunito(
      fontSize: 40,
      fontWeight: FontWeight.w500,
      height: 1.1,
      letterSpacing: 0.5,
      color: colors.onSurface,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return BhavanaTypography._(textTheme, timer);
  }
}
