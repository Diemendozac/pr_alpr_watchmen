
// statistics_repository.dart

import 'package:pr_alpr_watchmen/src/services/vehicle_service.dart';

import '../services/auth_service.dart';

class VehicleRepository {
  final AuthService authService = AuthService();
  final VehicleService vehicleService;

  VehicleRepository({required this.vehicleService});

  Future<List<dynamic>> fetchParkedVehicles() async {
    final token = await authService.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await vehicleService.fetchParkedVehicles(token);
    return response;
  }
}
