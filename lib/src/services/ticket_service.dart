import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pr_alpr_watchmen/src/config/config.dart';
import 'package:pr_alpr_watchmen/src/services/auth_service.dart';

class TicketService {
  final String baseUrl = Config.serverBaseUrl;
  final AuthService authService = AuthService();

  Future<List<dynamic>> issueTicket(String plate, String watchmanSelectedUser) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/watchman/switch-state?plate=$plate&watchmanSelectedUser=$watchmanSelectedUser'),
        headers: {'Content-Type': 'application/json', 'Authorization' : 'Bearer ${authService.getToken()}' },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al generar el ticket: ${response.body}");
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
