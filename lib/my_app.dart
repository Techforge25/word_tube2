import 'dart:async';
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
import 'package:word_toob/src/views/screens/dispatcher_screen.dart';
import 'src/views/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  @override
  initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFile(value.first.path);
      }
    }, onError: (err) {
      dev.log("getMediaStream error: $err");
    });

    // App jab band ho aur intent se khule uske liye
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedFile(value.first.path);
      }
    });

    super.initState();
  }

  void _handleSharedFile(String path) async {
    dev.log("Handling shared file at path: $path");

    // Sirf hamari custom file ko process karein
    if (path.endsWith('.wtdata')) {
      // Extension .wtdata hai, .wtcard nahi (aapke log ke mutabiq)
      try {
        final file = File(path);

        // Step 1: File se JSON string padhein
        final jsonString = await file.readAsString();
        dev.log("File Content (JSON): $jsonString");

        if (jsonString.isEmpty) {
          dev.log("Error: Shared file is empty.");
          return;
        }

        // Step 2: JSON string ko Map mein convert karein
        final jsonData = jsonDecode(jsonString);

        // Step 3: Map se GridSizeModel banayein
        final boardData = GridSizeModel.fromJson(jsonData);
        dev.log("Successfully parsed board: ${boardData.title}");
        final context = AppUtility.navigatorKey.currentContext;
        if (context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SharedBoardPreviewScreen(board: boardData)),
          );
        }

        // Step 4: User ko preview screen par navigate karein (yeh ahem hissa hai)
        // Yahan hum aage aane wali problem ko hal karenge
      } catch (e, s) {
        // Agar koi error aaye (file na mile, JSON ghalat ho), to use log karein
        dev.log('ERROR in _handleSharedFile: $e', stackTrace: s);
        // User ko ek error message dikhayein
      }
    } else {
      dev.log("Received file is not a .wtdata file. Path: $path");
    }
  }

  final _appSettingsProvider = sl<AppSettingsProvider>();
  final _mainDashboardController = sl<MainDashboardController>();
  final _contentProvider = sl<ContentProvider>();

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
          builder: (context, child) => child!,
          title: AppString.appName,
          theme: AppTheme.lightTheme,
          navigatorKey: AppUtility.navigatorKey,
          darkTheme: AppTheme.darkTheme,
          initialRoute: RouteStrings.dispatcher,
          onGenerateRoute: RouteGenerator.generateRoute,
          themeMode: appSettings.activeTheme,
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   initState() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);

//     super.initState();
//   }

//   final _appSettingsProvider = sl<AppSettingsProvider>();
//   final _mainDashboardController = sl<MainDashboardController>();
//   final _contentProvider = sl<ContentProvider>();
//   // final _chatMessage = sl<ChatProvider>();
//   Future<void> _initReceiveSharingIntent() async {
//     // For app in foreground
//     ReceiveSharingIntent.instance.getMediaStream().listen(
//         (List<SharedMediaFile> value) {
//       if (value.isNotEmpty) {
//         _handleSharedFiles(value);
//       }
//     }, onError: (err) {
//       dev.log("getShareMediaStream failed: $err");
//     });

//     // For app in background or terminated
//     ReceiveSharingIntent.instance
//         .getInitialMedia()
//         .then((List<SharedMediaFile> value) {
//       if (value.isNotEmpty) {
//         _handleSharedFiles(value);
//       }
//     });
//   }

//   Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
//     final LocalClient localClient = LocalClient(isar: sl());

//     for (var file in files) {
//       if (file.path != null && file.path!.endsWith('.wtdata')) {
//         try {
//           final File jsonFile = File(file.path!);
//           final String jsonString = await jsonFile.readAsString();

//           // Try to decode as a list first, then as a single object
//           try {
//             final List<dynamic> jsonList = jsonDecode(jsonString);
//             final List<GridSizeModel> receivedModels = jsonList
//                 .map((e) => GridSizeModel.fromJson(e as Map<String, dynamic>))
//                 .toList();
//             await localClient.saveAllGridSizedModel(
//                 gridSizedModelList: receivedModels);
//             dev.log(
//                 'Received and saved ${receivedModels.length} GridSizeModels from AirDrop!');
//             // You might want to show a success message to the user
//           } catch (e) {
//             // If it's not a list, try as a single object
//             final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//             final GridSizeModel receivedModel = GridSizeModel.fromJson(jsonMap);
//             await localClient.saveGridSizedModel(gridSizedModel: receivedModel);
//             dev.log('Received and saved a single GridSizeModel from AirDrop!');
//             // You might want to show a success message to the user
//           }

//           // Optional: file ko process karne ke baad delete kar do
//           await jsonFile.delete();
//         } catch (e) {
//           dev.log('Error processing shared .wtdata file: $e',
//               name: 'FileHandler');
//         }
//       }
//     }
//     // Refresh your UI or game list after saving
//     // For example, if you have a state management solution, dispatch an event to reload data.
//     // Or if you are using setState, call setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(value: _appSettingsProvider),
//         ChangeNotifierProvider.value(value: _mainDashboardController),
//         ChangeNotifierProvider.value(value: _contentProvider),
//       ],
//       child: Consumer<AppSettingsProvider>(
//         builder: (_, appSettings, child) => MaterialApp(
//           debugShowCheckedModeBanner: false,
//           builder: (context, child) => child!,
//           title: AppString.appName,
//           theme: AppTheme.lightTheme,
//           navigatorKey: AppUtility.navigatorKey,
//           darkTheme: AppTheme.darkTheme,
//           initialRoute: RouteStrings.mainDashboardView,
//           onGenerateRoute: RouteGenerator.generateRoute,
//           themeMode: appSettings.activeTheme,
//         ),
//       ),
//     );
//   }
// }
