import 'package:flutter/material.dart';

/// Custom page route with no animation
class NoAnimationRoute extends PageRouteBuilder {
  final Widget widget;

  NoAnimationRoute({required this.widget})
      : super(
          transitionDuration: const Duration(seconds: 0),
          pageBuilder: (context, anim1, anim2) => widget,
        );
}

/// Custom page route with swipe left animation
class SwipeLeftAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;

  SwipeLeftAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
          transitionDuration: Duration(milliseconds: milliseconds),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            const begin = Offset(1, 0);
            const end = Offset(0, 0);
            final tween = Tween<Offset>(begin: begin, end: end);
            final offsetAnimation = anim1.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

/// Custom page route with swipe right animation
class SwipeRightAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;

  SwipeRightAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
          transitionDuration: Duration(milliseconds: milliseconds),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            const begin = Offset(-1, 0);
            const end = Offset(0, 0);
            final tween = Tween<Offset>(begin: begin, end: end);
            final offsetAnimation = anim1.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

/// Custom page route with swipe up animation
class SwipeUpAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;

  SwipeUpAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
          transitionDuration: Duration(milliseconds: milliseconds),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            const begin = Offset(0, 1);
            const end = Offset(0, 0);
            final tween = Tween<Offset>(begin: begin, end: end);
            final offsetAnimation = anim1.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

/// Custom page route with fade animation
class FadeAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;

  FadeAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
          transitionDuration: Duration(milliseconds: milliseconds),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              opacity: anim1,
              child: child,
            );
          },
        );
}
