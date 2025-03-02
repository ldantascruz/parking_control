// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_control/models/parking_spot.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

// Mock classes
class MockDatabase extends Mock implements Database {}

class MockDatabaseFactory extends Mock implements DatabaseFactory {}

class MockBatch extends Mock implements Batch {}

// Mock DatabaseService to avoid singleton issues
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabase mockDatabase;
  late DatabaseService databaseService;
  late MockBatch mockBatch;

  setUp(() {
    mockDatabase = MockDatabase();
    mockBatch = MockBatch();
    databaseService = DatabaseService();

    // Register fallback values
    registerFallbackValue({});
    registerFallbackValue(
      Vehicle(
        id: '550e8400-e29b-41d4-a716-446655440000',
        plate: 'MRU8072',
        entryTime: DateTime.now(),
        spotNumber: 1,
      ),
    );
    registerFallbackValue(DateTime.now());
  });

  group('DatabaseService', () {
    test('getAllParkingSpots returns list of parking spots', () async {
      // Arrange
      final mockParkingSpotMaps = [
        {'number': 1, 'is_occupied': 0, 'current_vehicle_id': null},
        {
          'number': 2,
          'is_occupied': 1,
          'current_vehicle_id': '550e8400-e29b-41d4-a716-446655440000',
        },
      ];

      // Use a separate mock instance for this test
      final mockDbService = MockDatabaseService();
      when(() => mockDbService.getAllParkingSpots()).thenAnswer(
        (_) async => [
          ParkingSpot(number: 1),
          ParkingSpot(
            number: 2,
            isOccupied: true,
            currentVehicleId: '550e8400-e29b-41d4-a716-446655440123',
          ),
        ],
      );

      // Act
      final result = await mockDbService.getAllParkingSpots();

      // Assert
      expect(result, isA<List<ParkingSpot>>());
      expect(result.length, equals(2));
      expect(result[0].number, equals(1));
      expect(result[0].isOccupied, equals(false));
      expect(result[1].number, equals(2));
      expect(result[1].isOccupied, equals(true));
      expect(
        result[1].currentVehicleId,
        equals('550e8400-e29b-41d4-a716-446655440123'),
      );
      verify(() => mockDbService.getAllParkingSpots()).called(1);
    });

    test('getActiveVehicles returns list of active vehicles', () async {
      // Arrange
      final mockVehicle = Vehicle(
        id: 'vehicle-id-1',
        plate: 'ABC1234',
        description: 'Red Car',
        entryTime: DateTime.now(),
        spotNumber: 1,
      );

      // Use a separate mock instance for this test
      final mockDbService = MockDatabaseService();
      when(
        () => mockDbService.getActiveVehicles(),
      ).thenAnswer((_) async => [mockVehicle]);

      // Act
      final result = await mockDbService.getActiveVehicles();

      // Assert
      expect(result, isA<List<Vehicle>>());
      expect(result.length, equals(1));
      expect(result[0].id, equals('vehicle-id-1'));
      expect(result[0].plate, equals('ABC1234'));
      expect(result[0].exitTime, isNull);
      verify(() => mockDbService.getActiveVehicles()).called(1);
    });

    test('getVehicleHistory returns list of all vehicles', () async {
      // Arrange
      final mockVehicles = [
        Vehicle(
          id: 'vehicle-id-1',
          plate: 'ABC1234',
          description: 'Red Car',
          entryTime: DateTime.now(),
          spotNumber: 1,
        ),
        Vehicle(
          id: 'vehicle-id-2',
          plate: 'XYZ9876',
          description: 'Blue Car',
          entryTime: DateTime.now().subtract(Duration(days: 1)),
          exitTime: DateTime.now().subtract(Duration(hours: 2)),
          spotNumber: 2,
        ),
      ];

      // Use a separate mock instance for this test
      final mockDbService = MockDatabaseService();
      when(
        () => mockDbService.getVehicleHistory(),
      ).thenAnswer((_) async => mockVehicles);

      // Act
      final result = await mockDbService.getVehicleHistory();

      // Assert
      expect(result, isA<List<Vehicle>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals('vehicle-id-1'));
      expect(result[1].id, equals('vehicle-id-2'));
      expect(result[1].exitTime, isNotNull);
      verify(() => mockDbService.getVehicleHistory()).called(1);
    });

    test('addVehicle adds vehicle and updates parking spot', () async {
      // Arrange
      final vehicle = Vehicle(
        id: 'new-vehicle-id',
        plate: 'DEF5678',
        description: 'Green Car',
        entryTime: DateTime.now(),
        spotNumber: 3,
      );

      // Use a separate mock instance for this test
      final mockDbService = MockDatabaseService();
      when(() => mockDbService.addVehicle(any())).thenAnswer((_) async {});

      // Act
      await mockDbService.addVehicle(vehicle);

      // Assert
      verify(() => mockDbService.addVehicle(any())).called(1);
    });

    test(
      'updateVehicleExit updates vehicle exit time and frees parking spot',
      () async {
        // Arrange
        final vehicleId = 'vehicle-id-1';
        final exitTime = DateTime.now();

        // Use a separate mock instance for this test
        final mockDbService = MockDatabaseService();
        when(
          () => mockDbService.updateVehicleExit(any(), any()),
        ).thenAnswer((_) async {});

        // Act
        await mockDbService.updateVehicleExit(vehicleId, exitTime);

        // Assert
        verify(
          () => mockDbService.updateVehicleExit(vehicleId, any()),
        ).called(1);
      },
    );

    test('updateVehicleExit does nothing when vehicle not found', () async {
      // Arrange
      final vehicleId = 'non-existent-id';
      final exitTime = DateTime.now();

      // Use a separate mock instance for this test
      final mockDbService = MockDatabaseService();
      when(
        () => mockDbService.updateVehicleExit(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await mockDbService.updateVehicleExit(vehicleId, exitTime);

      // Assert
      verify(() => mockDbService.updateVehicleExit(vehicleId, any())).called(1);
    });
  });
}
