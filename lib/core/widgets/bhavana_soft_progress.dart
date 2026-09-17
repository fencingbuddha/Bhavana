import 'package:flutter/material.dart';

import '../theme/bhavana_theme.dart';

/// Soft circular progress — replaces stock Material spinner look.
class BhavanaSoftProgress extends StatelessWidget {
  const BhavanaSoftProgress({
    super.key,
    this.size = 28,
    this.strokeWidth = 2.5,
  });

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: colors.progress,
        backgroundColor: colors.progressTrack,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
