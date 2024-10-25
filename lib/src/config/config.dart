
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get serverBaseUrl => dotenv.env['SERVER_BASE_URL'] ?? 'default_value';
}