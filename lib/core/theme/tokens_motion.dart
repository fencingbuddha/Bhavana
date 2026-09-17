import 'package:flutter/material.dart';

/// Soft motion only — fades and gentle curves. No bounce / springs.
@immutable
class BhavanaMotion {
  const BhavanaMotion({this.reduceMotion = false});

  final bool reduceMotion;

  static const Curve soft = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;

  Duration get instant => Duration.zero;
  Duration get fast =>
      reduceMotion ? Duration.zero : const Duration(milliseconds: 160);
  Duration get normal =>
      reduceMotion ? Duration.zero : const Duration(milliseconds: 280);
  Duration get slow =>
      reduceMotion ? Duration.zero : const Duration(milliseconds: 420);

  Curve get curve => reduceMotion ? Curves.linear : soft;

  /// Prefer [MediaQuery.disableAnimationsOf]; falls back to false.
  factory BhavanaMotion.of(BuildContext context) {
    return BhavanaMotion(
      reduceMotion: MediaQuery.disableAnimationsOf(context),
    );
  }

  BhavanaMotion copyWith({bool? reduceMotion}) {
    return BhavanaMotion(reduceMotion: reduceMotion ?? this.reduceMotion);
  }
}
