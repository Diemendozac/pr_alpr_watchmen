

import 'package:flutter/material.dart';

import '../../../widgets/popup_template.dart';

class ErrorPopup extends StatelessWidget {
  final String message;

  const ErrorPopup({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupTemplate(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48.0,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Error',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
