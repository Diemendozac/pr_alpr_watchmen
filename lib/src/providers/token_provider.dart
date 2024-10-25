

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pr_alpr_watchmen/src/services/watchman_service.dart';


class TokenProvider extends ChangeNotifier {

  final WatchmanService watchmanService = WatchmanService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? token;

  Future<Map> saveToken(String email, String password) async {
    final response = await watchmanService.loginWatchman(email, password);

    if (response.statusCode == 200) {

      Map<String, dynamic> tokenMap = jsonDecode(response.body);
      await _storage.write(key: 'token', value: tokenMap['token']!);
      return {'statusCode' : 200, 'message': 'Proceso Realizado'};

    }
    notifyListeners();
    return {'statusCode': response.statusCode, 'message': response.message};

  }
}