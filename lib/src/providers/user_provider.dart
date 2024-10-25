
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/models/user_model.dart';

import '../services/user_service.dart';


class UserProvider extends ChangeNotifier {
  final UserService userService = UserService();

  UserProvider._();

  static UserProvider instance = UserProvider._();

  Future<List<User>?> findVehicleRelatedUsers(String plate) async {
    var response = await userService.findRelatedUsersByPlate(plate);
    if (response.statusCode == 200) {
      List<dynamic> mapData = jsonDecode(response.body);
      List<User> relatedUsers = mapData.map<User>((map) => User.fromJson(map)).toList();
      return relatedUsers;
    }
    return null;

  }

}
