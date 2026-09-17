import 'package:flutter/material.dart';

import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/models/track_type.dart';
import '../services/practice_log_service.dart';

class PracticeLogScreen extends StatefulWidget {
  const PracticeLogScreen({super.key, this.focusGeneration = 0});

  /// When this changes (Log tab focused), entries reload.
  final int focusGeneration;

  @override
  State<PracticeLogScreen> createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {
  late Future<List<PracticeEntry>> _future;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    PracticeLogService.instance.revision.addListener(_onLogRevision);
    _reload();
  }

  @override
  void dispose() {
    PracticeLogService.instance.revision.removeListener(_onLogRevision);
    super.dispose();
  }

  void _onLogRevision() {
    if (mounted) _reload();
  }

  @override
  void didUpdateWidget(covariant PracticeLogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusGeneration != widget.focusGeneration) {
      _reload();
    }
  }

  void _reload() {
    setState(() {
      _loadError = null;
      _future = _fetch();
    });
  }

  Future<List<PracticeEntry>> _fetch() async {
    try {
      final entries = await PracticeLogService.instance.getEntries();
      if (mounted) setState(() => _loadError = null);
      return entries;
    } catch (e) {
      if (mounted) setState(() => _loadError = e);
      rethrow;
    }
  }

  Future<void> _refresh() async {
    _reload();
    try {
      await _future;
    } catch (_) {
      // Error surfaced via FutureBuilder / _loadError.
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.lg + 4,
                spacing.lg,
                spacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice log',
                    style: typography.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  SizedBox(height: spacing.xxs + 2),
                  Text(
                    'Quiet local history. Nothing leaves this device.',
                    style: typography.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PracticeEntry>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: BhavanaSoftProgress());
                  }

                  if (snap.hasError || _loadError != null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'No sessions yet.\nComplete a Mind practice to begin.',
                              textAlign: TextAlign.center,
                              style: typography.textTheme.bodyLarge?.copyWith(
                                color: colors.onSurfaceMuted,
                                height: 1.45,
                              ),
                            ),
                            SizedBox(height: spacing.md),
                            Text(
                              'Couldn’t load log',
                              textAlign: TextAlign.center,
                              style: typography.textTheme.bodyMedium?.copyWith(
                                color: colors.destructiveQuiet,
                              ),
                            ),
                            SizedBox(height: spacing.sm),
                            BhavanaButton(
                              label: 'Retry',
                              variant: BhavanaButtonVariant.secondary,
                              expanded: false,
                              onPressed: _refresh,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final entries = snap.data ?? [];
                  if (entries.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.xl),
                        child: Text(
                          'No sessions yet.\nComplete a Mind practice to begin.',
                          textAlign: TextAlign.center,
                          style: typography.textTheme.bodyLarge?.copyWith(
                            color: colors.onSurfaceMuted,
                            height: 1.45,
                          ),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: colors.progress,
                    backgroundColor: colors.surfaceRaised,
                    onRefresh: _refresh,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        spacing.md + 4,
                        spacing.xs,
                        spacing.md + 4,
                        spacing.lg,
                      ),
                      itemCount: entries.length,
                      separatorBuilder: (context, index) => SizedBox(height: spacing.sm - 2),
                      itemBuilder: (context, i) {
                        final e = entries[i];
                        final when = _formatWhen(e.completedAt);
                        final track = e.track?.label ?? e.trackId;
                        return BhavanaCard(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.md + 2,
                            vertical: spacing.sm,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.water_drop_outlined,
                                  color: colors.primary,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: spacing.sm + 2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      track,
                                      style: typography.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: spacing.xxs),
                                    Text(
                                      '$when · middle ${e.middleMinutes}m · total ${e.totalMinutes}m'
                                      '${e.optionalCap != null ? ' · capped ${e.optionalCap}m' : ''}',
                                      style: typography.textTheme.bodySmall
                                          ?.copyWith(
                                        color: colors.onSurfaceMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWhen(DateTime dt) {
    final local = dt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
