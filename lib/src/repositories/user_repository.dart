

import 'package:pr_alpr_watchmen/src/services/user_service.dart';

import '../services/auth_service.dart';

class UserRepository {
  final AuthService authService = AuthService();
  final UserService userService;

  UserRepository({required this.userService});

  Future<dynamic> fetchVehicleRelatedUsers(String plate) async {
    final token = await authService.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await userService.fetchUserRelatedVehicles(token, plate);
    return response;
  }
}
