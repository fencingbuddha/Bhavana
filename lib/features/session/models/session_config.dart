import 'track_type.dart';

enum SessionPhase { start, middle, end, complete }

/// Configuration for a single guided session.
class SessionConfig {
  const SessionConfig({
    required this.track,
    required this.startMinutes,
    required this.middleMinutes,
    required this.endMinutes,
    this.optionalTimeCapMinutes,
  });

  final TrackType track;
  final int startMinutes;
  final int middleMinutes;
  final int endMinutes;

  /// If set, this launch was capped by "I have X minutes".
  final int? optionalTimeCapMinutes;

  int get totalMinutes => startMinutes + middleMinutes + endMinutes;

  Duration durationFor(SessionPhase phase) {
    switch (phase) {
      case SessionPhase.start:
        return Duration(minutes: startMinutes);
      case SessionPhase.middle:
        return Duration(minutes: middleMinutes);
      case SessionPhase.end:
        return Duration(minutes: endMinutes);
      case SessionPhase.complete:
        return Duration.zero;
    }
  }
}
