// statistics_event.dart

abstract class ParkedVehicleEvent {}

class FetchParkedVehiclesRequested extends ParkedVehicleEvent {}

class ParkedVehicleKickRequested extends ParkedVehicleEvent {
  String plate;
  ParkedVehicleKickRequested(this.plate);
}