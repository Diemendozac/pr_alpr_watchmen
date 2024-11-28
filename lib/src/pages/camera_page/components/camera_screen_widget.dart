import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pr_alpr_watchmen/main.dart';
import 'package:pr_alpr_watchmen/src/utils/plate_reader.dart';

import '../../../blocs/user_finder_bloc/user_finder_event_handler.dart';
import '../../../services/camera_controller_service.dart';
import '../../../utils/text_input_helper.dart';
import '../../../widgets/popup_template.dart';
import 'permission_denied.dart';

class CameraWidget extends StatefulWidget {
  final CameraPageEventHandler cameraEventHandler;

  const CameraWidget({super.key, required this.cameraEventHandler});

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  CameraController? controller =
      GetIt.instance<CameraControllerService>().cameraController;

  // Initial values
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isRearCameraSelected = true;
  final bool _isVideoCameraSelected = false;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  final PlateReader _plateReader = PlateReader();

  // Current values
  double _currentZoomLevel = 1.0;
  FlashMode? _currentFlashMode;

  List<File> allFileList = [];

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
    } else {
      log('Camera Permission: DENIED');
    }
  }

  Future<void> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      XFile file = await cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      String recognizedText = await _plateReader.getCameraImageData(inputImage);
      widget.cameraEventHandler.handleCameraImageRecognition(recognizedText);
    } on CameraException {
      widget.cameraEventHandler.handleCameraErrorWhileTakingPhoto();
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getPermissionStatus();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: _isCameraPermissionGranted
            ? _isCameraInitialized
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / controller!.value.aspectRatio,
                        child: Stack(
                          children: [
                            CameraPreview(
                              controller!,
                              child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTapDown: (details) =>
                                      onViewFinderTap(details, constraints),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                8.0,
                                16.0,
                                8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(child: Container()),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          value: _currentZoomLevel,
                                          min: _minAvailableZoom,
                                          max: _maxAvailableZoom,
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.white30,
                                          onChanged: (value) async {
                                            setState(() {
                                              _currentZoomLevel = value;
                                            });
                                            await controller!
                                                .setZoomLevel(value);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${_currentZoomLevel.toStringAsFixed(1)}x',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isCameraInitialized = false;
                                          });
                                          onNewCameraSelected(cameras[
                                              _isRearCameraSelected ? 1 : 0]);
                                          setState(() {
                                            _isRearCameraSelected =
                                                !_isRearCameraSelected;
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              color: Colors.black38,
                                              size: 60,
                                            ),
                                            Icon(
                                              _isRearCameraSelected
                                                  ? Icons.camera_front
                                                  : Icons.camera_rear,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await takePicture();
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: _isVideoCameraSelected
                                                  ? Colors.white
                                                  : Colors.white38,
                                              size: 80,
                                            ),
                                            const Icon(
                                              Icons.circle,
                                              color: Colors.white,
                                              size: 65,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _popupEntryWidget();
                                            },
                                          );
                                        },
                                        child: const Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Colors.black38,
                                              size: 60,
                                            ),
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _setCurrentFlashMode(FlashMode.off),
                                      icon: Icon(Icons.flash_off,
                                          color: _selectActiveFlash(
                                              _currentFlashMode,
                                              FlashMode.off)),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _setCurrentFlashMode(FlashMode.auto),
                                      icon: Icon(Icons.flash_auto,
                                          color: _selectActiveFlash(
                                              _currentFlashMode,
                                              FlashMode.auto)),
                                    ),
                                    IconButton(
                                      onPressed: () => _setCurrentFlashMode(
                                          FlashMode.always),
                                      icon: Icon(Icons.flash_on,
                                          color: _selectActiveFlash(
                                              _currentFlashMode,
                                              FlashMode.always)),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _setCurrentFlashMode(FlashMode.torch),
                                      icon: Icon(Icons.highlight,
                                          color: _selectActiveFlash(
                                              _currentFlashMode,
                                              FlashMode.torch)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      'LOADING',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
            : PermissionDeniedWidget(
                onPermissionDenied: getPermissionStatus,
              ),
      ),
    );
  }

  void _setCurrentFlashMode(FlashMode selectedFlashMode) async {
    setState(() {
      _currentFlashMode = selectedFlashMode;
    });
    await controller!.setFlashMode(selectedFlashMode);
  }

  Color _selectActiveFlash(
      FlashMode? currentFlashMode, FlashMode selectedFlashMode) {
    return currentFlashMode == selectedFlashMode ? Colors.amber : Colors.white;
  }

  Widget _popupEntryWidget() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController plateController = TextEditingController();

    return PopupTemplate(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ingresa la placa manualmente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: plateController,
                  decoration:
                  TextInputHelper.buildTextInputDecoration(context, 'Placa'),
                  validator: (value) => TextInputHelper.validatePlate(value),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: const ButtonStyle(
                    minimumSize:
                    MaterialStatePropertyAll(Size(double.maxFinite, 36)),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      widget.cameraEventHandler
                          .handleTextInputRequest(plateController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Enviar solicitud'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
