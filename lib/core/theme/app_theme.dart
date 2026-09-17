import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bhavana_theme.dart';
import 'tokens_color.dart';
import 'tokens_motion.dart';
import 'tokens_radius.dart';
import 'tokens_spacing.dart';
import 'tokens_typography.dart';

/// Builds ThemeData from tokens and wraps the tree with [BhavanaTheme].
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(BhavanaColors.light);
  static ThemeData get dark => _build(BhavanaColors.dark);

  static ThemeData _build(BhavanaColors colors) {
    final typography = BhavanaTypography.forColors(colors);
    final radii = BhavanaRadii.instance;
    final spacing = BhavanaSpacing.instance;
    final scheme = colors.toColorScheme();

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      canvasColor: colors.surface,
      dividerColor: colors.border,
      textTheme: typography.textTheme,
      primaryTextTheme: typography.textTheme,
      splashFactory: InkRipple.splashFactory,
      highlightColor: colors.primary.withValues(alpha: 0.08),
      splashColor: colors.primary.withValues(alpha: 0.12),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: colors.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceRaised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radii.card,
          side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radii.dialog),
        titleTextStyle: typography.textTheme.titleLarge,
        contentTextStyle: typography.textTheme.bodyMedium,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primaryFill,
          foregroundColor: colors.onPrimaryFill,
          minimumSize: Size(spacing.tapTarget * 2, spacing.tapTarget),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.sm,
          ),
          shape: RoundedRectangleBorder(borderRadius: radii.button),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: Size(spacing.tapTarget * 2, spacing.tapTarget),
          side: BorderSide(color: colors.border),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          shape: RoundedRectangleBorder(borderRadius: radii.button),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.onSurfaceMuted,
          minimumSize: Size(spacing.tapTarget, spacing.tapTarget),
          shape: RoundedRectangleBorder(borderRadius: radii.button),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceSunken,
        selectedColor: colors.primary.withValues(alpha: 0.18),
        disabledColor: colors.surfaceSunken,
        labelStyle: typography.textTheme.labelLarge!,
        secondaryLabelStyle: typography.textTheme.labelLarge!,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: radii.chip),
        side: BorderSide(color: colors.border.withValues(alpha: 0.6)),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceRaised,
        elevation: 0,
        height: 64,
        indicatorColor: colors.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? colors.primary : colors.onSurfaceMuted,
          );
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.progress,
        linearTrackColor: colors.progressTrack,
        circularTrackColor: colors.progressTrack,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.onSurface,
        contentTextStyle: typography.textTheme.bodyMedium?.copyWith(
          color: colors.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radii.md)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radii.lg)),
        ),
      ),
    );
  }

  /// Wraps [child] with token InheritedWidget matching [brightness].
  static Widget wrap({
    required Brightness brightness,
    required Widget child,
    bool reduceMotion = false,
  }) {
    final colors =
        brightness == Brightness.dark ? BhavanaColors.dark : BhavanaColors.light;
    return BhavanaTheme(
      colors: colors,
      typography: BhavanaTypography.forColors(colors),
      spacing: BhavanaSpacing.instance,
      radii: BhavanaRadii.instance,
      motion: BhavanaMotion(reduceMotion: reduceMotion),
      child: child,
    );
  }

  /// Prefer this as MaterialApp.builder so tokens track platform brightness
  /// and reduce-motion.
  static Widget builder(BuildContext context, Widget? child) {
    final brightness = Theme.of(context).brightness;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return wrap(
      brightness: brightness,
      reduceMotion: reduce,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
