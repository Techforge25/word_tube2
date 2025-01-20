import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:word_toob/app_providers/app_setting_provider.dart';
import 'package:word_toob/app_providers/content_provider.dart';
import 'package:word_toob/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/common/app_constants/app_strings.dart';
import 'package:word_toob/common/app_constants/route_strings.dart';
import 'package:word_toob/common/route_generator.dart';
import 'package:word_toob/common/utils/app_utility.dart';
import 'package:word_toob/dependency_inject.dart';
import 'package:word_toob/views/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appSettingsProvider = sl<AppSettingsProvider>();
  final _mainDashboardController = sl<MainDashboardController>();
  final _contentProvider = sl<ContentProvider>();
  // final _chatMessage = sl<ChatProvider>();

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
          builder: (context, child) =>
              ResponsiveBreakpoints.builder(child: child!, breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ]),
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
