import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/parking_spot.dart';
import '../viewmodels/parking_viewmodel.dart';
import '../widgets/clear_records_dialog.dart';
import '../widgets/parking_spot_tile.dart';
import '../widgets/vehicle_entry_dialog.dart';
import '../widgets/vehicle_exit_dialog.dart';
import '../widgets/vehicle_history_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estacionamento')),
      body: Consumer<ParkingViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: viewModel.parkingSpots.length,
                  itemBuilder: (context, index) {
                    final spot = viewModel.parkingSpots[index];
                    return ParkingSpotTile(
                      spot: spot,
                      vehicle: viewModel.getVehicleBySpotNumber(spot.number),
                      onTap: () => _handleSpotTap(context, viewModel, spot),
                    );
                  },
                ),
              ),
              _buildBottomButtons(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showVehicleHistoryDialog(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Histórico',
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showClearAllRecordsDialog(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Finalizar Dia',
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSpotTap(
    BuildContext context,
    ParkingViewModel viewModel,
    ParkingSpot spot,
  ) {
    if (spot.isOccupied) {
      final vehicle = viewModel.getVehicleBySpotNumber(spot.number);
      if (vehicle != null) {
        showAdaptiveDialog(
          context: context,
          builder: (dialogContext) => ChangeNotifierProvider<ParkingViewModel>.value(
            value: viewModel,
            child: VehicleExitDialog(vehicle: vehicle),
          ),
        );
      }
    } else {
      showAdaptiveDialog(
        context: context,
        builder: (dialogContext) => ChangeNotifierProvider<ParkingViewModel>.value(
          value: viewModel,
          child: VehicleEntryDialog(preSelectedSpot: spot.number),
        ),
      );
    }
  }

  void _showVehicleHistoryDialog(BuildContext context) {
    final viewModel = Provider.of<ParkingViewModel>(context, listen: false);
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider<ParkingViewModel>.value(
        value: viewModel,
        child: const VehicleHistoryDialog(),
      ),
    );
  }

  void _showClearAllRecordsDialog(BuildContext context) {
    final viewModel = Provider.of<ParkingViewModel>(context, listen: false);
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider<ParkingViewModel>.value(
        value: viewModel,
        child: const ClearRecordsDialog(),
      ),
    );
  }
}
