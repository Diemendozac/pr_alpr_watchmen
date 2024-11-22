// statistics_event.dart

abstract class UserVehicleEvent {}

class ReadVehiclePlateRequested extends UserVehicleEvent {
  final String cameraImageLetters;

  ReadVehiclePlateRequested(this.cameraImageLetters);
}

class WroteVehiclePlateRequested extends UserVehicleEvent {}

class FetchVehicleRelatedUsersRequested extends UserVehicleEvent {
  final String plate;

  FetchVehicleRelatedUsersRequested(this.plate);
}

class VehicleUsersPopUpClosed extends UserVehicleEvent {}

class ErrorWhileTakingPhoto extends UserVehicleEvent {}

class CurrentVehicleUserSelected extends UserVehicleEvent {}

class TicketGenerationRequested extends UserVehicleEvent {

  String plate;
  String watchmanSelectedUser;

  TicketGenerationRequested(this.plate, this.watchmanSelectedUser);
}
