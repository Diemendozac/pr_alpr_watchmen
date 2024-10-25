
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
}
