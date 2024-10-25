import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/pages/home_page/components/button_view.dart';

import 'components/movements_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.background,

      ),
      body: const Column(
        children: [
          MovementsView(),
          ButtonView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2633C5),
        onPressed: () {Navigator.of(context).pushNamed('yolo');},
        child: const Icon(Icons.camera_alt, color: Color(0xFFFAFAFA)),
      ),

    );
  }
}
