import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_state.dart';
import 'package:pr_alpr_watchmen/src/services/ocr_providers/google_ml_kit_ocr.dart';
import 'package:pr_alpr_watchmen/src/services/ocr_providers/opencv_tesseract.dart';

import '../../blocs/user_finder_bloc/user_finder_event_handler.dart';
import '../../models/camera_page_icon.dart';
import '../../services/camera_controller_service.dart';
import '../../widgets/user_profile_card.dart';
import 'components/camera_screen_widget.dart';
import 'components/error_popup.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraPageIcon? _cameraPageIcon;
  final cameraService = GetIt.instance<CameraControllerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: BlocConsumer<UserVehicleBloc, UserVehicleState>(
          listener: (context, state) async {
            if (state is UserVehiclePauseCameraPreview) {
              await cameraService.pausePreview();
            } else if (state is UserVehicleResumeCameraPreview) {
              await cameraService.resumePreview();
            }
            if (state is UserVehicleError) {
              _cameraPageIcon = state.cameraPageIcon;
            }
            if (state is UserVehicleSearchError) {
              _cameraPageIcon = state.cameraPageIcon;
            }
            if (state is SuccessfulProcess) {
              _cameraPageIcon = state.cameraPageIcon;
            }
          },
          builder: (context, state) {
            final cameraEventHandler =
                CameraPageEventHandler(bloc: context.read<UserVehicleBloc>());
            return Stack(children: [
              CameraWidget(cameraEventHandler: cameraEventHandler, ocrProvider: TesseractOCRProvider(),),
              _cameraPageIcon != null
                  ? _buildWarningMessageIcon()
                  : Container(),
              state is UserVehicleLoaded
                  ? UserProfileListWidget(
                      state.relatedUsersResponse.vehicleRelatedUsers,
                      state.plate,
                      state.relatedUsersResponse.isParked,
                      cameraPageEventHandler: cameraEventHandler,
                    )
                  : Container(),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildWarningMessageIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          if (_cameraPageIcon?.message != '') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ErrorPopup(
                  message: _cameraPageIcon?.message ??
                      'Error al momento de procesar',
                  deleteIcon: deleteIcon,
                );
              },
            );
          } else {
            deleteIcon();
          }
        },
        child: Lottie.asset(_cameraPageIcon?.animationPath ?? '',
            height: 50,
            delegates: LottieDelegates(values: [
              ValueDelegate.color(
                // keyPath order: ['layer name', 'group name', 'shape name']
                const ['**', 'ADBE Vector Shape - Group', '**'],
                value: _cameraPageIcon?.color ?? Colors.transparent,
              ),
            ])),
      ),
    );
  }

  void deleteIcon() {
    setState(() {
      _cameraPageIcon = null;
    });
  }
}
