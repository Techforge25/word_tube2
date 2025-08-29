import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:word_toob/src/app_providers/app_setting_provider.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/app_strings.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/route_generator.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/src/views/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Dependency injection instances
  final _appSettingsProvider = sl<AppSettingsProvider>();
  final _mainDashboardController = sl<MainDashboardController>();
  final _contentProvider = sl<ContentProvider>();

  @override
  void initState() {
    super.initState();

    // Set preferred orientations to landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
