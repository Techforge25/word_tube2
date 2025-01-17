import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:word_toob/common/app_constants/route_strings.dart';
import 'package:word_toob/common/utils/navigation_animation.dart';
import 'package:word_toob/views/screens/main_dashboard.dart';
import 'package:word_toob/views/widgets/video_thumbnail_fleet.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log("Route -> ${settings.name}");
    final args = settings.arguments;
    switch (settings.name) {
      case RouteStrings.mainDashboardView:
        return MaterialPageRoute(
            builder: (_) => const ResponsiveWrap(child: MainDashboard()));
      case RouteStrings.videoPlayer:
        return SwipeLeftAnimationRoute(
            widget:
                ResponsiveWrap(child: VideoPlayerView(url: args as String)));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class ResponsiveWrap extends StatelessWidget {
  final Widget child;
  const ResponsiveWrap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1200,
      //background: Container(color: Colors.red),
      child: ResponsiveScaledBox(
        width: ResponsiveValue<double>(context,
            defaultValue: 450,
            conditionalValues: [
              const Condition.equals(name: MOBILE, value: 450),
              const Condition.between(start: 800, end: 1100, value: 830),
              const Condition.between(start: 1000, end: 1200, value: 1030),
            ]).value,
        child:
            BouncingScrollWrapper.builder(context, child, dragWithMouse: true),
      ),
    );
  }
}
