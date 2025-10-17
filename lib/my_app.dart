import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:word_toob/src/app_providers/app_setting_provider.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/app_strings.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/route_generator.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/src/source/core/client_local.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'src/views/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.initState();
  }

  final _appSettingsProvider = sl<AppSettingsProvider>();
  final _mainDashboardController = sl<MainDashboardController>();
  final _contentProvider = sl<ContentProvider>();
  // final _chatMessage = sl<ChatProvider>();
  Future<void> _initReceiveSharingIntent() async {
    // For app in foreground
    ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFiles(value);
      }
    }, onError: (err) {
      dev.log("getShareMediaStream failed: $err");
    });

    // For app in background or terminated
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFiles(value);
      }
    });
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    final LocalClient localClient = LocalClient(isar: sl());

    for (var file in files) {
      if (file.path != null && file.path!.endsWith('.wtdata')) {
        try {
          final File jsonFile = File(file.path!);
          final String jsonString = await jsonFile.readAsString();

          // Try to decode as a list first, then as a single object
          try {
            final List<dynamic> jsonList = jsonDecode(jsonString);
            final List<GridSizeModel> receivedModels = jsonList
                .map((e) => GridSizeModel.fromJson(e as Map<String, dynamic>))
                .toList();
            await localClient.saveAllGridSizedModel(
                gridSizedModelList: receivedModels);
            dev.log(
                'Received and saved ${receivedModels.length} GridSizeModels from AirDrop!');
            // You might want to show a success message to the user
          } catch (e) {
            // If it's not a list, try as a single object
            final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
            final GridSizeModel receivedModel = GridSizeModel.fromJson(jsonMap);
            await localClient.saveGridSizedModel(gridSizedModel: receivedModel);
            dev.log('Received and saved a single GridSizeModel from AirDrop!');
            // You might want to show a success message to the user
          }

          // Optional: file ko process karne ke baad delete kar do
          await jsonFile.delete();
        } catch (e) {
          dev.log('Error processing shared .wtdata file: $e',
              name: 'FileHandler');
        }
      }
    }
    // Refresh your UI or game list after saving
    // For example, if you have a state management solution, dispatch an event to reload data.
    // Or if you are using setState, call setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appSettingsProvider),
        ChangeNotifierProvider.value(value: _mainDashboardController),
        ChangeNotifierProvider.value(value: _contentProvider),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (_, appSettings, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          // builder: (context, child) => ResponsiveBreakpoints.builder(
          //   child: child!,
          //   breakpointsLandscape: [
          //     const Breakpoint(start: 0, end: 450, name: MOBILE),
          //     const Breakpoint(start: 451, end: 800, name: TABLET),
          //     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          //     const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          //   ],
          //   landscapePlatforms: [
          //     ResponsiveTargetPlatform.iOS,
          //     ResponsiveTargetPlatform.android,
          //   ],
          //   breakpoints: [
          //     const Breakpoint(start: 0, end: 750, name: MOBILE),
          //     const Breakpoint(start: 451, end: 800, name: TABLET),
          //     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          //     const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          //   ],
          // ),
          // home: GridViewTestingPage1(),
          builder: (context, child) => child!,
          title: AppString.appName,
          theme: AppTheme.lightTheme,
          navigatorKey: AppUtility.navigatorKey,
          darkTheme: AppTheme.darkTheme,
          initialRoute: RouteStrings.mainDashboardView,
          onGenerateRoute: RouteGenerator.generateRoute,
          themeMode: appSettings.activeTheme,
        ),
      ),
    );
  }
}

// class GridViewTestingPage extends StatelessWidget {
//   const GridViewTestingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const int itemCount = 84;

//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     // Landscape check (optional)
//     final isLandscape = screenWidth > screenHeight;

//     // Set desired item count and layout
//     int crossAxisCount = 14; // Adjust as per width
//     double itemSize = screenWidth / crossAxisCount;
//     int rowCount = (itemCount / crossAxisCount).ceil();
//     double gridHeight = itemSize * rowCount;

//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           height: gridHeight,
//           width: screenWidth,
//           child: GridView.builder(
//             physics: const NeverScrollableScrollPhysics(), // Disable scroll
//             itemCount: itemCount,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: crossAxisCount,
//               childAspectRatio: 1, // Square
//             ),
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade100,
//                   border: Border.all(color: Colors.orange.shade400),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.apps, size: 20, color: Colors.black54),
//                     const SizedBox(height: 4),
//                     Text("Item ${index + 1}",
//                         style: const TextStyle(fontSize: 10)),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class GridViewTestingPage1 extends StatelessWidget {
  const GridViewTestingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamic Grid - Auto Adjust Squares")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const int itemCount = 60; // 👈 Try changing this value dynamically
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Try to find best crossAxisCount that keeps squares visible
          int bestCrossAxisCount = 1;
          double bestItemSize = screenWidth;

          for (int i = 1; i <= itemCount; i++) {
            double itemSize = screenWidth / i;
            int rowCount = (itemCount / i).ceil();
            double gridHeight = itemSize * rowCount;

            if (gridHeight <= screenHeight) {
              bestCrossAxisCount = i;
              bestItemSize = itemSize;
              break;
            }
          }

          // If none fit, fallback to max possible
          bestCrossAxisCount = bestCrossAxisCount.clamp(1, itemCount);

          return Center(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: bestCrossAxisCount,
                childAspectRatio: 1, // 👈 makes perfect square
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.green.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 20, color: Colors.black54),
                      const SizedBox(height: 4),
                      Text("Item ${index + 1}",
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class GridViewTestingPage extends StatelessWidget {
  const GridViewTestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Dynamic Grid - 84 Items")),
        body: LayoutBuilder(
          builder: (context, constraints) {
            const int itemCount = 84;

            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // Define minimum item size (can tweak as needed)
            const double minItemSize = 60;

            // Dynamically calculate how many items can fit horizontally
            int crossAxisCount = (screenWidth / minItemSize).floor();

            // Recalculate actual item size based on exact fit
            double itemSize = screenWidth / crossAxisCount;

            // How many rows are needed?
            int rowCount = (itemCount / crossAxisCount).ceil();

            // Total grid height
            double gridHeight = itemSize * rowCount;

            // If gridHeight > screenHeight, reduce crossAxisCount until it fits
            while (gridHeight > screenHeight && crossAxisCount < itemCount) {
              crossAxisCount++;
              itemSize = screenWidth / crossAxisCount;
              rowCount = (itemCount / crossAxisCount).ceil();
              gridHeight = itemSize * rowCount;
            }

            return Center(
              child: SizedBox(
                height: gridHeight,
                width: screenWidth,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        border: Border.all(color: Colors.green.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star,
                              size: 20, color: Colors.black54),
                          const SizedBox(height: 4),
                          Text("Item ${index + 1}",
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
