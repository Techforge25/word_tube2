import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_toob/dependency_inject.dart';
import 'package:word_toob/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  await setup();
  runApp(const MyApp());
}
