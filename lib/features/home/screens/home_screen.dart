import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/soft_page_route.dart';
import '../../../core/theme/bhavana_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/models/track_type.dart';
import '../../session/screens/session_launch_screen.dart';
import '../../session/widgets/locked_track_shell.dart';
import '../../unlock/services/unlock_service.dart';
import '../widgets/track_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await UnlockService.instance.load();
    } catch (_) {
      // Spec: if unlock store fails, treat Mind unlocked / others locked.
    }
    if (mounted) setState(() => _ready = true);
  }

  void _openTrack(TrackType track) {
    final unlocked = UnlockService.instance.isUnlocked(track);
    if (!unlocked) {
      Navigator.of(context).push(
        softRoute(context, (_) => LockedTrackShell(track: track)),
      );
      return;
    }
    Navigator.of(context).push(
      softRoute(context, (_) => SessionLaunchScreen(track: track)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);
    final spacing = BhavanaTheme.spacingOf(context);
    final typography = BhavanaTheme.typographyOf(context);

    return Scaffold(
      body: SafeArea(
        child: !_ready
            ? const Center(child: BhavanaSoftProgress())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing.lg,
                        spacing.xl,
                        spacing.lg,
                        spacing.xs,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: typography.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(height: spacing.xs),
                          Text(
                            'Guided mind-body training.\nMove like water — continuous, quiet, unbroken.',
                            style: typography.textTheme.bodyLarge?.copyWith(
                              color: colors.onSurfaceMuted,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: spacing.lg + spacing.xs),
                          Text(
                            'Tracks',
                            style: typography.textTheme.titleSmall?.copyWith(
                              letterSpacing: 1.2,
                              color: colors.primary.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.md + 4,
                      vertical: spacing.xs,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        for (final track in TrackType.values) ...[
                          TrackCard(
                            track: track,
                            unlocked:
                                UnlockService.instance.isUnlocked(track),
                            onTap: () => _openTrack(track),
                          ),
                          SizedBox(height: spacing.sm),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
