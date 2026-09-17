import 'package:flutter/material.dart';

import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/session_config.dart';

/// Soft, continuous phase UI — no metrics dashboard mid-practice.
class PhaseView extends StatelessWidget {
  const PhaseView({
    super.key,
    required this.phase,
    required this.trackLabel,
    required this.remaining,
    required this.totalForPhase,
    required this.onContinue,
    required this.onLeave,
    this.continueEnabled = true,
  });

  final SessionPhase phase;
  final String trackLabel;
  final Duration remaining;
  final Duration totalForPhase;
  final VoidCallback onContinue;
  final VoidCallback onLeave;
  final bool continueEnabled;

  String get _title {
    switch (phase) {
      case SessionPhase.start:
        return 'Arrival';
      case SessionPhase.middle:
        return 'Practice';
      case SessionPhase.end:
        return 'Closing';
      case SessionPhase.complete:
        return 'Complete';
    }
  }

  String get _guidance {
    switch (phase) {
      case SessionPhase.start:
        return 'Settle. Soften the breath. Let attention arrive without force.';
      case SessionPhase.middle:
        return 'Stay with the mind-track guidance. Continuous, unhurried presence.';
      case SessionPhase.end:
        return 'Cool down. Close gently. Carry the quiet with you.';
      case SessionPhase.complete:
        return '';
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);
    final progress = totalForPhase.inSeconds == 0
        ? 0.0
        : 1.0 -
            (remaining.inSeconds.clamp(0, totalForPhase.inSeconds) /
                totalForPhase.inSeconds);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg + 4,
        vertical: spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                trackLabel,
                style: typography.textTheme.labelLarge?.copyWith(
                  color: colors.primary.withValues(alpha: 0.75),
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Leave',
                onPressed: onLeave,
                icon: Icon(
                  Icons.close_rounded,
                  color: colors.onSurfaceMuted.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: typography.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            _guidance,
            textAlign: TextAlign.center,
            style: typography.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: colors.onSurfaceMuted,
            ),
          ),
          const Spacer(),
          BhavanaProgressLine(value: progress.clamp(0.0, 1.0)),
          SizedBox(height: spacing.md),
          Text(
            _fmt(remaining),
            textAlign: TextAlign.center,
            style: typography.timer.copyWith(
              fontSize: typography.textTheme.titleLarge?.fontSize,
              color: colors.onSurfaceMuted,
            ),
          ),
          const Spacer(flex: 2),
          BhavanaButton(
            label: phase == SessionPhase.end ? 'Finish' : 'Continue',
            variant: BhavanaButtonVariant.secondary,
            onPressed: continueEnabled ? onContinue : null,
          ),
          SizedBox(height: spacing.sm),
          Text(
            phase == SessionPhase.start
                ? 'Start · arrival / breath'
                : phase == SessionPhase.middle
                    ? 'Middle · guided practice'
                    : 'End · cool-down / close',
            textAlign: TextAlign.center,
            style: typography.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceMuted.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: spacing.xs),
        ],
      ),
    );
  }
}
