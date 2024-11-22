// statistics_state.dart

import '../../models/user_model.dart';

abstract class UserVehicleState {}

class UserVehicleInitial extends UserVehicleState {}

class UserVehicleLoading extends UserVehicleState {}

class UserVehiclePlateBeingRead extends UserVehicleState {}

class UserVehicleSearchError extends UserVehicleState {
  final String errorWhileSearching;
  UserVehicleSearchError(this.errorWhileSearching);
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
  final String error;
  UserVehicleError(this.error);
}

class UserVehiclePauseCameraPreview extends UserVehicleState {}

class UserVehicleResumeCameraPreview extends UserVehicleState {}

class GeneratingTicket extends UserVehicleState {}

class SuccessfulProcess extends UserVehicleState {}
