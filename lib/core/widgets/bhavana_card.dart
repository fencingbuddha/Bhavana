import 'package:flutter/material.dart';

import '../theme/bhavana_theme.dart';

/// Quiet raised surface — no Material elevation shadow.
class BhavanaCard extends StatelessWidget {
  const BhavanaCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final radii = BhavanaTheme.radiiOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final motion = BhavanaTheme.motionOf(context);

    final content = AnimatedContainer(
      duration: motion.fast,
      curve: motion.curve,
      padding: padding ?? EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: radii.card,
        border: Border.all(color: colors.border.withValues(alpha: 0.55)),
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.card,
        splashColor: colors.primary.withValues(alpha: 0.1),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: content,
      ),
    );
  }
}
