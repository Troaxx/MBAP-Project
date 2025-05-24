class Listing {
  final String id;
  final String driverName;
  final String pickupPoint;
  final String destination;
  final double cost;
  final DateTime departureTime;
  final int availableSeats;
  final bool isActive;

  Listing({
    required this.id,
    required this.driverName,
    required this.pickupPoint,
    required this.destination,
    required this.cost,
    required this.departureTime,
    this.availableSeats = 4,
    this.isActive = true,
  });

  Listing copyWith({
    String? id,
    String? driverName,
    String? pickupPoint,
    String? destination,
    double? cost,
    DateTime? departureTime,
    int? availableSeats,
    bool? isActive,
  }) {
    return Listing(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      destination: destination ?? this.destination,
      cost: cost ?? this.cost,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      isActive: isActive ?? this.isActive,
    );
  }
} 