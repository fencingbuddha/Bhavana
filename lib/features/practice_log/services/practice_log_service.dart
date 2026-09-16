import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../session/models/track_type.dart';

class PracticeEntry {
  PracticeEntry({
    required this.trackId,
    required this.completedAt,
    required this.middleMinutes,
    required this.totalMinutes,
    this.optionalCap,
  });

  final String trackId;
  final DateTime completedAt;
  final int middleMinutes;
  final int totalMinutes;
  final int? optionalCap;

  Map<String, dynamic> toJson() => {
        'trackId': trackId,
        'completedAt': completedAt.toIso8601String(),
        'middleMinutes': middleMinutes,
        'totalMinutes': totalMinutes,
        'optionalCap': optionalCap,
      };

  factory PracticeEntry.fromJson(Map<String, dynamic> json) {
    return PracticeEntry(
      trackId: json['trackId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      middleMinutes: json['middleMinutes'] as int,
      totalMinutes: json['totalMinutes'] as int,
      optionalCap: json['optionalCap'] as int?,
    );
  }

  TrackType? get track {
    try {
      return TrackType.values.byName(trackId);
    } catch (_) {
      return null;
    }
  }
}

/// Quiet local practice log via shared_preferences.
class PracticeLogService {
  PracticeLogService._();
  static final PracticeLogService instance = PracticeLogService._();

  static const _key = 'practice_log_entries';

  Future<List<PracticeEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => PracticeEntry.fromJson(
              jsonDecode(s) as Map<String, dynamic>,
            ))
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  Future<void> addEntry(PracticeEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_key, raw);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
