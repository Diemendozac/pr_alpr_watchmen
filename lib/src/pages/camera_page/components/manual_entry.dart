
import 'package:flutter/material.dart';

import '../../../widgets/popup_template.dart';

class ManualEntryPopup extends StatelessWidget {
  const ManualEntryPopup({super.key});

  @override
  Widget build(BuildContext context) {
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
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Placa del vehículo',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Enviar solicitud'),
          ),
        ],
      ),
    );
  }
}
