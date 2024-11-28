
import 'package:flutter/material.dart';

class PermissionDeniedWidget extends StatelessWidget {
  const PermissionDeniedWidget({super.key, required this.onPermissionDenied});
  final Function onPermissionDenied;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(),
        const Text(
          'Permission denied',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            await onPermissionDenied();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Give permission',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
