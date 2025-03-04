import 'package:flutter_test/flutter_test.dart';
import 'package:parking_control/models/vehicle.dart';

void main() {
  group('Vehicle', () {
    test('constructor creates instance with required parameters', () {
      final entryTime = DateTime.now();
      final vehicle = Vehicle(
        plate: 'ABC123',
        entryTime: entryTime,
        spotNumber: 1,
      );

      expect(vehicle.id, isNull);
      expect(vehicle.plate, equals('ABC123'));
      expect(vehicle.description, isNull);
      expect(vehicle.driver, isNull);
      expect(vehicle.entryTime, equals(entryTime));
      expect(vehicle.exitTime, isNull);
      expect(vehicle.spotNumber, equals(1));
    });

    test('constructor creates instance with all parameters', () {
      final entryTime = DateTime.now();
      final exitTime = entryTime.add(Duration(hours: 2));
      final vehicle = Vehicle(
        id: 'vehicle-123',
        plate: 'ABC123',
        description: 'Red Car',
        driver: 'John Doe',
        entryTime: entryTime,
        exitTime: exitTime,
        spotNumber: 1,
      );

      expect(vehicle.id, equals('vehicle-123'));
      expect(vehicle.plate, equals('ABC123'));
      expect(vehicle.description, equals('Red Car'));
      expect(vehicle.driver, equals('John Doe'));
      expect(vehicle.entryTime, equals(entryTime));
      expect(vehicle.exitTime, equals(exitTime));
      expect(vehicle.spotNumber, equals(1));
    });

    test('toMap converts instance to map correctly', () {
      final entryTime = DateTime.now();
      final exitTime = entryTime.add(Duration(hours: 2));
      final vehicle = Vehicle(
        id: 'vehicle-123',
        plate: 'ABC123',
        description: 'Red Car',
        driver: 'John Doe',
        entryTime: entryTime,
        exitTime: exitTime,
        spotNumber: 1,
      );

      final map = vehicle.toMap();

      expect(map['id'], equals('vehicle-123'));
      expect(map['plate'], equals('ABC123'));
      expect(map['description'], equals('Red Car'));
      expect(map['driver'], equals('John Doe'));
      expect(map['entry_time'], equals(entryTime.toIso8601String()));
      expect(map['exit_time'], equals(exitTime.toIso8601String()));
      expect(map['spot_number'], equals(1));
    });

    test('toMap handles null optional fields', () {
      final entryTime = DateTime.now();
      final vehicle = Vehicle(
        plate: 'ABC123',
        entryTime: entryTime,
        spotNumber: 1,
      );

      final map = vehicle.toMap();

      expect(map['id'], isNull);
      expect(map['plate'], equals('ABC123'));
      expect(map['description'], isNull);
      expect(map['driver'], isNull);
      expect(map['entry_time'], equals(entryTime.toIso8601String()));
      expect(map['exit_time'], isNull);
      expect(map['spot_number'], equals(1));
    });

    test('fromMap creates instance from map correctly', () {
      final entryTime = DateTime.now();
      final exitTime = entryTime.add(Duration(hours: 2));
      final map = {
        'id': 'vehicle-123',
        'plate': 'ABC123',
        'description': 'Red Car',
        'driver': 'John Doe',
        'entry_time': entryTime.toIso8601String(),
        'exit_time': exitTime.toIso8601String(),
        'spot_number': 1,
      };

      final vehicle = Vehicle.fromMap(map);

      expect(vehicle.id, equals('vehicle-123'));
      expect(vehicle.plate, equals('ABC123'));
      expect(vehicle.description, equals('Red Car'));
      expect(vehicle.driver, equals('John Doe'));
      expect(
        vehicle.entryTime.toIso8601String(),
        equals(entryTime.toIso8601String()),
      );
      expect(
        vehicle.exitTime?.toIso8601String(),
        equals(exitTime.toIso8601String()),
      );
      expect(vehicle.spotNumber, equals(1));
    });

    test('fromMap handles null optional fields', () {
      final entryTime = DateTime.now();
      final map = {
        'id': null,
        'plate': 'ABC123',
        'description': null,
        'driver': null,
        'entry_time': entryTime.toIso8601String(),
        'exit_time': null,
        'spot_number': 1,
      };

      final vehicle = Vehicle.fromMap(map);

      expect(vehicle.id, isNull);
      expect(vehicle.plate, equals('ABC123'));
      expect(vehicle.description, isNull);
      expect(vehicle.driver, isNull);
      expect(
        vehicle.entryTime.toIso8601String(),
        equals(entryTime.toIso8601String()),
      );
      expect(vehicle.exitTime, isNull);
      expect(vehicle.spotNumber, equals(1));
    });

    test('copyWith updates specified fields', () {
      final entryTime = DateTime.now();
      final original = Vehicle(
        id: 'vehicle-123',
        plate: 'ABC123',
        description: 'Red Car',
        driver: 'John Doe',
        entryTime: entryTime,
        spotNumber: 1,
      );

      final newExitTime = entryTime.add(Duration(hours: 2));
      final updated = original.copyWith(
        plate: 'XYZ789',
        description: 'Blue Car',
        driver: 'Jane Doe',
        exitTime: newExitTime,
        spotNumber: 2,
      );

      expect(updated.id, equals('vehicle-123')); // Unchanged
      expect(updated.plate, equals('XYZ789'));
      expect(updated.description, equals('Blue Car'));
      expect(updated.driver, equals('Jane Doe'));
      expect(updated.entryTime, equals(entryTime)); // Unchanged
      expect(updated.exitTime, equals(newExitTime));
      expect(updated.spotNumber, equals(2));
    });

    test('copyWith retains original values for null parameters', () {
      final entryTime = DateTime.now();
      final exitTime = entryTime.add(Duration(hours: 2));
      final original = Vehicle(
        id: 'vehicle-123',
        plate: 'ABC123',
        description: 'Red Car',
        driver: 'John Doe',
        entryTime: entryTime,
        exitTime: exitTime,
        spotNumber: 1,
      );

      final updated = original.copyWith();

      expect(updated.id, equals(original.id));
      expect(updated.plate, equals(original.plate));
      expect(updated.description, equals(original.description));
      expect(updated.driver, equals(original.driver));
      expect(updated.entryTime, equals(original.entryTime));
      expect(updated.exitTime, equals(original.exitTime));
      expect(updated.spotNumber, equals(original.spotNumber));
    });
  });
}
