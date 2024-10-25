
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/models/vehicle_model.dart';

import '../services/vehicle_service.dart';


class VehicleProvider extends ChangeNotifier {
  final vehicleService = VehicleService();

  VehicleProvider._();

  static VehicleProvider instance = VehicleProvider._();

  Future<List<Vehicle>> findAllParkedVehicles() async {
    var response = await vehicleService.findAllParkedVehicles();
    if (response.statusCode == 200) {
      List<dynamic> mapData = jsonDecode(response.body);
      List<Vehicle> parkedVehicles = mapData.map<Vehicle>((map) => Vehicle.fromJson(map)).toList();
      return parkedVehicles;
    }
    return [];

  }

}
