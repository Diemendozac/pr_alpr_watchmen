// statistics_state.dart

import 'package:pr_alpr_watchmen/src/http/related_users_response.dart';
import 'package:pr_alpr_watchmen/src/models/camera_page_icon.dart';

import '../../models/user_model.dart';

abstract class UserVehicleState {}

class UserVehicleInitial extends UserVehicleState {}

class UserVehicleLoading extends UserVehicleState {}

class UserVehiclePlateBeingRead extends UserVehicleState {}

class UserVehicleSearchError extends UserVehicleState {
  final CameraPageIcon cameraPageIcon;
  UserVehicleSearchError(this.cameraPageIcon);
}

class UserVehicleSearchLoading extends UserVehicleState {}


class UserVehicleLoaded extends UserVehicleState {
  final RelatedUsersResponse relatedUsersResponse;
  final String plate;
  UserVehicleLoaded(this.relatedUsersResponse, this.plate);
}

class UserVehicleSelected extends UserVehicleState {
  final User selectedUser;
  UserVehicleSelected(this.selectedUser);
}

class UserVehicleError extends UserVehicleState {
  final CameraPageIcon cameraPageIcon;
  UserVehicleError(this.cameraPageIcon);
}

class UserVehiclePauseCameraPreview extends UserVehicleState {}

class UserVehicleResumeCameraPreview extends UserVehicleState {}

class GeneratingTicket extends UserVehicleState {}

class SuccessfulProcess extends UserVehicleState {
  final CameraPageIcon cameraPageIcon;
  final int t1;
  final int t2;
  SuccessfulProcess(this.cameraPageIcon, this.t1, this.t2);
}
