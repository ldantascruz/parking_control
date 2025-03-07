// Mocks generated by Mockito 5.4.5 from annotations
// in parking_control/test/widget/vehicle_entry_dialog_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:ui' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:parking_control/models/parking_spot.dart' as _i3;
import 'package:parking_control/models/vehicle.dart' as _i4;
import 'package:parking_control/viewmodels/parking_viewmodel.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ParkingViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockParkingViewModel extends _i1.Mock implements _i2.ParkingViewModel {
  MockParkingViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i3.ParkingSpot> get parkingSpots =>
      (super.noSuchMethod(
            Invocation.getter(#parkingSpots),
            returnValue: <_i3.ParkingSpot>[],
          )
          as List<_i3.ParkingSpot>);

  @override
  List<_i4.Vehicle> get activeVehicles =>
      (super.noSuchMethod(
            Invocation.getter(#activeVehicles),
            returnValue: <_i4.Vehicle>[],
          )
          as List<_i4.Vehicle>);

  @override
  List<_i4.Vehicle> get vehicleHistory =>
      (super.noSuchMethod(
            Invocation.getter(#vehicleHistory),
            returnValue: <_i4.Vehicle>[],
          )
          as List<_i4.Vehicle>);

  @override
  bool get isLoading =>
      (super.noSuchMethod(Invocation.getter(#isLoading), returnValue: false)
          as bool);

  @override
  List<_i3.ParkingSpot> get availableParkingSpots =>
      (super.noSuchMethod(
            Invocation.getter(#availableParkingSpots),
            returnValue: <_i3.ParkingSpot>[],
          )
          as List<_i3.ParkingSpot>);

  @override
  List<_i3.ParkingSpot> get occupiedParkingSpots =>
      (super.noSuchMethod(
            Invocation.getter(#occupiedParkingSpots),
            returnValue: <_i3.ParkingSpot>[],
          )
          as List<_i3.ParkingSpot>);

  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);

  @override
  _i5.Future<void> loadParkingSpots() =>
      (super.noSuchMethod(
            Invocation.method(#loadParkingSpots, []),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<void> loadActiveVehicles() =>
      (super.noSuchMethod(
            Invocation.method(#loadActiveVehicles, []),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<void> loadVehicleHistory() =>
      (super.noSuchMethod(
            Invocation.method(#loadVehicleHistory, []),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<bool> registerVehicleEntry(
    String? plate,
    String? description,
    String? driver,
    int? spotNumber,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#registerVehicleEntry, [
              plate,
              description,
              driver,
              spotNumber,
            ]),
            returnValue: _i5.Future<bool>.value(false),
          )
          as _i5.Future<bool>);

  @override
  _i5.Future<bool> registerVehicleExit(String? vehicleId) =>
      (super.noSuchMethod(
            Invocation.method(#registerVehicleExit, [vehicleId]),
            returnValue: _i5.Future<bool>.value(false),
          )
          as _i5.Future<bool>);

  @override
  _i4.Vehicle? getVehicleById(String? id) =>
      (super.noSuchMethod(Invocation.method(#getVehicleById, [id]))
          as _i4.Vehicle?);

  @override
  _i4.Vehicle? getVehicleBySpotNumber(int? spotNumber) =>
      (super.noSuchMethod(
            Invocation.method(#getVehicleBySpotNumber, [spotNumber]),
          )
          as _i4.Vehicle?);

  @override
  _i5.Future<bool> clearAllRecords() =>
      (super.noSuchMethod(
            Invocation.method(#clearAllRecords, []),
            returnValue: _i5.Future<bool>.value(false),
          )
          as _i5.Future<bool>);

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#addListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#removeListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );

  @override
  void notifyListeners() => super.noSuchMethod(
    Invocation.method(#notifyListeners, []),
    returnValueForMissingStub: null,
  );
}
