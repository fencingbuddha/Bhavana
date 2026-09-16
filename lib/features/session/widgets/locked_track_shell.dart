import 'package:flutter/material.dart';

import '../models/track_type.dart';
import '../../unlock/services/unlock_service.dart';

/// Visible locked / coming-soon shell for Body & Flexibility.
/// Unlock is a local stub flag only — no real IAP.
class LockedTrackShell extends StatelessWidget {
  const LockedTrackShell({super.key, required this.track});

  final TrackType track;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(track.label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Icon(
              Icons.lock_outline_rounded,
              size: 64,
              color: scheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 20),
            Text(
              '${track.label} — coming soon',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              track.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This track is locked in v1. Mind is available now.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.45),
                  ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () async {
                // Dev stub: local unlock flag only.
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
              },
              child: const Text('Unlock locally (stub)'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to tracks'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
