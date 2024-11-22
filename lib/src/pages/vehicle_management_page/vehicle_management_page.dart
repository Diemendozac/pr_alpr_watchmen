
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/parked_vehicles_bloc/parked_vehicles_bloc.dart';
import 'package:pr_alpr_watchmen/src/blocs/parked_vehicles_bloc/parked_vehicles_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../blocs/parked_vehicles_bloc/parked_vehicles_event.dart';
import '../../models/vehicle_model.dart';
import '../../repositories/vehicle_repository.dart';
import 'components/vehicle_list_view.dart';

class VehicleManagementPage extends StatelessWidget {
  const VehicleManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          _createHeader(context),
          BlocProvider(
            create: (context) => ParkedVehiclesBloc(
              parkedVehiclesRepository: context.read<VehicleRepository>(),
            )..add(FetchParkedVehiclesRequested()),
            child: BlocBuilder<ParkedVehiclesBloc, ParkedVehiclesState>(
              builder: (context, state) {
                if (state is ParkedVehiclesLoading) {
                  return _buildSkeletonLoader(context);
                } else if (state is ParkedVehiclesLoaded) {
                  return Expanded(child: _createVehicleList(context, state.parkedVehicles));
                } else if (state is ParkedVehiclesError) {
                  return _buildErrorWidget(context, state.error, textTheme);
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            SizedBox(height: height * 0.065),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text('Vehiculos Parqueados',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return Expanded(
      child: Skeletonizer(

        ignorePointers: true,
        enabled: true,
        child: _createVehicleList(
          context,
          [null, null, null, null, null, null, null, null],
        ),
      ),
    );
  }

  Widget _createVehicleList(BuildContext context, List<Vehicle?> vehicles) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return VehicleListItem(
          plate: vehicle?.plate ?? '',
          brand: vehicle?.brand ?? '',
          model: vehicle?.model ?? 0,
          line: vehicle?.line ?? '',
          owner: vehicle?.isOwner ?? false,
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error, TextTheme textTheme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.read<ParkedVehiclesBloc>().add(FetchParkedVehiclesRequested());
            },
            child: Image.asset(
              'assets/images/error_icon_light.png',
              height: 200,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hemos tenido un problema',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Al parecer: $error',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Presiona el ícono para volver a intentar',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
