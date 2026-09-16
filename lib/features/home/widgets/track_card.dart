import 'package:flutter/material.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: unlocked ? 0.12 : 0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _icon,
                  color: unlocked
                      ? scheme.primary
                      : scheme.onSurface.withValues(alpha: 0.35),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          track.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: unlocked
                                    ? null
                                    : scheme.onSurface.withValues(alpha: 0.45),
                              ),
                        ),
                        if (!unlocked) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 16,
                            color: scheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unlocked ? track.subtitle : 'Coming soon',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.55),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
