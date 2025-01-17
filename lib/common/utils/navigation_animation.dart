
import 'package:flutter/material.dart';

class NoAnimationRoute extends PageRouteBuilder {
  final Widget widget;

  NoAnimationRoute({
    required this.widget})
      : super(
    transitionDuration: const Duration(seconds: 0),
    pageBuilder: (context, anim1, anim2) {
      return widget;
    },
  );
}

class SwipeLeftAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  SwipeLeftAnimationRoute({required this.widget, this.milliseconds = 200})
      : super(
    transitionDuration: Duration(
      milliseconds: milliseconds,
    ),
    pageBuilder: (context, anim1, anim2) => widget,
    transitionsBuilder: (context, anim1, anim2, child) {
      var begin = const Offset(1, 0);
      var end = const Offset(0, 0);
      var tween = Tween<Offset>(begin: begin, end: end);
      var offsetAnimation = anim1.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class SwipeRightAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  SwipeRightAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
    transitionDuration: Duration(
      milliseconds: milliseconds,
    ),
    pageBuilder: (context, anim1, anim2) => widget,
    transitionsBuilder: (context, anim1, anim2, child) {
      var begin = const Offset(-1, 0);
      var end = const Offset(0, 0);
      var tween = Tween<Offset>(begin: begin, end: end);
      var offsetAnimation = anim1.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class SwipeUpAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  SwipeUpAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
    transitionDuration: Duration(
      milliseconds: milliseconds,
    ),
    pageBuilder: (context, anim1, anim2) => widget,
    transitionsBuilder: (context, anim1, anim2, child) {
      var begin = const Offset(0, 1);
      var end = const Offset(0, 0);
      var tween = Tween<Offset>(begin: begin, end: end);
      var offsetAnimation = anim1.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class FadeAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  FadeAnimationRoute({
    required this.widget,
    this.milliseconds = 200,
  }) : super(
    transitionDuration: Duration(
      milliseconds: milliseconds,
    ),
    pageBuilder: (context, anim1, anim2) => widget,
    transitionsBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: child,
      );
    },
  );
}