
import 'package:get_it/get_it.dart';
import 'package:camera/camera.dart';
import 'package:pr_alpr_watchmen/src/services/auth_service.dart';
import 'package:pr_alpr_watchmen/src/services/ticket_service.dart';

import '../services/camera_controller_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final cameras = await availableCameras();
  final cameraController = CameraController(
    cameras.first,
    ResolutionPreset.high,
  );

  await cameraController.initialize();

  // Registrar el CameraControllerService
  getIt.registerSingleton<CameraControllerService>(CameraControllerService(cameraController),);
  getIt.registerSingleton<TicketService>(TicketService());
  getIt.registerSingleton<AuthService>(AuthService());
}
