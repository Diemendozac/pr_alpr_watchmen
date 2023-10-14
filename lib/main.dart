
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:pr_alpr_watchmen/src/models/yolo_video.dart';
import 'package:pr_alpr_watchmen/src/pages/plate_scanner_page.dart';
import 'package:pr_alpr_watchmen/src/utils/image_cropper.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

late List<CameraDescription> cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {

    final vision = FlutterVision();

    return MaterialApp(
      title: 'WatchmanApp',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home' : (BuildContext context) => const PlateScannerPage(),
        'yolo' : (BuildContext context) => YoloVideo(vision: vision),
      },
    );
  }

  Widget task(Options option) {
    if (option == Options.frame) {
      return YoloVideo(vision: vision);
    }
    return const Center(child: Text("Choose Task"));
  }
}
