
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/config.dart';

class WatchmanService {
  final String baseUrl = Config.serverBaseUrl;

  Future<dynamic> loginWatchman(String email, String password) async {

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(
            <String, Object?>{
              'email': email,
              'password': password,
            }),
      );

      return response;
    } on Exception catch (e) {
      return {'statusCode': 500, 'message': e.toString()};
    }

  }

  Future<dynamic> findVehicleRelatedUsers(String email, String password) async {

    var response = await http.post(
      Uri.parse('$baseUrl/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(
          <String, Object?>{
            'email': email,
            'password': password,
          }),
    );
    return response;
  }

}
