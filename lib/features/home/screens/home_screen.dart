import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
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
    await UnlockService.instance.load();
    if (mounted) setState(() => _ready = true);
  }

  void _openTrack(TrackType track) {
    final unlocked = UnlockService.instance.isUnlocked(track);
    if (!unlocked) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LockedTrackShell(track: track),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SessionLaunchScreen(track: track),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: !_ready
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Guided mind-body training.\nMove like water — continuous, quiet, unbroken.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: scheme.onSurface.withValues(alpha: 0.65),
                                  height: 1.4,
                                ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Tracks',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  letterSpacing: 1.2,
                                  color: scheme.primary.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        for (final track in TrackType.values) ...[
                          TrackCard(
                            track: track,
                            unlocked:
                                UnlockService.instance.isUnlocked(track),
                            onTap: () => _openTrack(track),
                          ),
                          const SizedBox(height: 12),
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
