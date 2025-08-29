import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/utils/navigation_animation.dart';
import 'package:word_toob/src/views/screens/main_dashboard/main_dashboard.dart';
import 'package:word_toob/src/views/screens/video/video_player.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log("Route -> ${settings.name}");
    final args = settings.arguments;

    switch (settings.name) {
      case RouteStrings.mainDashboardView:
        return MaterialPageRoute(
          builder: (_) => const MainDashboard(),
        );

      case RouteStrings.videoPlayer:
        return SwipeLeftAnimationRoute(
          widget: VideoPlayerView(url: args as String),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      ),
    );
  }
}
