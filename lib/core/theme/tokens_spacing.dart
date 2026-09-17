import 'package:flutter/foundation.dart';

/// Spacing scale — use these instead of raw EdgeInsets numbers.
@immutable
class BhavanaSpacing {
  const BhavanaSpacing();

  static const BhavanaSpacing instance = BhavanaSpacing();

  double get xxs => 4;
  double get xs => 8;
  double get sm => 12;
  double get md => 16;
  double get lg => 24;
  double get xl => 32;
  double get xxl => 48;

  /// Minimum tap target (pt).
  double get tapTarget => 44;
}
