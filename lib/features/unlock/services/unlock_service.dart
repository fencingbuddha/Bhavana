import 'package:shared_preferences/shared_preferences.dart';

import '../../session/models/track_type.dart';

/// Local unlock flags only — no IAP / SaaS.
class UnlockService {
  UnlockService._();
  static final UnlockService instance = UnlockService._();

  static const _prefix = 'unlock_';

  /// Mind is always available in v1.
  bool isUnlocked(TrackType track) {
    if (track == TrackType.mind) return true;
    return _cache[track.id] ?? false;
  }

  final Map<String, bool> _cache = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final track in TrackType.values) {
      if (track == TrackType.mind) {
        _cache[track.id] = true;
      } else {
        _cache[track.id] = prefs.getBool('$_prefix${track.id}') ?? false;
      }
    }
  }

  /// Stub: flip local flag (dev / future IAP hook). No real purchase.
  Future<void> unlockLocally(TrackType track) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix${track.id}', true);
    _cache[track.id] = true;
  }

  Future<void> lockLocally(TrackType track) async {
    if (track == TrackType.mind) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix${track.id}', false);
    _cache[track.id] = false;
  }
}
