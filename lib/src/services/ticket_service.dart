import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pr_alpr_watchmen/src/config/config.dart';

class TicketService {
  final String baseUrl = Config.serverBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<dynamic> issueTicket(String plate, String watchmanSelectedUser) async {
    String? token = await _storage.read(key: 'token');
    if(token == null) return null;
    var response = await http.patch(
        Uri.parse(
            '$baseUrl/watchman/switch-state?plate=$plate&watchmanSelectedUser=$watchmanSelectedUser'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );
    return response;
  }
}
