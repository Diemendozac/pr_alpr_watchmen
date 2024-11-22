import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pr_alpr_watchmen/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/parked_vehicles_bloc/parked_vehicles_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_bloc.dart';
import 'package:pr_alpr_watchmen/src/config/setup_locator.dart';
import 'package:pr_alpr_watchmen/src/pages/camera_page/camera_page.dart';
import 'package:pr_alpr_watchmen/src/pages/login_page/login_page.dart';
import 'package:pr_alpr_watchmen/src/pages/home_page/home_page.dart';
import 'package:pr_alpr_watchmen/src/pages/vehicle_management_page/vehicle_management_page.dart';
import 'package:pr_alpr_watchmen/src/repositories/auth_repository.dart';
import 'package:pr_alpr_watchmen/src/repositories/user_repository.dart';
import 'package:pr_alpr_watchmen/src/repositories/vehicle_repository.dart';
import 'package:pr_alpr_watchmen/src/services/auth_service.dart';
import 'package:pr_alpr_watchmen/src/services/local_storage.dart';
import 'package:pr_alpr_watchmen/src/services/user_service.dart';
import 'package:pr_alpr_watchmen/src/services/vehicle_service.dart';
import 'package:pr_alpr_watchmen/src/theme/theme_constants.dart';
import 'package:provider/provider.dart';


late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await LocalStorage.configurePrefs();
  cameras = await availableCameras();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<VehicleService>(create: (_) => VehicleService()),
        Provider<UserService>(create: (_) => UserService()),
        ProxyProvider<AuthService, AuthRepository>(
          update: (_, authService, __) => AuthRepository(authService: authService),
        ),
        ProxyProvider<VehicleService, VehicleRepository>(
          update: (_, vehicleService, __) => VehicleRepository(vehicleService),
        ),
        ProxyProvider<UserService, UserRepository>(
          update: (_, userService, __) => UserRepository(userService),
        )
      ],
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthBloc(authRepository: context.read<AuthRepository>()),
            ),
            BlocProvider(
                create: (_) => UserVehicleBloc(userRepository: context.read<UserRepository>())
            )
            // El `ParkedVehiclesBloc` será inicializado en las páginas donde realmente se use
          ],
          child: MaterialApp(
            themeMode: ThemeMode.light,
            theme: lightTheme,
            title: 'WatchmanApp',
            initialRoute: 'login',
            debugShowCheckedModeBanner: false,
            routes: {
              'home': (BuildContext context) => const HomePage(),
              'login': (BuildContext context) => const LoginPage(),
              'vehicle_management': (BuildContext context) =>
                  BlocProvider(
                    create: (_) => ParkedVehiclesBloc(
                      parkedVehiclesRepository: context.read<VehicleRepository>(),
                    ),
                    child: const VehicleManagementPage(),
                  ),
            'camera_test': (BuildContext context) => const CameraPage(),

            },
          ),
        ),
      ),
    );
  }
}
