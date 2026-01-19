import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show sqrt;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:word_toob/src/common/globals.dart' as globals;
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/route_generator.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'dart:developer' as dev;

import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/normal.dart';

class SplashScreen extends StatefulWidget {
  final String? filePath;

  const SplashScreen({super.key, this.filePath});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialIntent();
    });
  }

  _handleInitialIntent() async {
    log('widget.filePath ${widget.filePath}');

    if (widget.filePath != null && widget.filePath!.endsWith('.wtdata')) {
      _navigateToBoardLoader(widget.filePath!);
    } else {
      Navigator.of(context)
          .pushReplacementNamed(RouteStrings.mainDashboardView);
    }
  }

  void _navigateToBoardLoader(String path) {
    print('From Logs Dispatcher $path');

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BoardLoaderScreen(filePath: path),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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
            padding: EdgeInsets.zero,
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
