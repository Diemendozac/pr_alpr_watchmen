// statistics_state.dart

import '../../models/vehicle_model.dart';

abstract class ParkedVehiclesState {}

class ParkedVehiclesInitial extends ParkedVehiclesState {}

class ParkedVehiclesLoading extends ParkedVehiclesState {}

class ParkedVehiclesRequestLoading extends ParkedVehiclesState {}



class ParkedVehiclesLoaded extends ParkedVehiclesState {
  final List<Vehicle> parkedVehicles;
  ParkedVehiclesLoaded(this.parkedVehicles);
}

class ParkedVehiclesError extends ParkedVehiclesState {
  final String error;
  ParkedVehiclesError(this.error);
}

class ParkedVehicleKicked extends ParkedVehiclesState {
  final String plate;
  ParkedVehicleKicked(this.plate);
}

class ParkedVehicleKickRequestFailed extends ParkedVehiclesState {
  final String message;
  ParkedVehicleKickRequestFailed(this.message);
}
