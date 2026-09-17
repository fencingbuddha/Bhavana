import 'package:flutter/material.dart';

import '../theme/bhavana_theme.dart';
import '../theme/tokens_motion.dart';

/// Soft fade/slide route — zero duration when reduce-motion is on.
Route<T> softRoute<T extends Object?>(
  BuildContext context,
  WidgetBuilder builder,
) {
  final motion =
      BhavanaTheme.maybeOf(context)?.motion ?? BhavanaMotion.of(context);
  final duration = motion.normal;
  final reverse = motion.fast;

  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionDuration: duration,
    reverseTransitionDuration: reverse,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (motion.reduceMotion || duration == Duration.zero) return child;
      final curved = CurvedAnimation(parent: animation, curve: motion.curve);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
