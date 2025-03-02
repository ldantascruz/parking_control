class Vehicle {
  final String? id;
  final String plate;
  final String? description;
  final String? driver;
  final DateTime entryTime;
  DateTime? exitTime;
  final int spotNumber;

  Vehicle({
    this.id,
    required this.plate,
    this.description,
    this.driver,
    required this.entryTime,
    this.exitTime,
    required this.spotNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plate': plate,
      'description': description,
      'driver': driver,
      'entry_time': entryTime.toIso8601String(),
      'exit_time': exitTime?.toIso8601String(),
      'spot_number': spotNumber,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      plate: map['plate'],
      description: map['description'],
      driver: map['driver'],
      entryTime: DateTime.parse(map['entry_time']),
      exitTime: map['exit_time'] != null ? DateTime.parse(map['exit_time']) : null,
      spotNumber: map['spot_number'],
    );
  }

  Vehicle copyWith({
    String? id,
    String? plate,
    String? description,
    String? driver,
    DateTime? entryTime,
    DateTime? exitTime,
    int? spotNumber,
  }) {
    return Vehicle(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      description: description ?? this.description,
      driver: driver ?? this.driver,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      spotNumber: spotNumber ?? this.spotNumber,
    );
  }
}