// statistics_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pr_alpr_watchmen/src/repositories/vehicle_repository.dart';

import '../../models/vehicle_model.dart';
import 'parked_vehicles_event.dart';
import 'parked_vehicles_state.dart';

class ParkedVehiclesBloc extends Bloc<ParkedVehicleEvent, ParkedVehiclesState> {
  final VehicleRepository parkedVehiclesRepository;

  ParkedVehiclesBloc({required this.parkedVehiclesRepository}) : super(ParkedVehiclesInitial()) {
    on<FetchParkedVehiclesRequested>(_onFetchParkedVehiclesRequested);
    on<ParkedVehicleKickRequested>(_onParkedVehicleKickRequest);
  }

  Future<void> _onFetchParkedVehiclesRequested(
      FetchParkedVehiclesRequested event, Emitter<ParkedVehiclesState> emit) async {
    emit(ParkedVehiclesLoading());
    try {
      final parkedVehiclesData = await parkedVehiclesRepository.fetchParkedVehicles();
      final List<Vehicle> vehicles = parkedVehiclesData
          .map((vehicleData) => Vehicle.fromJson(vehicleData))
          .toList();
      emit(ParkedVehiclesLoaded(vehicles));
    } catch (error) {
      emit(ParkedVehiclesError("Failed to load parked vehicles: $error"));
    }
  }

  Future<void> _onParkedVehicleKickRequest(
      ParkedVehicleKickRequested event, Emitter<ParkedVehiclesState> emit) async {
    try {
      await parkedVehiclesRepository.kickVehicle(event.plate);
      emit(ParkedVehicleKicked(event.plate));
      emit(ParkedVehiclesInitial());
    } catch (error) {
      emit(ParkedVehicleKickRequestFailed("Failed to load parked vehicles: $error"));
      emit(ParkedVehiclesInitial());
    }
  }

}
