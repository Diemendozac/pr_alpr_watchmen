
import 'package:flutter/material.dart';

import '../models/camera_page_icon.dart';

class CameraPageIconBuilder {


  static CameraPageIcon buildCameraErrorOnPhoto (String message) {
    return CameraPageIcon(animationPath: 'assets/animations/warning.json', color: Colors.amber, message: message);
  }

  static CameraPageIcon buildCameraErrorOnRequest (String message) {
    return CameraPageIcon(animationPath: 'assets/animations/request_failed.json', color: Colors.red, message: message);
  }

  static CameraPageIcon buildSuccessIcon() {
    return CameraPageIcon(animationPath: 'assets/animations/success.json', color: Colors.blue, message: '');
  }
}
