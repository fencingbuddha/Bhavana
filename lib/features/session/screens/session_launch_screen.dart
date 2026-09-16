import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../models/session_config.dart';
import '../models/track_type.dart';
import '../services/capacity_service.dart';
import 'session_player_screen.dart';

class SessionLaunchScreen extends StatefulWidget {
  const SessionLaunchScreen({super.key, required this.track});

  final TrackType track;

  @override
  State<SessionLaunchScreen> createState() => _SessionLaunchScreenState();
}

class _SessionLaunchScreenState extends State<SessionLaunchScreen> {
  bool _loading = true;
  int _capacityMiddle = AppConstants.defaultMiddleMinutes;
  int _suggestedMiddle = AppConstants.defaultMiddleMinutes;
  bool _hasHistory = false;
  int? _optionalBudget; // total minutes for this session only

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final snap = await CapacityService.instance.snapshot(widget.track);
    if (!mounted) return;
    setState(() {
      _capacityMiddle = snap['capacityMiddle'] as int;
      _suggestedMiddle = snap['suggestedNextMiddle'] as int;
      _hasHistory = snap['hasHistory'] as bool;
      _loading = false;
    });
  }

  Future<int> _resolvedMiddle() {
    return CapacityService.instance.resolveMiddleMinutes(
      track: widget.track,
      optionalTotalBudgetMinutes: _optionalBudget,
    );
  }

  Future<void> _begin() async {
    final middle = await _resolvedMiddle();
    if (!mounted) return;
    final config = SessionConfig(
      track: widget.track,
      startMinutes: AppConstants.startPhaseMinutes,
      middleMinutes: middle,
      endMinutes: AppConstants.endPhaseMinutes,
      optionalTimeCapMinutes: _optionalBudget,
    );
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionPlayerScreen(config: config),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.track.label} session')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Flow',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        letterSpacing: 1.1,
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                _FlowPreview(
                  start: AppConstants.startPhaseMinutes,
                  middle: _optionalBudget == null
                      ? _suggestedMiddle
                      : (_optionalBudget! -
                              AppConstants.startPhaseMinutes -
                              AppConstants.endPhaseMinutes)
                          .clamp(1, _suggestedMiddle),
                  end: AppConstants.endPhaseMinutes,
                ),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capacity',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hasHistory
                              ? 'Last completed middle: $_capacityMiddle min.\n'
                                  'This session’s middle grows to $_suggestedMiddle min '
                                  '(+${AppConstants.capacityStepMinutes}).'
                              : 'Starting middle: $_suggestedMiddle min.\n'
                                  'After you finish, capacity becomes that middle; '
                                  'the next session grows by +${AppConstants.capacityStepMinutes} min.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurface.withValues(alpha: 0.7),
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bookends stay fixed: arrival/breath → middle → cool-down/close. '
                          'Capacity updates only when you complete the middle you take.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurface.withValues(alpha: 0.5),
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'I have X minutes (optional)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Caps this session only. Does not raise capacity unless you finish.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('No cap'),
                      selected: _optionalBudget == null,
                      onSelected: (_) => setState(() => _optionalBudget = null),
                    ),
                    for (final m in AppConstants.optionalTimeBudgets)
                      ChoiceChip(
                        label: Text('$m min'),
                        selected: _optionalBudget == m,
                        onSelected: (_) => setState(() => _optionalBudget = m),
                      ),
                  ],
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: _begin,
                  child: const Text('Begin'),
                ),
              ],
            ),
    );
  }
}

class _FlowPreview extends StatelessWidget {
  const _FlowPreview({
    required this.start,
    required this.middle,
    required this.end,
  });

  final int start;
  final int middle;
  final int end;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget phase(String label, String hint, int minutes) {
      return Expanded(
        child: Column(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            Text(hint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.5),
                    )),
            Text('${minutes}m',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    )),
          ],
        ),
      );
    }

    return Row(
      children: [
        phase('Start', 'Arrival / breath', start),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.water_rounded,
              size: 18, color: scheme.primary.withValues(alpha: 0.4)),
        ),
        phase('Middle', 'Practice', middle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.water_rounded,
              size: 18, color: scheme.primary.withValues(alpha: 0.4)),
        ),
        phase('End', 'Cool-down / close', end),
      ],
    );
  }
}
