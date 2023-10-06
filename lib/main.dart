import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/pages/plate_scanner_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home':  (BuildContext context) => const PlateScannerPage()
      },

    );
  }
}
