// statistics_state.dart

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
  final List<User> vehicleRelatedUsers;
  final String plate;
  UserVehicleLoaded(this.vehicleRelatedUsers, this.plate);
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
  SuccessfulProcess(this.cameraPageIcon);
}
