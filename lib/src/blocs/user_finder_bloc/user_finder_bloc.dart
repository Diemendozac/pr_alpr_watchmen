// statistics_bloc.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pr_alpr_watchmen/src/http/related_users_response.dart';
import 'package:pr_alpr_watchmen/src/repositories/user_repository.dart';

import '../../services/ticket_service.dart';
import '../../utils/camera_page_icon_builder.dart';
import '../../utils/plate_reader.dart';
import 'user_finder_event.dart';
import 'user_finder_state.dart';

class UserVehicleBloc extends Bloc<UserVehicleEvent, UserVehicleState> {
  final UserRepository userRepository;
  final TicketService ticketService = GetIt.instance<TicketService>();
  final PlateReader _plateReader = PlateReader();
  int? _fetchAllUsersRequestTime = 0;
  int? _createTicketRequestTime = 0;
  Stopwatch _t1Stopwatch = Stopwatch();
  Stopwatch _t2Stopwatch = Stopwatch();

  UserVehicleBloc({required this.userRepository})
      : super(UserVehicleInitial()) {
    on<ReadVehiclePlateRequested>(_onCameraImageTaken);
    on<FetchVehicleRelatedUsersRequested>(_onFetchVehiclePlateUsersRequested);
    on<VehicleUsersPopUpClosed>(_onVehicleUsersPopUpClosed);
    on<ErrorWhileTakingPhoto>(_onErrorWhileTakingPhoto);
    on<TicketGenerationRequested>(_onTicketGenerationRequested);
  }

  void _onCameraImageTaken(
      ReadVehiclePlateRequested event, Emitter<UserVehicleState> emit) {
    _t1Stopwatch = Stopwatch()..start();
    emit(UserVehiclePlateBeingRead());
    String plate = _plateReader.getPlateDataInText(event.cameraImageLetters);
    if (plate.isNotEmpty) {
      add(FetchVehicleRelatedUsersRequested(plate));
      return;
    }
    _t1Stopwatch.stop();
    emit(UserVehicleSearchError(CameraPageIconBuilder.buildCameraErrorOnPhoto(
        'No hemos encontrado ninguna placa. Intenta manualmente')));
  }

  Future<void> _onFetchVehiclePlateUsersRequested(
      FetchVehicleRelatedUsersRequested event,
      Emitter<UserVehicleState> emit) async {
    emit(UserVehicleLoading());
    try {
      final parkedVehiclesData = await userRepository.fetchVehicleRelatedUsers(event.plate);
      final RelatedUsersResponse relatedUsersResponse = RelatedUsersResponse.fromJson(parkedVehiclesData);
      emit(UserVehiclePauseCameraPreview());
      emit(UserVehicleLoaded(relatedUsersResponse, event.plate));
      _t1Stopwatch.stop();
      _fetchAllUsersRequestTime = _t1Stopwatch.elapsedMilliseconds;
      _t1Stopwatch.reset();
    } catch (error) {
      _t1Stopwatch.stop();
      _t1Stopwatch.reset();
      emit(UserVehicleResumeCameraPreview());
      emit(UserVehicleError(CameraPageIconBuilder.buildCameraErrorOnRequest(
          'Failed to load users: $error')));
    }
  }

  void _onTicketGenerationRequested(
      TicketGenerationRequested event, Emitter<UserVehicleState> emit) async {
    _t2Stopwatch = Stopwatch()..start();
    emit(GeneratingTicket());
    try {
      ticketService.issueTicket(event.plate, event.watchmanSelectedUser);
      emit(UserVehicleResumeCameraPreview());
      _createTicketRequestTime = _t2Stopwatch.elapsedMicroseconds;
      _t2Stopwatch.reset();
      emit(SuccessfulProcess(CameraPageIconBuilder.buildSuccessIcon(), _fetchAllUsersRequestTime!, _createTicketRequestTime!));

    } catch (error) {
      _t2Stopwatch.stop();
      _t2Stopwatch.reset();
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

  void _onErrorWhileTakingPhoto(
      ErrorWhileTakingPhoto event, Emitter<UserVehicleState> emit) {
    emit(UserVehicleSearchError(CameraPageIconBuilder.buildCameraErrorOnPhoto(
        'Error al tomar la foto. Intente nuevamente')));
  }
}
