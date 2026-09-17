import 'package:flutter/material.dart';

import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../unlock/services/unlock_service.dart';
import '../models/track_type.dart';

/// Visible locked / coming-soon shell for Body & Flexibility.
/// Unlock is a local stub flag only — no real IAP.
class LockedTrackShell extends StatelessWidget {
  const LockedTrackShell({super.key, required this.track});

  final TrackType track;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(track.label),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg + 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Icon(
              Icons.lock_outline_rounded,
              size: 64,
              color: colors.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: spacing.md + 4),
            Text(
              '${track.label} — coming soon',
              textAlign: TextAlign.center,
              style: typography.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              track.subtitle,
              textAlign: TextAlign.center,
              style: typography.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              'This track is locked in v1. Mind is available now.',
              textAlign: TextAlign.center,
              style: typography.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceMuted.withValues(alpha: 0.9),
              ),
            ),
            const Spacer(),
            BhavanaButton(
              label: 'Unlock locally (stub)',
              variant: BhavanaButtonVariant.secondary,
              onPressed: () async {
                try {
                  await UnlockService.instance.unlockLocally(track);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${track.label} unlocked locally (stub — no IAP).',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Couldn’t unlock locally. Try again.'),
                      ),
                    );
                  }
                }
              },
            ),
            SizedBox(height: spacing.sm),
            BhavanaButton(
              label: 'Back to tracks',
              variant: BhavanaButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: spacing.lg),
          ],
        ),
      ),
    );
  }
}
