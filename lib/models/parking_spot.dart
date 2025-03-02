class ParkingSpot {
  final int number;
  final bool isOccupied;
  final String? currentVehicleId;

  ParkingSpot({
    required this.number,
    this.isOccupied = false,
    this.currentVehicleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'is_occupied': isOccupied ? 1 : 0,
      'current_vehicle_id': currentVehicleId,
    };
  }

  factory ParkingSpot.fromMap(Map<String, dynamic> map) {
    return ParkingSpot(
      number: map['number'],
      isOccupied: map['is_occupied'] == 1,
      currentVehicleId: map['current_vehicle_id'],
    );
  }

  ParkingSpot copyWith({
    int? number,
    bool? isOccupied,
    String? currentVehicleId,
  }) {
    return ParkingSpot(
      number: number ?? this.number,
      isOccupied: isOccupied ?? this.isOccupied,
      currentVehicleId: currentVehicleId ?? this.currentVehicleId,
    );
  }
}