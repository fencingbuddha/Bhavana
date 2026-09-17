import 'package:flutter/material.dart';

import '../theme/bhavana_theme.dart';

enum BhavanaButtonVariant { primary, secondary, destructiveQuiet }

/// Token-only buttons. Prefer these over raw FilledButton / TextButton.
class BhavanaButton extends StatelessWidget {
  const BhavanaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BhavanaButtonVariant.primary,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final BhavanaButtonVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final radii = BhavanaTheme.radiiOf(context);
    final spacing = BhavanaTheme.spacingOf(context);

    final Color bg;
    final Color fg;
    final BorderSide? side;

    switch (variant) {
      case BhavanaButtonVariant.primary:
        bg = colors.primaryFill;
        fg = colors.onPrimaryFill;
        side = null;
      case BhavanaButtonVariant.secondary:
        bg = Colors.transparent;
        fg = colors.primary;
        side = BorderSide(color: colors.border);
      case BhavanaButtonVariant.destructiveQuiet:
        bg = Colors.transparent;
        fg = colors.destructiveQuiet;
        side = BorderSide(color: colors.destructiveQuiet.withValues(alpha: 0.45));
    }

    final child = Text(label);
    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(bg),
      foregroundColor: WidgetStatePropertyAll(fg),
      minimumSize: WidgetStatePropertyAll(
        Size(expanded ? double.infinity : spacing.tapTarget * 2, spacing.tapTarget),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.sm),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: radii.button),
      ),
      side: WidgetStatePropertyAll(side),
      elevation: const WidgetStatePropertyAll(0),
      splashFactory: InkRipple.splashFactory,
    );

    return TextButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}
