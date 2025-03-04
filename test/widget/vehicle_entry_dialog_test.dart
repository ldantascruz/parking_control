import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_control/models/parking_spot.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';
import 'package:parking_control/widgets/vehicle_entry_dialog.dart';
import 'package:provider/provider.dart';

import 'vehicle_entry_dialog_test.mocks.dart';

@GenerateMocks([ParkingViewModel])
void main() {
  late MockParkingViewModel mockViewModel;
  late ParkingSpot testSpot;

  setUp(() {
    mockViewModel = MockParkingViewModel();
    testSpot = ParkingSpot(number: 1, isOccupied: false);

    // Mock the availableParkingSpots property to return a list with the test spot
    when(mockViewModel.availableParkingSpots).thenReturn([testSpot]);

    // Add mock for registerVehicleEntry method
    when(
      mockViewModel.registerVehicleEntry(any, any, any, any),
    ).thenAnswer((_) async => true);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<ParkingViewModel>.value(
        value: mockViewModel,
        child: Builder(
          builder:
              (context) => Dialog(
                child: VehicleEntryDialog(preSelectedSpot: testSpot.number),
              ),
        ),
      ),
    );
  }

  testWidgets('VehicleEntryDialog should render correctly', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Verify dialog title is displayed
    expect(find.text('Registrar Entrada'), findsOneWidget);

    // Verify spot number is displayed
    expect(find.text('Vaga 1'), findsOneWidget);

    // Verify text fields for vehicle information are displayed
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Placa do Veículo'), findsOneWidget);
    expect(find.text('Nome do Motorista'), findsOneWidget);
    expect(find.text('Descrição do Veículo'), findsOneWidget);

    // Verify buttons are displayed
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Confirmar'), findsOneWidget);
  });

  testWidgets('VehicleEntryDialog should validate empty plate', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Tap register button without entering plate
    await tester.tap(find.text('Confirmar'));
    await tester.pump();

    // Verify validation error is displayed
    expect(find.text('Informe a placa'), findsOneWidget);
  });

  testWidgets('VehicleEntryDialog should call registerVehicle when valid', (
    WidgetTester tester,
  ) async {
    // Setup mock to return success
    when(
      mockViewModel.registerVehicleEntry(any, any, any, any),
    ).thenAnswer((_) async => true);

    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Enter valid plate and driver name
    await tester.enterText(
      find.ancestor(
        of: find.text('Placa do Veículo'),
        matching: find.byType(TextField),
      ),
      'ABC-1234',
    );

    await tester.enterText(
      find.ancestor(
        of: find.text('Nome do Motorista'),
        matching: find.byType(TextField),
      ),
      'John Doe',
    );

    // Tap register button
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Verify registerVehicle was called with correct parameters
    verify(
      mockViewModel.registerVehicleEntry('ABC-1234', '', 'John Doe', 1),
    ).called(1);
  });

  testWidgets('VehicleEntryDialog should validate empty driver name', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Enter valid plate but no driver name
    await tester.enterText(
      find.ancestor(
        of: find.text('Placa do Veículo'),
        matching: find.byType(TextField),
      ),
      'ABC-1234',
    );

    // Tap register button
    await tester.tap(find.text('Confirmar'));
    await tester.pump();

    // Verify validation error is displayed
    expect(find.text('Informe o nome do motorista'), findsOneWidget);
  });

  testWidgets('VehicleEntryDialog should allow spot number selection', (
    WidgetTester tester,
  ) async {
    // Create another test spot
    final testSpot2 = ParkingSpot(number: 2, isOccupied: false);
    when(mockViewModel.availableParkingSpots).thenReturn([testSpot, testSpot2]);

    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Find and tap the dropdown button
    final dropdownFinder = find.byType(DropdownButtonFormField<int>);
    await tester.ensureVisible(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Find and tap the second option
    final dropdownItem = find.text('Vaga 2').last;
    await tester.ensureVisible(dropdownItem);
    await tester.pumpAndSettle();
    await tester.tap(dropdownItem);
    await tester.pumpAndSettle();

    // Enter required fields
    await tester.enterText(
      find.ancestor(
        of: find.text('Placa do Veículo'),
        matching: find.byType(TextField),
      ),
      'ABC-1234',
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Nome do Motorista'),
        matching: find.byType(TextField),
      ),
      'John Doe',
    );

    // Submit form
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Verify registerVehicle was called with spot number 2
    verify(
      mockViewModel.registerVehicleEntry('ABC-1234', '', 'John Doe', 2),
    ).called(1);
  });

  testWidgets('VehicleEntryDialog should handle registration failure', (
    WidgetTester tester,
  ) async {
    // Setup mock to return failure
    when(
      mockViewModel.registerVehicleEntry(any, any, any, any),
    ).thenAnswer((_) async => false);

    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Enter valid data
    await tester.enterText(
      find.ancestor(
        of: find.text('Placa do Veículo'),
        matching: find.byType(TextField),
      ),
      'ABC-1234',
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Nome do Motorista'),
        matching: find.byType(TextField),
      ),
      'John Doe',
    );

    // Tap register button
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Verify dialog is still open
    expect(find.byType(VehicleEntryDialog), findsOneWidget);
  });
}
