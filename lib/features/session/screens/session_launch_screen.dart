import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/soft_page_route.dart';
import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
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
  bool _starting = false;
  bool _capacityReadFailed = false;
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
    try {
      final snap = await CapacityService.instance.snapshot(widget.track);
      if (!mounted) return;
      setState(() {
        _capacityMiddle = snap['capacityMiddle'] as int;
        _suggestedMiddle = snap['suggestedNextMiddle'] as int;
        _hasHistory = snap['hasHistory'] as bool;
        _capacityReadFailed = false;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _capacityMiddle = AppConstants.defaultMiddleMinutes;
        _suggestedMiddle = AppConstants.defaultMiddleMinutes;
        _hasHistory = false;
        _capacityReadFailed = true;
        _loading = false;
      });
    }
  }

  Future<int> _resolvedMiddle() {
    return CapacityService.instance.resolveMiddleMinutes(
      track: widget.track,
      optionalTotalBudgetMinutes: _optionalBudget,
    );
  }

  Future<void> _begin() async {
    if (_starting) return;
    setState(() => _starting = true);
    try {
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
        softRoute(context, (_) => SessionPlayerScreen(config: config)),
      );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  int get _previewMiddle {
    if (_optionalBudget == null) return _suggestedMiddle;
    return (_optionalBudget! -
            AppConstants.startPhaseMinutes -
            AppConstants.endPhaseMinutes)
        .clamp(1, _suggestedMiddle);
  }

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.track.label} session')),
      body: _loading
          ? const Center(child: BhavanaSoftProgress())
          : ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                Text(
                  'Flow',
                  style: typography.textTheme.titleSmall?.copyWith(
                    letterSpacing: 1.1,
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: spacing.sm),
                _FlowPreview(
                  start: AppConstants.startPhaseMinutes,
                  middle: _previewMiddle,
                  end: AppConstants.endPhaseMinutes,
                ),
                SizedBox(height: spacing.lg + 4),
                BhavanaCard(
                  padding: EdgeInsets.all(spacing.md + 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capacity',
                        style: typography.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.onSurface,
                        ),
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        _hasHistory
                            ? 'Last completed middle: $_capacityMiddle min.\n'
                                'This session’s middle grows to $_suggestedMiddle min '
                                '(+${AppConstants.capacityStepMinutes}).'
                            : 'Starting middle: $_suggestedMiddle min.\n'
                                'After you finish, capacity becomes that middle; '
                                'the next session grows by +${AppConstants.capacityStepMinutes} min.',
                        style: typography.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceMuted,
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        'Bookends stay fixed: arrival/breath → middle → cool-down/close. '
                        'Capacity and log update only when you finish the End phase '
                        '(complete the full session).',
                        style: typography.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceMuted.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                      ),
                      if (_capacityReadFailed) ...[
                        SizedBox(height: spacing.sm),
                        Text(
                          'Using default capacity',
                          style: typography.textTheme.bodySmall?.copyWith(
                            color: colors.destructiveQuiet,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: spacing.lg),
                Text(
                  'I have X minutes (optional)',
                  style: typography.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  'Caps this session only. Does not raise capacity unless you finish End.',
                  style: typography.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Wrap(
                  spacing: spacing.xs,
                  runSpacing: spacing.xs,
                  children: [
                    _CapChip(
                      label: 'No cap',
                      selected: _optionalBudget == null,
                      onSelected: () =>
                          setState(() => _optionalBudget = null),
                    ),
                    for (final m in AppConstants.optionalTimeBudgets)
                      _CapChip(
                        label: '$m min',
                        selected: _optionalBudget == m,
                        onSelected: () => setState(() => _optionalBudget = m),
                      ),
                  ],
                ),
                SizedBox(height: spacing.xxl - 8),
                BhavanaButton(
                  label: 'Begin',
                  onPressed: _starting ? null : _begin,
                ),
              ],
            ),
    );
  }
}

class _CapChip extends StatelessWidget {
  const _CapChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final radii = BhavanaTheme.radiiOf(context);
    final typography = BhavanaTheme.typographyOf(context);
    final motion = BhavanaTheme.motionOf(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        borderRadius: radii.chip,
        child: AnimatedContainer(
          duration: motion.fast,
          curve: motion.curve,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm + 2,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colors.primary.withValues(alpha: 0.18)
                : colors.surfaceSunken,
            borderRadius: radii.chip,
            border: Border.all(
              color: selected
                  ? colors.primary.withValues(alpha: 0.45)
                  : colors.border.withValues(alpha: 0.6),
            ),
          ),
          child: Text(
            label,
            style: typography.textTheme.labelLarge?.copyWith(
              color: selected ? colors.primary : colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);
    final radii = BhavanaTheme.radiiOf(context);

    Widget phase(String label, String hint, int minutes) {
      return Expanded(
        child: Column(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(radii.full),
              ),
            ),
            SizedBox(height: spacing.sm - 2),
            Text(
              label,
              style: typography.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            Text(
              hint,
              style: typography.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
            Text(
              '${minutes}m',
              style: typography.textTheme.bodySmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        phase('Start', 'Arrival / breath', start),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xxs + 2),
          child: Icon(
            Icons.water_rounded,
            size: 18,
            color: colors.primary.withValues(alpha: 0.4),
          ),
        ),
        phase('Middle', 'Practice', middle),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xxs + 2),
          child: Icon(
            Icons.water_rounded,
            size: 18,
            color: colors.primary.withValues(alpha: 0.4),
          ),
        ),
        phase('End', 'Cool-down / close', end),
      ],
    );
  }
}
