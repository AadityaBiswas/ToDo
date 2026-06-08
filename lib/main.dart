import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:todo/pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await rive.RiveNative.init();
  await Hive.initFlutter();

  await Hive.openBox("Tasks");

  FlutterForegroundTask.initCommunicationPort();

  final config = PostHogConfig(
    'phc_ntMjJtN2Hq2ZpxfeS3nknqF2ttNP9aT7VuZlOhCjBp',
  );
  config.debug = true;
  config.host = 'https://eu.i.posthog.com';
  await Posthog().setup(config);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "HankenGrotesk"),
      home: const HomePage(),
    );
  }
}
