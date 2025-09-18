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
          // home: child,
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
