import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_control/models/parking_spot.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/services/database_service.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';

import 'parking_viewmodel_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<DatabaseService>(as: #MockDBService)])
void main() {
  late ParkingViewModel viewModel;
  late MockDBService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDBService();
    // Setup default responses for the mock to prevent initialization errors
    when(mockDatabaseService.getAllParkingSpots()).thenAnswer((_) async => []);
    when(mockDatabaseService.getActiveVehicles()).thenAnswer((_) async => []);
    when(mockDatabaseService.getVehicleHistory()).thenAnswer((_) async => []);

    // Inject the mock database service into the view model with initializeData set to false
    viewModel = ParkingViewModel(
      databaseService: mockDatabaseService,
      initializeData: false,
    );
  });

  group('ParkingViewModel Initialization Tests', () {
    test('should initialize with empty lists', () {
      // Verify that the lists are initially empty
      expect(viewModel.parkingSpots, isEmpty);
      expect(viewModel.vehicleHistory, isEmpty);
      expect(viewModel.availableParkingSpots, isEmpty);
      expect(viewModel.activeVehicles, isEmpty);
    });

    test('should not be loading initially', () {
      expect(viewModel.isLoading, isFalse);
    });

    test('should not have error message initially', () {
      expect(viewModel.errorMessage, isNull);
    });
  });

  group('ParkingViewModel Loading Data Tests', () {
    test('should load parking spots successfully', () async {
      // Arrange
      final testSpots = [
        ParkingSpot(number: 1, isOccupied: false),
        ParkingSpot(number: 2, isOccupied: true),
      ];

      when(
        mockDatabaseService.getAllParkingSpots(),
      ).thenAnswer((_) async => testSpots);

      // Act
      await viewModel.loadParkingSpots();

      // Assert
      expect(viewModel.parkingSpots, equals(testSpots));
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('should handle error when loading parking spots fails', () async {
      // Arrange
      when(
        mockDatabaseService.getAllParkingSpots(),
      ).thenThrow(Exception('Database error'));

      // Act
      await viewModel.loadParkingSpots();

      // Assert
      expect(viewModel.parkingSpots, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, contains('Failed to load parking spots'));
    });

    test('should handle error when loading active vehicles fails', () async {
      // Arrange
      when(
        mockDatabaseService.getActiveVehicles(),
      ).thenThrow(Exception('Database error'));

      // Act
      await viewModel.loadActiveVehicles();

      // Assert
      expect(viewModel.activeVehicles, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(
        viewModel.errorMessage,
        contains('Failed to load active vehicles'),
      );
    });

    test('should handle error when loading vehicle history fails', () async {
      // Arrange
      when(
        mockDatabaseService.getVehicleHistory(),
      ).thenThrow(Exception('Database error'));

      // Act
      await viewModel.loadVehicleHistory();

      // Assert
      expect(viewModel.vehicleHistory, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(
        viewModel.errorMessage,
        contains('Failed to load vehicle history'),
      );
    });

    test('should handle error when registering vehicle entry fails', () async {
      // Arrange
      final vehicle = Vehicle(
        id: 'test-id',
        plate: 'ABC123',
        description: 'Test Car',
        entryTime: DateTime.now(),
        spotNumber: 1,
      );
      when(
        mockDatabaseService.addVehicle(any),
      ).thenThrow(Exception('Database error'));

      // Act
      await viewModel.registerVehicleEntry(
        vehicle.plate,
        vehicle.description,
        vehicle.driver,
        vehicle.spotNumber,
      );

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, contains('Failed to register vehicle'));
    });

    test('should handle error when registering vehicle exit fails', () async {
      // Arrange
      const vehicleId = 'test-vehicle-id';
      when(
        mockDatabaseService.updateVehicleExit(vehicleId, any),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await viewModel.registerVehicleExit(vehicleId);

      // Assert
      expect(result, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(
        viewModel.errorMessage,
        contains('Failed to register vehicle exit'),
      );
      verify(mockDatabaseService.updateVehicleExit(vehicleId, any)).called(1);
    });
  });

  group('ParkingViewModel Record Management Tests', () {
    test('should handle error when clearing all records fails', () async {
      // Arrange
      when(
        mockDatabaseService.clearAllRecords(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await viewModel.clearAllRecords();

      // Assert
      expect(result, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, contains('Failed to clear records'));
      verify(mockDatabaseService.clearAllRecords()).called(1);
    });
  });
}
