import 'package:flutter/material.dart';

import '../../session/models/track_type.dart';
import '../services/practice_log_service.dart';

class PracticeLogScreen extends StatefulWidget {
  const PracticeLogScreen({super.key});

  @override
  State<PracticeLogScreen> createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {
  late Future<List<PracticeEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = PracticeLogService.instance.getEntries();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = PracticeLogService.instance.getEntries();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice log',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Quiet local history. Nothing leaves this device.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.55),
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  final entries = snap.data ?? [];
                  if (entries.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No sessions yet.\nComplete a Mind practice to begin.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: scheme.onSurface
                                        .withValues(alpha: 0.5),
                                    height: 1.45,
                                  ),
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: entries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final e = entries[i];
                        final when = _formatWhen(e.completedAt);
                        final track = e.track?.label ?? e.trackId;
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            title: Text(
                              track,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              '$when · middle ${e.middleMinutes}m · total ${e.totalMinutes}m'
                              '${e.optionalCap != null ? ' · capped ${e.optionalCap}m' : ''}',
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  scheme.primary.withValues(alpha: 0.12),
                              child: Icon(
                                Icons.water_drop_outlined,
                                color: scheme.primary,
                                size: 20,
                              ),
                            ),
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
