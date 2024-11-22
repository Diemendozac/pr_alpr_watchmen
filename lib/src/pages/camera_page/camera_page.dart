import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_state.dart';

import '../../blocs/user_finder_bloc/user_finder_event_handler.dart';
import '../../services/camera_controller_service.dart';
import '../../widgets/user_profile_card.dart';
import 'components/camera_screen_widget.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String messageError = '';
  final cameraService = GetIt.instance<CameraControllerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<UserVehicleBloc, UserVehicleState>(
          listener: (context, state) async {
            if (state is UserVehiclePauseCameraPreview) {
              await cameraService.pausePreview();
            } else if (state is UserVehicleResumeCameraPreview) {
              await cameraService.resumePreview();
            } else if (state is UserVehicleSearchError) {
              setState(() {
                messageError = state.errorWhileSearching;
              });
            }
          },
          builder: (context, state) {
            final cameraEventHandler =
                CameraPageEventHandler(bloc: context.read<UserVehicleBloc>());
            return Stack(children: [
              CameraWidget(cameraEventHandler: cameraEventHandler),
              messageError != ''
                  ? _buildWarningMessageIcon(messageError)
                  : Container(),
              state is UserVehicleLoaded
                  ? UserProfileListWidget(
                      state.vehicleRelatedUsers,
                      state.plate,
                      cameraPageEventHandler: cameraEventHandler,
                    )
                  : Container(),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildWarningMessageIcon(String message) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          setState(() {
            messageError = '';
          });
        },
        child: Lottie.asset('assets/animations/plate_warning.json',
            height: 50,
            delegates: LottieDelegates(values: [
              ValueDelegate.color(
                // keyPath order: ['layer name', 'group name', 'shape name']
                const ['**', 'ADBE Vector Shape - Group', '**'],
                value: Colors.amber,
              ),
            ])),
      ),
    );
  }
}
