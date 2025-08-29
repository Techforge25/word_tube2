import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to landscape only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize dependency injection
  await setup();

  // Launch the app
  runApp(const MyApp());
}
