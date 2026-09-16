import 'dart:async';

import 'package:flutter/material.dart';

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

  // Demo-friendly: use seconds = minutes for faster local testing? No —
  // use real minutes but allow "advance" for scaffold usability.
  // Spec says stub logic OK. We'll use real Duration(minutes) but also
  // provide a gentle "Continue" to move phases without waiting full time.

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
    _timer?.cancel();
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
  }

  Future<void> _completeSession() async {
    if (_finishing) return;
    _finishing = true;
    _timer?.cancel();

    // Capacity updates only if they finish the middle they took.
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

    if (!mounted) return;
    setState(() => _phase = SessionPhase.complete);
  }

  Future<void> _leaveEarly() async {
    _timer?.cancel();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave practice?'),
        content: const Text(
          'Leaving early will not update capacity. '
          'Capacity grows only when you finish the middle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Leave'),
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
        ),
      ),
    );
  }
}

class _CompleteView extends StatelessWidget {
  const _CompleteView({required this.config, required this.onDone});

  final SessionConfig config;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.water_drop_outlined,
                  size: 56, color: scheme.primary.withValues(alpha: 0.7)),
              const SizedBox(height: 20),
              Text(
                'Practice complete',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '${config.track.label} · ${config.totalMinutes} min\n'
                'Middle ${config.middleMinutes} min saved as capacity.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.65),
                      height: 1.45,
                    ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: onDone,
                child: const Text('Return home'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
