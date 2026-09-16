import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../models/track_type.dart';

/// Capacity = last *completed* session's middle duration.
/// Next middle = that length + small step; no hard ceiling.
/// Optional "I have X minutes" only caps *this* session; capacity updates
/// only if the practitioner finishes the middle they took.
class CapacityService {
  CapacityService._();
  static final CapacityService instance = CapacityService._();

  static String _key(TrackType track) => 'capacity_middle_${track.id}';

  Future<int> getCapacityMiddleMinutes(TrackType track) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key(track)) ?? AppConstants.defaultMiddleMinutes;
  }

  /// Suggested middle for the next session (capacity + step).
  Future<int> suggestedNextMiddleMinutes(TrackType track) async {
    final current = await getCapacityMiddleMinutes(track);
    return current + AppConstants.capacityStepMinutes;
  }

  /// Build middle minutes for this launch.
  /// If [optionalTotalBudgetMinutes] is set, middle =
  /// max(1, budget - start - end), capped at suggested next (or capacity).
  Future<int> resolveMiddleMinutes({
    required TrackType track,
    int? optionalTotalBudgetMinutes,
  }) async {
    // Growth happens after completing; at launch we use default (no history)
    // or last completed middle + step. Optional budget caps this session only.
    final nextMiddle = !(await _hasHistory(track))
        ? AppConstants.defaultMiddleMinutes
        : await suggestedNextMiddleMinutes(track);

    if (optionalTotalBudgetMinutes == null) {
      return nextMiddle;
    }

    final bookends =
        AppConstants.startPhaseMinutes + AppConstants.endPhaseMinutes;
    final room = optionalTotalBudgetMinutes - bookends;
    if (room < 1) return 1;
    // Cap *this* session only — do not raise stored capacity here.
    return room < nextMiddle ? room : nextMiddle;
  }

  Future<bool> _hasHistory(TrackType track) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key(track));
  }

  /// Call only when the middle phase was finished (session completed through end).
  Future<void> recordCompletedMiddle({
    required TrackType track,
    required int middleMinutesTaken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key(track), middleMinutesTaken);
  }

  Future<Map<String, dynamic>> snapshot(TrackType track) async {
    final capacity = await getCapacityMiddleMinutes(track);
    final hasHistory = await _hasHistory(track);
    final next = hasHistory
        ? capacity + AppConstants.capacityStepMinutes
        : AppConstants.defaultMiddleMinutes;
    return {
      'capacityMiddle': capacity,
      'hasHistory': hasHistory,
      'suggestedNextMiddle': next,
    };
  }
}
