// statistics_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pr_alpr_watchmen/src/repositories/vehicle_repository.dart';

import '../../models/vehicle_model.dart';
import 'parked_vehicles_event.dart';
import 'parked_vehicles_state.dart';

class ParkedVehiclesBloc extends Bloc<ParkedVehicleEvent, ParkedVehiclesState> {
  final VehicleRepository parkedVehiclesRepository;

  ParkedVehiclesBloc({required this.parkedVehiclesRepository}) : super(ParkedVehiclesInitial()) {
    on<FetchParkedVehiclesRequested>(_onFetchStatisticsRequested);
  }

  Future<void> _onFetchStatisticsRequested(
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

}
