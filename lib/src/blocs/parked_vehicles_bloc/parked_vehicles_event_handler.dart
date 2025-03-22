
import 'package:pr_alpr_watchmen/src/blocs/parked_vehicles_bloc/parked_vehicles_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/parked_vehicles_bloc/parked_vehicles_event.dart';

class ParkedVehiclesEventHandler {
  final ParkedVehiclesBloc bloc;

  ParkedVehiclesEventHandler({required this.bloc});

  void handleParkedVehicleKickRequested(String plate) {
    bloc.add(ParkedVehicleKickRequested(plate));
  }

}