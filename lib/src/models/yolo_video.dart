import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vision/flutter_vision.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;


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
        //onExtract: getPlateCharacters
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

    print(getPlateCharacters(screen));


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
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
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

    if(yoloResults.isEmpty) return 'No Yoloresults';
    if(cameraImage == null) return 'null cameraImage';

    List<dynamic>? croppedImage = imageCropper.extractRoi(cameraImage!, screen, yoloResults);

    if( croppedImage == null) return 'null croppedImage';

    Uint8List image = cameraImage!.planes.first.bytes;

    InputImage inputImage = plateReader.buildInputImageFromBytes(cameraImage!);

    String? plateData = await plateReader.getPlateData(inputImage);

    return plateData;

  }






}

/*Image extractROI (Size screen) {

    Uint8List croppedBytes = Uint8List(1);
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    if(yoloResults.isEmpty) return const Image(image: AssetImage('assets/test_image.png'),);

    final result = yoloResults[0];

    List<Uint8List>? cameraScreenResult = cameraImage?.planes.map((plane) => plane.bytes).toList();

    if(cameraScreenResult == null) return const Image(image: AssetImage('assets/test_image.png'),);

    croppedBytes = cameraScreenResult[0];

    int x = (result["box"][0] * factorX).round();
    int width = ((result["box"][2] - result["box"][0]) * factorX).round();

    NativeImageCropperExample nativeImageCropper = NativeImageCropperExample();
    final resultImage = nativeImageCropper.cropRect(bytes: croppedBytes,
        x: x,
        y: (result["box"][1] * factorY).round(),
        width: width,
        height: ((result["box"][3] - result["box"][1]) * factorY).round()
    );

    print('checkpoint');
    ClipRect(child:Image.memory(resultImage as Uint8List), clipper: ,);
    return Image.memory(resultImage as Uint8List);

  }


   */
/*
  Uint8List? extractPlate (Size screen) {



    Uint8List? cameraScreenResult = cameraImage?.planes.first.bytes;

    if(cameraScreenResult == null) return null;

    img.Image? testImage = img.decodeImage(cameraScreenResult);

    if(testImage == null) return null;

    final result = yoloResults[0];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    CameraImage.cropCameraImage;

    final resultImage = img.copyCrop(
        testImage,
        x: (result["box"][0] * factorX).toInt(),
        y: (result["box"][1] * factorY).toInt(),
        width: ((result["box"][2] - result["box"][0]) * factorX).toInt(),
        height: ((result["box"][3] - result["box"][1]) * factorY).toInt()
    );

    return Uint8List.fromList(img.encodePng(resultImage));

  }
  */
/*Uint8List? cropCameraImage(Size screen) {

    if(yoloResults.isEmpty) return null;

    final plateResult = yoloResults[0];

    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    int x= (plateResult["box"][0] ).toInt();
    int y=(plateResult["box"][1] ).toInt();
    int width=((plateResult["box"][2] - plateResult["box"][0]) ).toInt();
    int height= ((plateResult["box"][3] - plateResult["box"][1]) ).toInt();

    if (x < 0 || y < 0 || x + width > cameraImage!.width || y + height > cameraImage!.height) {
      throw ArgumentError("Las coordenadas de la ROI están fuera de los límites de la imagen.");
    }


    final int uvRowStride = cameraImage!.planes[1].bytesPerRow;
    final int? uvPixelStride = cameraImage!.planes[1].bytesPerPixel;
    final int offset = uvRowStride * y + uvPixelStride! * x;

    final Uint8List data = Uint8List.sublistView(cameraImage!.planes[1].bytes);
    final Uint8List buffer = Uint8List(width * height);

    for (int i = 0; i < height; i++) {
      final start = offset+ i * uvRowStride;
      final end = start + width * uvPixelStride;
      buffer.setRange(i * width, (i + 1) * width, data.sublist(start, end));
    }

    return buffer;
  }


   */
