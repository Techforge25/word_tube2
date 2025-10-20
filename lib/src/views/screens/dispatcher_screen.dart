import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/normal.dart';

class DispatcherScreen extends StatefulWidget {
  const DispatcherScreen({super.key});

  @override
  State<DispatcherScreen> createState() => _DispatcherScreenState();
}

class _DispatcherScreenState extends State<DispatcherScreen> {
  @override
  void initState() {
    super.initState();
    _handleInitialIntent();
  }

  Future<void> _handleInitialIntent() async {
    // Sirf us intent ko handle karein jis se app khuli hai (initial media)
    final List<SharedMediaFile> initialMedia =
        await ReceiveSharingIntent.instance.getInitialMedia();

    if (initialMedia.isNotEmpty) {
      final path = initialMedia.first.path;
      dev.log("Dispatcher: Found initial media at $path");

      if (path.endsWith('.wtdata')) {
        try {
          final file = File(path);
          final jsonString = await file.readAsString();
          final jsonData = jsonDecode(jsonString);
          final boardData = GridSizeModel.fromJson(jsonData);
          Get.put(MainDashboardController());

          // Agar board sahi se parse ho gaya, to Preview Screen par bhej do
          // `pushReplacement` ka istemal karein taaki user back karke is loading screen par na aaye
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => SharedBoardPreviewScreen(board: boardData)),
            );
          }
          return; // Yahan se function khatam kar dein
        } catch (e) {
          dev.log("Dispatcher: Error handling initial file: $e");
          // Agar koi error aaye, to normal dashboard par chale jao
        }
      }
    }

    // Agar koi shared file nahi hai, to normal dashboard par jao
    dev.log("Dispatcher: No initial media found, navigating to dashboard.");
    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteStrings.mainDashboardView);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Yeh screen user ko zyada der nazar nahi aani chahiye
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SharedBoardPreviewScreen extends StatelessWidget {
  final GridSizeModel board;

  const SharedBoardPreviewScreen({Key? key, required this.board})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final mainDashboardController =
        Provider.of<MainDashboardController>(context);
    late double fontSize;
    Orientation orientation = MediaQuery.orientationOf(context);

    if (orientation == Orientation.landscape) {
      if (context.height > 500) {
        fontSize = context.height * 0.025;
      } else {
        fontSize = (context.height * 0.025) + 4;
      }
    } else {
      fontSize = context.height * 0.025;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Board Preview: ${board.title ?? "Untitled"}'),
        actions: [
          TextButton(
            onPressed: () {
              contentProvider.saveGridSizedModel(gridSizedModel: board);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Board saved successfully!')),
              );
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final itemCount = board.listData?.length ?? 0;
          if (itemCount == 0) return const SizedBox();

          final crossAxisCount = sqrt(itemCount).ceil();
          final rowCount = (itemCount / crossAxisCount).ceil();

          final cellWidth = constraints.maxWidth / crossAxisCount;
          final cellHeight = constraints.maxHeight / rowCount;
          final aspectRatio = cellWidth / cellHeight;

          return GridView.count(
            crossAxisCount: crossAxisCount,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: aspectRatio,
            children: List.generate(itemCount, (index) {
              final GridModel grid = board.listData?[index] ?? GridModel();
              return basicGrid(
                value: mainDashboardController,
                contentProvider: contentProvider,
                grid: grid,
                index: index,
                fontSize: fontSize,
                screenWidth: constraints.maxWidth,
                screenHeight: constraints.maxHeight,
              );
            }),
          );
        },
      ),
    );
  }
}
