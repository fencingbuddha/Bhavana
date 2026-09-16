import 'package:flutter/material.dart';

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
  });

  final SessionPhase phase;
  final String trackLabel;
  final Duration remaining;
  final Duration totalForPhase;
  final VoidCallback onContinue;
  final VoidCallback onLeave;

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
    final scheme = Theme.of(context).colorScheme;
    final progress = totalForPhase.inSeconds == 0
        ? 0.0
        : 1.0 -
            (remaining.inSeconds.clamp(0, totalForPhase.inSeconds) /
                totalForPhase.inSeconds);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                trackLabel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.primary.withValues(alpha: 0.7),
                      letterSpacing: 0.8,
                    ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Leave',
                onPressed: onLeave,
                icon: Icon(
                  Icons.close_rounded,
                  color: scheme.onSurface.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            _guidance,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: scheme.onSurface.withValues(alpha: 0.65),
                ),
          ),
          const Spacer(),
          // Soft elapsed feel — a thin water line, not a dashboard.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: scheme.primary.withValues(alpha: 0.1),
              color: scheme.primary.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _fmt(remaining),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface.withValues(alpha: 0.55),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
          const Spacer(flex: 2),
          // Scaffold affordance: advance without waiting full wall-clock.
          OutlinedButton(
            onPressed: onContinue,
            child: Text(
              phase == SessionPhase.end ? 'Finish' : 'Continue',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            phase == SessionPhase.start
                ? 'Start · arrival / breath'
                : phase == SessionPhase.middle
                    ? 'Middle · guided practice'
                    : 'End · cool-down / close',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.4),
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
