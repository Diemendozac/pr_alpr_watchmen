import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://ec2-18-231-167-197.sa-east-1.compute.amazonaws.com:8080"; // Cambia esto a la URL de tu backend

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10)); // Añade un timeout de 10 segundos

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Login error: ${response.body}");
      }
    } on SocketException {
      throw Exception("No internet connection.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again.");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> verifyToken(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/verify_token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['is_valid'];
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/login'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener datos: ${response.body}");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
