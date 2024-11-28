
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<void> login(String email, String password) async {
    final authData = await authService.login(email, password);
    await authService.saveToken(authData['token']);
  }

  Future<bool> isTokenValid() async {
    final token = await authService.getToken();
    if (token == null) return false;
    return await authService.verifyToken(token);
  }

  Future<void> logout() async {
    await authService.logout();
  }

  Future<Map<String, dynamic>> fetchWatchmanData() async {
    final token = await authService.getToken();
    if (token == null) throw Exception("Token no encontrado.");
    return await authService.fetchData(token);  // Asume que `fetchData` hace el GET al endpoint `/fetch_data`
  }
}
