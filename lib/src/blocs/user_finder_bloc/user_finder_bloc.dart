// statistics_bloc.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pr_alpr_watchmen/src/repositories/user_repository.dart';

import '../../models/user_model.dart';
import '../../services/ticket_service.dart';
import '../../utils/camera_page_icon_builder.dart';
import '../../utils/plate_reader.dart';
import 'user_finder_event.dart';
import 'user_finder_state.dart';

class UserVehicleBloc extends Bloc<UserVehicleEvent, UserVehicleState> {
  final UserRepository userRepository;
  final TicketService ticketService = GetIt.instance<TicketService>();
  final PlateReader _plateReader = PlateReader();

  UserVehicleBloc({required this.userRepository})
      : super(UserVehicleInitial()) {
    on<FetchVehicleRelatedUsersRequested>(_onFetchVehiclePlateUsersRequested);
    on<ReadVehiclePlateRequested>(_onCameraImageTaken);
    on<VehicleUsersPopUpClosed>(_onVehicleUsersPopUpClosed);
    on<ErrorWhileTakingPhoto>(_onErrorWhileTakingPhoto);
    on<TicketGenerationRequested>(_onTicketGenerationRequested);
  }

  void _onErrorWhileTakingPhoto(
      ErrorWhileTakingPhoto event, Emitter<UserVehicleState> emit) {
    emit(UserVehicleSearchError(CameraPageIconBuilder.buildCameraErrorOnPhoto(
        'Error al tomar la foto. Intente nuevamente')));
  }

  void _onTicketGenerationRequested(
      TicketGenerationRequested event, Emitter<UserVehicleState> emit) async {
    emit(GeneratingTicket());
    try {
      ticketService.issueTicket(event.plate, event.watchmanSelectedUser);
      emit(UserVehicleResumeCameraPreview());
      emit(SuccessfulProcess(CameraPageIconBuilder.buildSuccessIcon()));
    } catch (error) {
      emit(UserVehicleResumeCameraPreview());
      emit(UserVehicleError(CameraPageIconBuilder.buildCameraErrorOnRequest(
          'Failed to load users: $error')));
    }
  }

  void _onCameraImageTaken(
      ReadVehiclePlateRequested event, Emitter<UserVehicleState> emit) {
    emit(UserVehiclePlateBeingRead());
    String plate = _plateReader.getPlateDataInText(event.cameraImageLetters);
    if (plate.isNotEmpty) {
      add(FetchVehicleRelatedUsersRequested(plate));
      return;
    }
    emit(UserVehicleSearchError(CameraPageIconBuilder.buildCameraErrorOnPhoto(
        'No hemos encontrado ninguna placa. Intenta manualmente')));
  }

  Future<void> _onFetchVehiclePlateUsersRequested(
      FetchVehicleRelatedUsersRequested event,
      Emitter<UserVehicleState> emit) async {
    emit(UserVehicleLoading());
    try {
      final parkedVehiclesData =
          await userRepository.fetchVehicleRelatedUsers(event.plate);
      final List<User> vehicles = parkedVehiclesData
          .map((vehicleData) => User.fromJson(vehicleData))
          .toList();
      emit(UserVehiclePauseCameraPreview());
      emit(UserVehicleLoaded(vehicles, event.plate));
    } catch (error) {
      emit(UserVehicleResumeCameraPreview());
      emit(UserVehicleError(CameraPageIconBuilder.buildCameraErrorOnRequest(
          'Failed to load users: $error')));
    }
  }

  void _onVehicleUsersPopUpClosed(
      VehicleUsersPopUpClosed event, Emitter<UserVehicleState> emit) {
    emit(UserVehicleResumeCameraPreview());
    emit(UserVehicleInitial());
  }
}
