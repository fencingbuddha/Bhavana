import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../practice_log/services/practice_log_service.dart';
import '../models/session_config.dart';
import '../models/track_type.dart';
import '../services/capacity_service.dart';
import '../widgets/phase_view.dart';

/// Continuous-flow session player: start → middle → end.
/// No mid-practice dashboard or metrics.
class SessionPlayerScreen extends StatefulWidget {
  const SessionPlayerScreen({super.key, required this.config});

  final SessionConfig config;

  @override
  State<SessionPlayerScreen> createState() => _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends State<SessionPlayerScreen> {
  SessionPhase _phase = SessionPhase.start;
  late Duration _remaining;
  Timer? _timer;
  bool _finishing = false;
  bool _advancing = false;
  bool _saveFailed = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.config.durationFor(_phase);
    _startTicker();
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        _advancePhase();
      } else {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _advancePhase() async {
    if (_advancing || _finishing) return;
    _advancing = true;
    _timer?.cancel();
    try {
      if (_phase == SessionPhase.start) {
        setState(() {
          _phase = SessionPhase.middle;
          _remaining = widget.config.durationFor(_phase);
        });
        _startTicker();
      } else if (_phase == SessionPhase.middle) {
        setState(() {
          _phase = SessionPhase.end;
          _remaining = widget.config.durationFor(_phase);
        });
        _startTicker();
      } else if (_phase == SessionPhase.end) {
        await _completeSession();
      }
    } finally {
      _advancing = false;
    }
  }

  Future<void> _completeSession({bool isRetry = false}) async {
    if (_finishing && !isRetry) return;
    _finishing = true;
    _timer?.cancel();

    var failed = false;
    try {
      await CapacityService.instance.recordCompletedMiddle(
        track: widget.config.track,
        middleMinutesTaken: widget.config.middleMinutes,
      );
      await PracticeLogService.instance.addEntry(
        PracticeEntry(
          trackId: widget.config.track.id,
          completedAt: DateTime.now(),
          middleMinutes: widget.config.middleMinutes,
          totalMinutes: widget.config.totalMinutes,
          optionalCap: widget.config.optionalTimeCapMinutes,
        ),
      );
    } catch (_) {
      failed = true;
    }

    if (!mounted) return;
    setState(() {
      _saveFailed = failed;
      _phase = SessionPhase.complete;
      _finishing = false;
    });
  }

  Future<void> _retrySave() => _completeSession(isRetry: true);

  Future<void> _leaveEarly() async {
    _timer?.cancel();
    final colors = BhavanaTheme.colorsOf(context);
    final typography = BhavanaTheme.typographyOf(context);
    final spacing = BhavanaTheme.spacingOf(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Leave practice?',
          style: typography.textTheme.titleLarge,
        ),
        content: Text(
          'Leaving early will not update capacity. '
          'Capacity and log update only when you finish the End phase.',
          style: typography.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceMuted,
            height: 1.4,
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(
          spacing.md,
          0,
          spacing.md,
          spacing.md,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowDirection: VerticalDirection.down,
        actions: [
          SizedBox(
            width: double.infinity,
            child: BhavanaButton(
              label: 'Stay',
              variant: BhavanaButtonVariant.secondary,
              onPressed: () => Navigator.pop(ctx, false),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: BhavanaButton(
              label: 'Leave',
              variant: BhavanaButtonVariant.destructiveQuiet,
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      Navigator.of(context).pop();
    } else if (mounted && _phase != SessionPhase.complete) {
      _startTicker();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == SessionPhase.complete) {
      return _CompleteView(
        config: widget.config,
        saveFailed: _saveFailed,
        onRetrySave: _retrySave,
        onDone: () => Navigator.of(context).popUntil((r) => r.isFirst),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: PhaseView(
          phase: _phase,
          trackLabel: widget.config.track.label,
          remaining: _remaining,
          totalForPhase: widget.config.durationFor(_phase),
          onContinue: _advancePhase,
          onLeave: _leaveEarly,
          continueEnabled: !_advancing && !_finishing,
        ),
      ),
    );
  }
}

class _CompleteView extends StatelessWidget {
  const _CompleteView({
    required this.config,
    required this.saveFailed,
    required this.onRetrySave,
    required this.onDone,
  });

  final SessionConfig config;
  final bool saveFailed;
  final VoidCallback onRetrySave;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.water_drop_outlined,
                size: 56,
                color: colors.primary.withValues(alpha: 0.7),
              ),
              SizedBox(height: spacing.md + 4),
              Text(
                'Practice complete',
                textAlign: TextAlign.center,
                style: typography.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              SizedBox(height: spacing.sm),
              Text(
                saveFailed
                    ? '${config.track.label} · ${config.totalMinutes} min\n'
                        'Middle ${config.middleMinutes} min — not saved yet.'
                    : '${config.track.label} · ${config.totalMinutes} min\n'
                        'Middle ${config.middleMinutes} min saved as capacity.',
                textAlign: TextAlign.center,
                style: typography.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceMuted,
                  height: 1.45,
                ),
              ),
              if (saveFailed) ...[
                SizedBox(height: spacing.md),
                Text(
                  'Couldn’t save locally — try again, or refresh from Log later.',
                  textAlign: TextAlign.center,
                  style: typography.textTheme.bodyMedium?.copyWith(
                    color: colors.destructiveQuiet,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: spacing.sm),
                BhavanaButton(
                  label: 'Retry save',
                  variant: BhavanaButtonVariant.secondary,
                  onPressed: onRetrySave,
                ),
              ],
              const Spacer(),
              BhavanaButton(
                label: 'Return home',
                onPressed: onDone,
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
