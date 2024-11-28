
import 'package:get_it/get_it.dart';
import 'package:camera/camera.dart';
import 'package:pr_alpr_watchmen/src/services/auth_service.dart';
import 'package:pr_alpr_watchmen/src/services/ticket_service.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/parked_vehicles_bloc/parked_vehicles_bloc.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/vehicle_repository.dart';
import '../services/camera_controller_service.dart';
import '../services/local_storage.dart';
import '../services/user_service.dart';
import '../services/vehicle_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final cameras = await availableCameras();
  final cameraController = CameraController(
    cameras.first,
    ResolutionPreset.high,
  );

  await cameraController.initialize();

  getIt.registerSingleton<CameraControllerService>(CameraControllerService(cameraController),);
  getIt.registerSingleton<TicketService>(TicketService());
  getIt.registerSingleton<LocalStorage>(LocalStorage());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<VehicleService>(VehicleService());
  getIt.registerSingleton<UserService>(UserService());

  // Repositorios
  getIt.registerFactory(() => AuthRepository(authService: getIt<AuthService>()));
  getIt.registerFactory(() => VehicleRepository(vehicleService: getIt<VehicleService>()));
  getIt.registerFactory(() => UserRepository(userService: getIt<UserService>()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory(() => ParkedVehiclesBloc(parkedVehiclesRepository: getIt<VehicleRepository>()));
}
