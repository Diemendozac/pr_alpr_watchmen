import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraDetection extends StatelessWidget {
  final CameraController controller;
  final bool isDetecting;
  //final String? Function(Size) onExtract;
  final List<Widget> Function(Size) onDetection;
  final Future<void> Function() stopDetection;
  final Future<void> Function() startDetection;

  const CameraDetection(
      {required this.controller,
      required this.isDetecting,
      required this.onDetection,
      required this.startDetection,
      required this.stopDetection,
      //required this.onExtract,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //print(onExtract(size));

    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        ...onDetection(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: _videoButtons()),
        ),
      ],
    );
  }

  Widget _videoButtons() {
    return isDetecting
        ? IconButton(
            onPressed: () async {
              stopDetection();
            },
            icon: const Icon(
              Icons.stop,
              color: Colors.red,
            ),
            iconSize: 50,
          )
        : IconButton(
            onPressed: () async {
              await startDetection();
            },
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            iconSize: 50,
          );
  }
}
