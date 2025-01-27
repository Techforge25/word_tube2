import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/utils/navigation_animation.dart';
import 'package:word_toob/src/views/screens/main_dashboard/main_dashboard.dart';
import 'package:word_toob/src/views/widgets/video_thumbnail_fleet.dart';

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
      maxWidth: 2000,
      // background: Container(color: Colors.red),

      child: ResponsiveScaledBox(
        width: ResponsiveValue<double>(context,
            defaultValue: 500,
            conditionalValues: [
              // const Condition.equals(name: MOBILE, value: 1000),
              const Condition.between(start: 400, end: 850, value: 430),
              const Condition.between(start: 850, end: 2000, value: 1200),
            ]).value,
        child:
            BouncingScrollWrapper.builder(context, child, dragWithMouse: true),
      ),
    );
  }
}
