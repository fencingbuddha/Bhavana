import 'package:flutter/material.dart';

import 'tokens_color.dart';
import 'tokens_motion.dart';
import 'tokens_radius.dart';
import 'tokens_spacing.dart';
import 'tokens_typography.dart';

/// Access point for all Bhāvanā design tokens. Dev may only use these.
class BhavanaTheme extends InheritedWidget {
  const BhavanaTheme({
    super.key,
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.motion,
    required super.child,
  });

  final BhavanaColors colors;
  final BhavanaTypography typography;
  final BhavanaSpacing spacing;
  final BhavanaRadii radii;
  final BhavanaMotion motion;

  static BhavanaTheme of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<BhavanaTheme>();
    assert(
      theme != null,
      'No BhavanaTheme in context. Use AppTheme.wrap or MaterialApp builder.',
    );
    return theme!;
  }

  static BhavanaTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BhavanaTheme>();
  }

  static BhavanaColors colorsOf(BuildContext context) => of(context).colors;
  static BhavanaTypography typographyOf(BuildContext context) =>
      of(context).typography;
  static BhavanaSpacing spacingOf(BuildContext context) => of(context).spacing;
  static BhavanaRadii radiiOf(BuildContext context) => of(context).radii;
  static BhavanaMotion motionOf(BuildContext context) => of(context).motion;

  @override
  bool updateShouldNotify(BhavanaTheme oldWidget) {
    return colors != oldWidget.colors ||
        typography != oldWidget.typography ||
        motion.reduceMotion != oldWidget.motion.reduceMotion;
  }
}
