
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vision/flutter_vision.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


import 'package:pr_alpr_watchmen/src/pages/camera_detection_page.dart';
import 'package:pr_alpr_watchmen/src/utils/image_cropper.dart';

import '../utils/plate_reader.dart';

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;

  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  final ImageCropper imageCropper = ImageCropper();
  final PlateReader plateReader = PlateReader();
  String plateString = 'Nothing';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: CameraDetection(
        controller: controller,
        isDetecting: isDetecting,
        onDetection: displayBoxesAroundRecognizedObjects,
        startDetection: startDetection,
        stopDetection: stopDetection,
        //onExtract: getPlateDetected
      ),
    );

  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/best_float16.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    getPlateCharacters(screen);


    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    MaterialColor colorPick = Colors.green;

    return yoloResults.map((result) {

      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "$plateString ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<String?> getPlateCharacters (Size screen)  async {
    if (yoloResults.isEmpty) return 'No Yoloresults';

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes
        .done()
        .buffer
        .asUint8List();

    //List<dynamic> croppedImage = imageCropper.cropCameraImagev2(cameraImage!, yoloResults[0]);

    Size cropSize = Size(
        cameraImage!.width.toDouble(), cameraImage!.height.toDouble());

    InputImage inputImage = plateReader.buildInputImageFromBytes(
        bytes, cropSize);

    String? plateData = await plateReader.getPlateData(inputImage);

    plateString = plateData;

    return plateData;
  }

}
