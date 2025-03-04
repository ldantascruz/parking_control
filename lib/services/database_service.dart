import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/vehicle.dart';
import '../models/parking_spot.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'parking_control.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles(
        id TEXT PRIMARY KEY,
        plate TEXT NOT NULL,
        description TEXT,
        driver TEXT,
        entry_time TEXT NOT NULL,
        exit_time TEXT,
        spot_number INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE parking_spots(
        number INTEGER PRIMARY KEY,
        is_occupied INTEGER NOT NULL,
        current_vehicle_id TEXT
      )
    ''');

    // Initialize parking spots
    for (int i = 1; i <= 20; i++) {
      await db.insert('parking_spots', {
        'number': i,
        'is_occupied': 0,
        'current_vehicle_id': null,
      });
    }
  }

  Future<List<ParkingSpot>> getAllParkingSpots() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parking_spots');
    return List.generate(maps.length, (i) => ParkingSpot.fromMap(maps[i]));
  }

  Future<List<Vehicle>> getActiveVehicles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'exit_time IS NULL',
    );
    return List.generate(maps.length, (i) => Vehicle.fromMap(maps[i]));
  }

  Future<List<Vehicle>> getVehicleHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      orderBy: 'entry_time DESC',
    );
    return List.generate(maps.length, (i) => Vehicle.fromMap(maps[i]));
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('vehicles', vehicle.toMap());
      await txn.update(
        'parking_spots',
        {'is_occupied': 1, 'current_vehicle_id': vehicle.id},
        where: 'number = ?',
        whereArgs: [vehicle.spotNumber],
      );
    });
  }

  Future<void> updateVehicleExit(String vehicleId, DateTime exitTime) async {
    final db = await database;
    await db.transaction((txn) async {
      final vehicle = await txn.query(
        'vehicles',
        where: 'id = ?',
        whereArgs: [vehicleId],
      );
      if (vehicle.isNotEmpty) {
        final spotNumber = vehicle.first['spot_number'] as int;
        await txn.update(
          'vehicles',
          {'exit_time': exitTime.toIso8601String()},
          where: 'id = ?',
          whereArgs: [vehicleId],
        );
        await txn.update(
          'parking_spots',
          {'is_occupied': 0, 'current_vehicle_id': null},
          where: 'number = ?',
          whereArgs: [spotNumber],
        );
      }
    });
  }

  Future<void> clearAllRecords() async {
    final db = await database;
    await db.transaction((txn) async {
      // Delete all vehicle records
      await txn.delete('vehicles');

      // Reset all parking spots to unoccupied
      await txn.update('parking_spots', {
        'is_occupied': 0,
        'current_vehicle_id': null,
      });
    });
  }
}
