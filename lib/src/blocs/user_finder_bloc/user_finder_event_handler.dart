
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_event.dart';

class CameraPageEventHandler {
  final UserVehicleBloc bloc;

  CameraPageEventHandler({required this.bloc});

  void handleCameraImageRecognition(String recognizedText) {
    bloc.add(ReadVehiclePlateRequested(recognizedText));
  }

  void handleVehicleRelatedUsersCardsClosed() {
    bloc.add(VehicleUsersPopUpClosed());
  }

  void handleCameraErrorWhileTakingPhoto() {
    bloc.add(ErrorWhileTakingPhoto());
  }

  void handleTicketGeneration(String plate, String watchmanSelectedUser) {
    bloc.add(TicketGenerationRequested(plate, watchmanSelectedUser));
  }
}