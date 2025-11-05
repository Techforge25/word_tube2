import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/utils/navigation_animation.dart';
import 'package:word_toob/src/views/screens/splash_screen.dart';
import 'package:word_toob/src/views/screens/main_dashboard/main_dashboard.dart'
    hide SharedBoardPreviewScreen;
import 'package:word_toob/src/views/screens/video/video_player.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'dart:developer' as dev;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log("Route -> ${settings.name}");

    if (settings.name != null && settings.name!.endsWith('.wtdata')) {
      print('From Logs Router ${settings.name}');
      return MaterialPageRoute(
        builder: (_) => BoardLoaderScreen(filePath: settings.name!),
      );
    } else {
      final args = settings.arguments;
      switch (settings.name) {
        case RouteStrings
              .dispatcher: // Aapko yeh string constants mein add karni hogi
          return MaterialPageRoute(
              builder: (_) => SplashScreen(
                    filePath: settings.name,
                  ));
        case RouteStrings.mainDashboardView:
          return MaterialPageRoute(
              // builder: (_) => const ResponsiveWrap(child: MainDashboard()));
              builder: (_) => const MainDashboard());
        case RouteStrings.videoPlayer:
          return SwipeLeftAnimationRoute(
              widget:
                  // ResponsiveWrap(child: VideoPlayerView(url: args as String)));
                  VideoPlayerView(url: args as String));
        default:
          return _errorRoute();
      }
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

class BoardLoaderScreen extends StatelessWidget {
  final String filePath;

  const BoardLoaderScreen({super.key, required this.filePath});

  // Yeh function file ko read aur parse karega
  Future<GridSizeModel> _loadBoard() async {
    try {
      dev.log("BoardLoader: Loading board from $filePath");
      print("BoardLoader: Loading board from $filePath");
      final file = File(filePath);
      final jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        throw Exception("Shared file is empty.");
      }
      final jsonData = jsonDecode(jsonString);
      return GridSizeModel.fromJson(jsonData);
    } catch (e) {
      dev.log("BoardLoader: Failed to load board.", error: e);
      // Error ko aage pass karein taaki FutureBuilder use handle kar sake
      throw Exception("Could not load the board. The file might be corrupted.");
    }
  }

  Future<GridSizeModel> _copyAndLoadBoard() async {
    try {
      dev.log("BoardLoader: Received shared file path: $filePath");

      final directory = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(filePath);
      final String newPath = '${directory.path}/$fileName';
      dev.log("BoardLoader: Creating new path at: $newPath");

      // Path ko decode karke sahi file object banayein
      final Uri uri = Uri.parse(filePath);
      final File originalFile = File(uri.path);

      dev.log(
          "BoardLoader: File copied successfully!  ${originalFile.readAsLinesSync()}");

      await originalFile.copy(newPath);
      dev.log("BoardLoader: File copied successfully!");

      final File copiedFile = File(newPath);
      final jsonString = await copiedFile.readAsString();

      if (jsonString.isEmpty) {
        throw Exception("Shared file is empty after copying.");
      }

      final jsonData = jsonDecode(jsonString);
      return GridSizeModel.fromJson(jsonData);
    } catch (e) {
      dev.log("BoardLoader: Failed to copy or load board.", error: e);
      throw Exception(
          "Could not load the board. The file might be corrupted or inaccessible.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GridSizeModel>(
      future: _loadBoard(),
      builder: (context, snapshot) {
        // Case 1: Abhi tak data load ho raha hai
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Case 2: Data load karte waqt error aa gaya
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Error loading board: ${snapshot.error}"),
              ),
            ),
          );
        }

        // Case 3: Data successfully load ho gaya
        if (snapshot.hasData) {
          // Foran SharedBoardPreviewScreen dikhayein
          return SharedBoardPreviewScreen(board: snapshot.data!);
        }

        // Fallback case (aisa hona nahi chahiye)
        return const Scaffold(
          body: Center(child: Text("An unknown error occurred.")),
        );
      },
    );
  }
}
