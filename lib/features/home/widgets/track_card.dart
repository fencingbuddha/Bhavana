import 'package:flutter/material.dart';

import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/models/track_type.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({
    super.key,
    required this.track,
    required this.unlocked,
    required this.onTap,
  });

  final TrackType track;
  final bool unlocked;
  final VoidCallback onTap;

  IconData get _icon {
    switch (track) {
      case TrackType.mind:
        return Icons.self_improvement_rounded;
      case TrackType.body:
        return Icons.accessibility_new_rounded;
      case TrackType.flexibility:
        return Icons.spa_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);
    final radii = BhavanaTheme.radiiOf(context);

    return BhavanaCard(
      onTap: onTap,
      padding: EdgeInsets.all(spacing.md + 4),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: unlocked ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(radii.md),
            ),
            child: Icon(
              _icon,
              color: unlocked ? colors.primary : colors.onSurfaceMuted,
              size: 28,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      track.label,
                      style: typography.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: unlocked
                            ? colors.onSurface
                            : colors.onSurfaceMuted,
                      ),
                    ),
                    if (!unlocked) ...[
                      SizedBox(width: spacing.xs),
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: colors.onSurfaceMuted,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  unlocked ? track.subtitle : 'Coming soon',
                  style: typography.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: colors.onSurfaceMuted.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
