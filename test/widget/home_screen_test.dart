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

  testWidgets('should show vehicle entry dialog when tapping empty spot',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Find and tap the first empty spot (Vaga 1)
    await tester.tap(find.text('Vaga 1'));
    await tester.pumpAndSettle();

    // Verify that the vehicle entry dialog is shown
    expect(find.text('Registrar Entrada'), findsOneWidget);
  });

  testWidgets('should show vehicle exit dialog when tapping occupied spot',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Find and tap the occupied spot (Vaga 2 with plate ABC1234)
    await tester.tap(find.text('ABC1234'));
    await tester.pumpAndSettle();

    // Verify that the vehicle exit dialog is shown
    expect(find.text('Registrar Saída'), findsOneWidget);
  });

  testWidgets('should show vehicle history dialog when tapping history button',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Find and tap the history button
    await tester.tap(find.text('Histórico'));
    await tester.pumpAndSettle();

    // Verify that the vehicle history dialog is shown
    expect(find.text('Histórico de Veículos'), findsOneWidget);
  });

  testWidgets('should show clear records dialog when tapping end day button',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(buildTestWidget());

    // Find and tap the end day button
    await tester.tap(find.text('Finalizar Dia').first);
    await tester.pumpAndSettle();

    // Verify that the clear records dialog is shown with its content
    expect(
      find.text(
        'Isso irá remover todos os registros de veículos e liberar todas as vagas. Esta ação não pode ser desfeita. Deseja continuar?',
      ),
      findsOneWidget,
    );
  });
}
