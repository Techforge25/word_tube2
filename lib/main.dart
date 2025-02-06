import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

  await setup();
  runApp(const MyApp());
}
