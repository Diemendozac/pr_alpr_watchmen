
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';


class UserService {
  final String baseUrl = Config.serverBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<dynamic> findRelatedUsersByPlate(String plate) async {
    String? token = await _storage.read(key: 'token');
    //if(token == null) return null;
    var response = await http.get(
      Uri.parse('$baseUrl/watchman/related-users?plate=$plate'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    return response;
  }

  Future<dynamic> fetchUserRelatedVehicles(String token, String plate) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/watchman/related-users?plate=$plate'),
        headers: {'Content-Type': 'application/json', 'Authorization' : 'Bearer $token' },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Parked vehicles error: ${response.body}");
      }
    } on SocketException {
      throw Exception("No internet connection.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again.");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
