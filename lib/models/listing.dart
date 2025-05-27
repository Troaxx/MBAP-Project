class Listing {
  final String id;
  final String driverName;
  final String pickupPoint;
  final String destination;
  final double cost;
  final int seats;
  final DateTime departureTime;
  final int availableSeats;
  final bool isActive;

  Listing({
    required this.id,
    required this.driverName,
    required this.pickupPoint,
    required this.destination,
    required this.cost,
    required this.seats,
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
    int? seats,
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
      seats: seats ?? this.seats,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      isActive: isActive ?? this.isActive,
    );
  }
} 