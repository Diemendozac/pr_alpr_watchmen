
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get serverBaseUrl => dotenv.env['SERVER_BASE_URL'] ?? 'http://192.168.20.22:8080';
}