/// App-wide timing and capacity defaults for Bhāvanā.
class AppConstants {
  AppConstants._();

  static const String appName = 'Bhāvanā';
  static const String appSlug = 'bhavana';

  /// Fixed bookend durations (minutes).
  static const int startPhaseMinutes = 3;
  static const int endPhaseMinutes = 3;

  /// Default middle duration when no capacity history exists (minutes).
  static const int defaultMiddleMinutes = 10;

  /// Capacity grows by this many minutes after each completed middle.
  static const int capacityStepMinutes = 3;

  /// Optional session-time presets offered at launch (minutes for whole session
  /// budget; middle is derived after bookends).
  static const List<int> optionalTimeBudgets = [15, 20, 30, 45];
}
