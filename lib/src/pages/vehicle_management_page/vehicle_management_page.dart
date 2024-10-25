import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import '../../providers/vehicle_provider.dart';
import 'components/vehicle_list_view.dart';

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({Key? key}) : super(key: key);

  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  List<Vehicle> parkedVehicles = [];
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getParkedVehiclesData(); // Llama a la función de obtención al iniciar el widget

    return Scaffold(
      body: Column(
        children: [
          _createHeader(context),
          Expanded(child: _createNotifications(context)),

        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 25),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            SizedBox(height: height * 0.075),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vehiculos Parqueados',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createNotifications(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
      itemCount: parkedVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = parkedVehicles[index];
          return VehicleListItem(
            plate: vehicle.plate,
            brand: vehicle.brand,
            model: vehicle.model,
            line: vehicle.line,
            owner: vehicle.isOwner,
            onMarkAsExited: () {
              // Implementa la lógica para marcar el vehículo como salido
            },
          );
        }
    );
  }

  Future<void> _getParkedVehiclesData() async {
    final vehicleProvider = VehicleProvider.instance;
    List<Vehicle> vehicles = await vehicleProvider.findAllParkedVehicles();
    if (!_isDisposed) { // Verifica si el widget está desmontado antes de setState
      setState(() {
        if (!_isDisposed) parkedVehicles = vehicles; // Verifica nuevamente antes de setState
      });
    }
  }
}
