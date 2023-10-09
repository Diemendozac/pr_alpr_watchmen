import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraDetection extends StatelessWidget {
  final CameraController controller;
  final bool isDetecting;
  final List<Widget> Function(Size) onSave;
  final Future<void> Function() stopDetection;
  final Future<void> Function() startDetection;

  const CameraDetection(
      {required this.controller,
      required this.isDetecting,
      required this.onSave,
      required this.startDetection,
      required this.stopDetection,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        ...onSave(size),
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
