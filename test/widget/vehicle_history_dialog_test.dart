import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';
import 'package:parking_control/widgets/vehicle_history_dialog.dart';
import 'package:provider/provider.dart';

import 'vehicle_history_dialog_test.mocks.dart';

@GenerateMocks([ParkingViewModel])
void main() {
  late MockParkingViewModel mockViewModel;
  late List<Vehicle> emptyVehicleHistory;
  late List<Vehicle> populatedVehicleHistory;

  setUp(() {
    mockViewModel = MockParkingViewModel();
    emptyVehicleHistory = [];

    // Create test data for populated history
    final now = DateTime.now();
    populatedVehicleHistory = [
      Vehicle(
        id: 'vehicle-1',
        plate: 'ABC1234',
        entryTime: now.subtract(const Duration(hours: 3)),
        exitTime: now.subtract(const Duration(hours: 1)),
        spotNumber: 1,
      ),
      Vehicle(
        id: 'vehicle-2',
        plate: 'XYZ5678',
        entryTime: now.subtract(const Duration(hours: 2)),
        spotNumber: 2,
      ),
    ];
  });

  Widget buildTestWidget(List<Vehicle> vehicleHistory) {
    // Setup mock response
    when(mockViewModel.vehicleHistory).thenReturn(vehicleHistory);

    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ParkingViewModel>.value(
          value: mockViewModel,
          child: Builder(builder: (context) => const VehicleHistoryDialog()),
        ),
      ),
    );
  }

  testWidgets(
    'VehicleHistoryDialog should show empty state message when history is empty',
    (WidgetTester tester) async {
      // Build dialog with empty history
      await tester.pumpWidget(buildTestWidget(emptyVehicleHistory));

      // Verify dialog title is displayed
      expect(find.text('Histórico de Veículos'), findsOneWidget);

      // Verify empty state message is displayed
      expect(find.text('Nenhum registro encontrado'), findsOneWidget);

      // Verify that no vehicle items are displayed
      expect(find.text('ABC1234'), findsNothing);
    },
  );

  testWidgets(
    'VehicleHistoryDialog should display vehicle history items when available',
    (WidgetTester tester) async {
      // Build dialog with populated history
      await tester.pumpWidget(buildTestWidget(populatedVehicleHistory));

      // Verify dialog title is displayed
      expect(find.text('Histórico de Veículos'), findsOneWidget);

      // Verify that vehicle plates are displayed
      expect(find.text('ABC1234'), findsOneWidget);
      expect(find.text('XYZ5678'), findsOneWidget);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    },
  );

  testWidgets('VehicleHistoryDialog should have export button', (
    WidgetTester tester,
  ) async {
    // Build dialog with populated history
    await tester.pumpWidget(buildTestWidget(populatedVehicleHistory));

    // Verify export button is displayed
    expect(find.text('Gerar Relatório'), findsOneWidget);
  });
}
