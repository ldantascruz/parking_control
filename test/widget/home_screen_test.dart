import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:parking_control/models/parking_spot.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/screens/home_screen.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([ParkingViewModel])
void main() {
  late MockParkingViewModel mockViewModel;
  late List<ParkingSpot> testParkingSpots;
  late Vehicle testVehicle;

  setUp(() {
    mockViewModel = MockParkingViewModel();
    
    // Create test data
    testParkingSpots = [
      ParkingSpot(number: 1, isOccupied: false),
      ParkingSpot(number: 2, isOccupied: true, currentVehicleId: 'test-id'),
      ParkingSpot(number: 3, isOccupied: false),
    ];
    
    testVehicle = Vehicle(
      id: 'test-id',
      plate: 'ABC1234',
      entryTime: DateTime.now(),
      spotNumber: 2,
    );
    
    // Setup default mock responses
    when(mockViewModel.parkingSpots).thenReturn(testParkingSpots);
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn(null);
    
    // Mock getVehicleBySpotNumber for all spots
    when(mockViewModel.getVehicleBySpotNumber(1)).thenReturn(null);
    when(mockViewModel.getVehicleBySpotNumber(2)).thenReturn(testVehicle);
    when(mockViewModel.getVehicleBySpotNumber(3)).thenReturn(null);

    // Mock availableParkingSpots for dialog tests
    when(mockViewModel.availableParkingSpots).thenReturn(
      testParkingSpots.where((spot) => !spot.isOccupied).toList(),
    );

    // Mock vehicleHistory for dialog tests
    when(mockViewModel.vehicleHistory).thenReturn([]);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<ParkingViewModel>.value(
        value: mockViewModel,
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen should render properly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Verify that the AppBar is rendered with correct title
    expect(find.text('Estacionamento'), findsOneWidget);

    // Verify that loading indicator is not shown initially
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that the GridView is rendered
    expect(find.byType(GridView), findsOneWidget);
    
    // Verify that parking spots are rendered
    expect(find.text('Vaga 1'), findsOneWidget);
    expect(find.text('Vaga 2'), findsOneWidget);
    expect(find.text('Vaga 3'), findsOneWidget);
    
    // Verify that vehicle plate is displayed for occupied spot
    expect(find.text('ABC1234'), findsOneWidget);
    
    // Verify that the bottom buttons are rendered
    expect(find.text('Histórico'), findsOneWidget);
    expect(find.text('Finalizar Dia'), findsOneWidget);
  });

  testWidgets('HomeScreen should show loading indicator when isLoading is true',
      (WidgetTester tester) async {
    // Set loading state
    when(mockViewModel.isLoading).thenReturn(true);

    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Verify that loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify that GridView is not shown while loading
    expect(find.byType(GridView), findsNothing);
  });

  testWidgets('HomeScreen should show error message when there is an error',
      (WidgetTester tester) async {
    // Set error state
    when(mockViewModel.errorMessage).thenReturn('Test error message');

    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Verify that error message is shown
    expect(find.text('Test error message'), findsOneWidget);

    // Verify that GridView is not shown when there's an error
    expect(find.byType(GridView), findsNothing);
  });
}
