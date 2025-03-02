import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';
import 'package:parking_control/widgets/vehicle_exit_dialog.dart';
import 'package:provider/provider.dart';

import 'vehicle_exit_dialog_test.mocks.dart';

@GenerateMocks([ParkingViewModel])
void main() {
  late MockParkingViewModel mockViewModel;
  late Vehicle testVehicle;

  setUp(() {
    mockViewModel = MockParkingViewModel();
    testVehicle = Vehicle(
      id: 'test-id',
      plate: 'ABC1234',
      entryTime: DateTime.now().subtract(const Duration(hours: 2)),
      spotNumber: 1,
    );
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ParkingViewModel>.value(
          value: mockViewModel,
          child: VehicleExitDialog(vehicle: testVehicle),
        ),
      ),
    );
  }

  testWidgets('VehicleExitDialog should render correctly', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Verify dialog title is displayed
    expect(find.text('Registrar Saída'), findsOneWidget);

    // Verify vehicle information is displayed
    expect(find.text('Placa: ABC1234'), findsOneWidget);
    expect(find.text('Vaga: 1'), findsOneWidget);

    // Verify entry time is displayed (partial match since it's dynamic)
    expect(find.textContaining('Entrada:'), findsOneWidget);

    // Verify buttons are displayed
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Confirmar Saída'), findsOneWidget);
  });

  testWidgets(
    'VehicleExitDialog should call registerVehicleExit when confirmed',
    (WidgetTester tester) async {
      // Setup mock to return success
      when(
        mockViewModel.registerVehicleExit(testVehicle.id),
      ).thenAnswer((_) async => true);

      // Build widget
      await tester.pumpWidget(buildTestWidget());

      // Tap confirm button
      await tester.tap(find.text('Confirmar Saída'));
      await tester.pump();

      // Verify registerVehicleExit was called with correct parameter
      verify(mockViewModel.registerVehicleExit(testVehicle.id)).called(1);
    },
  );

  testWidgets(
    'VehicleExitDialog should close on successful exit registration',
    (WidgetTester tester) async {
      // Setup mock to return success
      when(
        mockViewModel.registerVehicleExit(testVehicle.id),
      ).thenAnswer((_) async => true);

      // Build widget in a dialog context
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) =>
                                ChangeNotifierProvider<ParkingViewModel>.value(
                                  value: mockViewModel,
                                  child: VehicleExitDialog(
                                    vehicle: testVehicle,
                                  ),
                                ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap confirm button
      await tester.tap(find.text('Confirmar Saída'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(VehicleExitDialog), findsNothing);
    },
  );

  testWidgets(
    'VehicleExitDialog should show error when exit registration fails',
    (WidgetTester tester) async {
      // Setup mock to return failure
      when(
        mockViewModel.registerVehicleExit(testVehicle.id),
      ).thenAnswer((_) async => false);
      when(mockViewModel.errorMessage).thenReturn('Failed to register exit');

      // Build widget
      await tester.pumpWidget(buildTestWidget());

      // Tap confirm button
      await tester.tap(find.text('Confirmar Saída'));
      await tester.pumpAndSettle();

      // Verify error message is displayed
      expect(find.text('Failed to register exit'), findsOneWidget);
    },
  );
  testWidgets('VehicleExitDialog should display vehicle description when available',
    (WidgetTester tester) async {
      testVehicle = Vehicle(
        id: 'test-id',
        plate: 'ABC1234',
        entryTime: DateTime.now().subtract(const Duration(hours: 2)),
        spotNumber: 1,
        description: 'Red Car',
      );

      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Descrição: Red Car'), findsOneWidget);
    });

  testWidgets('VehicleExitDialog should display driver name when available',
    (WidgetTester tester) async {
      testVehicle = Vehicle(
        id: 'test-id',
        plate: 'ABC1234',
        entryTime: DateTime.now().subtract(const Duration(hours: 2)),
        spotNumber: 1,
        driver: 'John Doe',
      );

      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Motorista: John Doe'), findsOneWidget);
    });

  testWidgets('VehicleExitDialog should close when cancel button is pressed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ChangeNotifierProvider<ParkingViewModel>.value(
                    value: mockViewModel,
                    child: VehicleExitDialog(vehicle: testVehicle),
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(VehicleExitDialog), findsNothing);
    });
}
