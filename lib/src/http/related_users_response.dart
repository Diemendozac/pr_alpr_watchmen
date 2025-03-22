



import 'package:pr_alpr_watchmen/src/models/user_model.dart';

class RelatedUsersResponse {
  List<User> vehicleRelatedUsers;
  bool isParked;


  RelatedUsersResponse({
    this.vehicleRelatedUsers = const [],
    required this.isParked,
  });

  factory RelatedUsersResponse.fromJson(Map<String, dynamic> json) {
    return RelatedUsersResponse(
      vehicleRelatedUsers: List<User>.from(json["users"].map((c) => User.fromJson(c))),
      isParked: json["isParked"],
    );
  }

}
