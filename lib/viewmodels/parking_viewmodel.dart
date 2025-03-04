import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/parking_spot.dart';
import '../models/vehicle.dart';
import '../services/database_service.dart';

class ParkingViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  final _uuid = const Uuid();

  List<ParkingSpot> _parkingSpots = [];
  List<Vehicle> _activeVehicles = [];
  List<Vehicle> _vehicleHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ParkingSpot> get parkingSpots => _parkingSpots;
  List<Vehicle> get activeVehicles => _activeVehicles;
  List<Vehicle> get vehicleHistory => _vehicleHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor
  ParkingViewModel({
    DatabaseService? databaseService,
    bool initializeData = true,
  }) : _databaseService = databaseService ?? DatabaseService() {
    if (initializeData) {
      _initData();
    }
  }

  // Initialize data
  Future<void> _initData() async {
    await loadParkingSpots();
    await loadActiveVehicles();
    await loadVehicleHistory();
  }

  // Load parking spots
  Future<void> loadParkingSpots() async {
    _setLoading(true);
    try {
      _parkingSpots = await _databaseService.getAllParkingSpots();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load parking spots: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Load active vehicles
  Future<void> loadActiveVehicles() async {
    _setLoading(true);
    try {
      _activeVehicles = await _databaseService.getActiveVehicles();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load active vehicles: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Load vehicle history
  Future<void> loadVehicleHistory() async {
    _setLoading(true);
    try {
      _vehicleHistory = await _databaseService.getVehicleHistory();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load vehicle history: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Register vehicle entry
  Future<bool> registerVehicleEntry(
    String plate,
    String? description,
    String? driver,
    int spotNumber,
  ) async {
    _setLoading(true);
    try {
      // Check if spot is available
      final spot = _parkingSpots.firstWhere(
        (spot) => spot.number == spotNumber,
        orElse: () => throw Exception('Parking spot not found'),
      );

      if (spot.isOccupied) {
        throw Exception('Parking spot is already occupied');
      }

      // Create new vehicle
      final vehicle = Vehicle(
        id: _uuid.v4(),
        plate: plate,
        description: description,
        driver: driver,
        entryTime: DateTime.now(),
        spotNumber: spotNumber,
      );

      // Add to database
      await _databaseService.addVehicle(vehicle);

      // Refresh data
      await _initData();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to register vehicle: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register vehicle exit
  Future<bool> registerVehicleExit(String vehicleId) async {
    _setLoading(true);
    try {
      await _databaseService.updateVehicleExit(vehicleId, DateTime.now());

      // Refresh data
      await _initData();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to register vehicle exit: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get available parking spots
  List<ParkingSpot> get availableParkingSpots =>
      _parkingSpots.where((spot) => !spot.isOccupied).toList();

  // Get occupied parking spots
  List<ParkingSpot> get occupiedParkingSpots =>
      _parkingSpots.where((spot) => spot.isOccupied).toList();

  // Get vehicle by ID
  Vehicle? getVehicleById(String id) {
    try {
      return _activeVehicles.firstWhere((vehicle) => vehicle.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get vehicle by spot number
  Vehicle? getVehicleBySpotNumber(int spotNumber) {
    try {
      return _activeVehicles.firstWhere(
        (vehicle) => vehicle.spotNumber == spotNumber,
      );
    } catch (e) {
      return null;
    }
  }

  // Clear all records
  Future<bool> clearAllRecords() async {
    _setLoading(true);
    try {
      await _databaseService.clearAllRecords();

      // Refresh data
      await _initData();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to clear records: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
