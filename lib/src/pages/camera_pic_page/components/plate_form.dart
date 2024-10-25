import 'package:flutter/material.dart';

class PlateForm {

  static void showSearchDialog(BuildContext context,
  Future<void> Function(String) getVehicleUsersData ) {

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Buscar por placa',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Introduce la placa',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
              ),
              child: const Text(
                'Realizar Búsqueda',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                String input = controller.text.toUpperCase();
                RegExp plateRegex = RegExp('[A-Z]{3}([0-9]){2}([A-Z0-9]{1})');
                if (plateRegex.hasMatch(input)) {
                  getVehicleUsersData(input);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingrese una placa válida'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
