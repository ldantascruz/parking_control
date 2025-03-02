import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_control/models/parking_spot.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';
import 'package:parking_control/widgets/parking_spot_tile.dart';
import 'package:provider/provider.dart';

import 'parking_spot_tile_test.mocks.dart';

@GenerateMocks([ParkingViewModel])
void main() {
  late MockParkingViewModel mockViewModel;
  late ParkingSpot availableSpot;
  late ParkingSpot occupiedSpot;
  late Vehicle testVehicle;

  setUp(() {
    mockViewModel = MockParkingViewModel();
    availableSpot = ParkingSpot(number: 1, isOccupied: false);
    testVehicle = Vehicle(
      id: 'test-id',
      plate: 'ABC1234',
      entryTime: DateTime.now(),
      spotNumber: 2,
    );
    occupiedSpot = ParkingSpot(
      number: 2,
      isOccupied: true,
      currentVehicleId: testVehicle.id,
    );
  });

  Widget buildTestWidget(ParkingSpot spot) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ParkingViewModel>.value(
          value: mockViewModel,
          child: ParkingSpotTile(
            spot: spot,
            vehicle: spot.isOccupied ? testVehicle : null,
            onTap: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('ParkingSpotTile should render available spot correctly', (
    WidgetTester tester,
  ) async {
    // Build widget with available spot
    await tester.pumpWidget(buildTestWidget(availableSpot));

    // Verify spot number is displayed
    expect(find.text('Vaga 1'), findsOneWidget);

    // Verify color indicates available status (green)
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(ParkingSpotTile),
        matching: find.byType(Container).first,
      ),
    );
    expect(
      (container.decoration as BoxDecoration).color,
      Colors.green.withValues(alpha: 0.1),
    );
  });

  testWidgets('ParkingSpotTile should render occupied spot correctly', (
    WidgetTester tester,
  ) async {
    // Setup mock to return vehicle when requested
    when(mockViewModel.getVehicleById(testVehicle.id)).thenReturn(testVehicle);

    // Build widget with occupied spot
    await tester.pumpWidget(buildTestWidget(occupiedSpot));

    // Verify spot number is displayed
    expect(find.text('Vaga 2'), findsOneWidget);

    // Verify vehicle plate is displayed
    expect(find.text('ABC1234'), findsOneWidget);

    // Verify color indicates occupied status (red)
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(ParkingSpotTile),
        matching: find.byType(Container).first,
      ),
    );
    expect(
      (container.decoration as BoxDecoration).color,
      Colors.red.withValues(alpha: 0.1),
    );
  });

  testWidgets('ParkingSpotTile calls onTap when tapped', (
    WidgetTester tester,
  ) async {
    // Track if onTap was called
    bool onTapCalled = false;
    
    // Build widget with custom onTap handler
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ParkingViewModel>.value(
            value: mockViewModel,
            child: ParkingSpotTile(
              spot: availableSpot,
              vehicle: null,
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      ),
    );

    // Tap on the parking spot tile
    await tester.tap(find.byType(ParkingSpotTile));
    
    // Verify that onTap was called
    expect(onTapCalled, true);
  });

  testWidgets('ParkingSpotTile handles long license plates correctly', (
    WidgetTester tester,
  ) async {
    // Create a vehicle with a long license plate
    final vehicleWithLongPlate = Vehicle(
      id: 'test-id',
      plate: 'ABC-12345-LONG-PLATE',
      entryTime: DateTime.now(),
      spotNumber: 1,
    );

    // Build widget with the long plate vehicle
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ParkingViewModel>.value(
            value: mockViewModel,
            child: ParkingSpotTile(
              spot: occupiedSpot,
              vehicle: vehicleWithLongPlate,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // Find the text widget displaying the plate
    final plateFinder = find.text('ABC-12345-LONG-PLATE');
    final plateWidget = tester.widget<Text>(plateFinder);

    // Verify text overflow is handled
    expect(plateWidget.overflow, TextOverflow.ellipsis);
  });

  testWidgets('ParkingSpotTile renders correctly in dark theme', (
    WidgetTester tester,
  ) async {
    // Build widget with dark theme
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: ChangeNotifierProvider<ParkingViewModel>.value(
            value: mockViewModel,
            child: ParkingSpotTile(
              spot: availableSpot,
              vehicle: null,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // Verify colors are appropriate for dark theme
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(ParkingSpotTile),
        matching: find.byType(Container).first,
      ),
    );
    expect(
      (container.decoration as BoxDecoration).color,
      Colors.green.withValues(alpha: 0.1),
    );
  });

  testWidgets('ParkingSpotTile has correct semantic labels', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(buildTestWidget(availableSpot));

    // Verify semantic labels
    final semantics = tester.getSemantics(find.byType(ParkingSpotTile));
    expect(
      semantics.label,
      contains('Vaga 1'),
    );
  });

  testWidgets('ParkingSpotTile handles null vehicle data gracefully', (
    WidgetTester tester,
  ) async {
    // Create a spot with null vehicle data
    final spotWithNullVehicle = ParkingSpot(
      number: 3,
      isOccupied: true,
      currentVehicleId: null,
    );

    // Build widget with null vehicle
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ParkingViewModel>.value(
            value: mockViewModel,
            child: ParkingSpotTile(
              spot: spotWithNullVehicle,
              vehicle: null,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // Verify widget renders without errors
    expect(find.text('Vaga 3'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget); // Only spot number should be visible
  });
}
