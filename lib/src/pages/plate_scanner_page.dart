import 'package:flutter/material.dart';

class PlateScannerPage extends StatelessWidget {
  const PlateScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.of(context).pushNamed('yolo');}
      ),

    );
  }
}
