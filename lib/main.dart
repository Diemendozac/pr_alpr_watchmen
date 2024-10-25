import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:pr_alpr_watchmen/src/pages/login_page/login_page.dart';
import 'package:pr_alpr_watchmen/src/pages/home_page/home_page.dart';
import 'package:pr_alpr_watchmen/src/pages/camera_pic_page/camera_pic_page.dart';
import 'package:pr_alpr_watchmen/src/pages/vehicle_management_page/vehicle_management_page.dart';
import 'package:pr_alpr_watchmen/src/services/auth_state_service.dart';
import 'package:pr_alpr_watchmen/src/services/local_storage.dart';
import 'package:pr_alpr_watchmen/src/theme/theme_constants.dart';
import 'package:provider/provider.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

late List<CameraDescription> cameras;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await LocalStorage.configurePrefs();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthState(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: lightTheme,
        title: 'WatchmanApp',
        initialRoute: 'login',
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (BuildContext context) => const HomePage(),
          'yolo': (BuildContext context) => const CameraView(),
          'login': (BuildContext context) {
            final authState = context.watch<AuthState>();
            return authState.isLoggedIn ? const HomePage() : const LoginPage();
          },
          'vehicle_management': (BuildContext context) =>
              const VehicleManagementPage(),
        },
      ),
    );
  }
}
