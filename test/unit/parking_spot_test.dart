import 'package:flutter_test/flutter_test.dart';
import 'package:parking_control/models/parking_spot.dart';

void main() {
  group('ParkingSpot', () {
    test('constructor creates instance with required parameters', () {
      final spot = ParkingSpot(number: 1);
      
      expect(spot.number, equals(1));
      expect(spot.isOccupied, isFalse);
      expect(spot.currentVehicleId, isNull);
    });

    test('constructor creates instance with all parameters', () {
      final spot = ParkingSpot(
        number: 1,
        isOccupied: true,
        currentVehicleId: 'vehicle-123',
      );
      
      expect(spot.number, equals(1));
      expect(spot.isOccupied, isTrue);
      expect(spot.currentVehicleId, equals('vehicle-123'));
    });

    test('toMap converts instance to map correctly', () {
      final spot = ParkingSpot(
        number: 1,
        isOccupied: true,
        currentVehicleId: 'vehicle-123',
      );
      
      final map = spot.toMap();
      
      expect(map['number'], equals(1));
      expect(map['is_occupied'], equals(1));
      expect(map['current_vehicle_id'], equals('vehicle-123'));
    });

    test('toMap handles null currentVehicleId', () {
      final spot = ParkingSpot(number: 1);
      final map = spot.toMap();
      
      expect(map['number'], equals(1));
      expect(map['is_occupied'], equals(0));
      expect(map['current_vehicle_id'], isNull);
    });

    test('fromMap creates instance from map correctly', () {
      final map = {
        'number': 1,
        'is_occupied': 1,
        'current_vehicle_id': 'vehicle-123',
      };
      
      final spot = ParkingSpot.fromMap(map);
      
      expect(spot.number, equals(1));
      expect(spot.isOccupied, isTrue);
      expect(spot.currentVehicleId, equals('vehicle-123'));
    });

    test('fromMap handles null currentVehicleId', () {
      final map = {
        'number': 1,
        'is_occupied': 0,
        'current_vehicle_id': null,
      };
      
      final spot = ParkingSpot.fromMap(map);
      
      expect(spot.number, equals(1));
      expect(spot.isOccupied, isFalse);
      expect(spot.currentVehicleId, isNull);
    });

    test('copyWith updates specified fields', () {
      final original = ParkingSpot(
        number: 1,
        isOccupied: false,
        currentVehicleId: null,
      );
      
      final updated = original.copyWith(
        number: 2,
        isOccupied: true,
        currentVehicleId: 'vehicle-123',
      );
      
      expect(updated.number, equals(2));
      expect(updated.isOccupied, isTrue);
      expect(updated.currentVehicleId, equals('vehicle-123'));
    });

    test('copyWith retains original values for null parameters', () {
      final original = ParkingSpot(
        number: 1,
        isOccupied: true,
        currentVehicleId: 'vehicle-123',
      );
      
      final updated = original.copyWith();
      
      expect(updated.number, equals(original.number));
      expect(updated.isOccupied, equals(original.isOccupied));
      expect(updated.currentVehicleId, equals(original.currentVehicleId));
    });
  });
}