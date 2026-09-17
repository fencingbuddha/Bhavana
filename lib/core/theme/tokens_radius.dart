import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Corner radius scale — soft water edges.
@immutable
class BhavanaRadii {
  const BhavanaRadii();

  static const BhavanaRadii instance = BhavanaRadii();

  double get sm => 12;
  double get md => 16;
  double get lg => 20;
  double get pill => 28;
  double get full => 999;

  BorderRadius get card => BorderRadius.circular(lg);
  BorderRadius get button => BorderRadius.circular(pill);
  BorderRadius get chip => BorderRadius.circular(pill);
  BorderRadius get dialog => BorderRadius.circular(md);
}
