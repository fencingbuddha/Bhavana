import 'package:flutter/material.dart';

import '../theme/bhavana_theme.dart';

/// Thin 4pt in-session progress line (UX §6.4).
class BhavanaProgressLine extends StatelessWidget {
  const BhavanaProgressLine({
    super.key,
    required this.value,
    this.height = 4,
  });

  /// 0..1
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final radii = BhavanaTheme.radiiOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radii.full),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        color: colors.progress,
        backgroundColor: colors.progressTrack,
      ),
    );
  }
}
