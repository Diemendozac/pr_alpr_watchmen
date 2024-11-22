
import 'package:camera/camera.dart';

class CameraControllerService {
  CameraController? cameraController;

  CameraControllerService(this.cameraController);

  void setCameraController(CameraController controller) {
    cameraController = controller;
  }

  Future<void> pausePreview() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await cameraController!.pausePreview();
    }
  }

  Future<void> resumePreview() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await cameraController!.resumePreview();
    }
  }
}

