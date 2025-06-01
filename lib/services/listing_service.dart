import '../models/listing.dart';

class ListingService {
  static final ListingService _instance = ListingService._internal();
  factory ListingService() => _instance;
  ListingService._internal();

  final List<Listing> _listings = [
    // Sample data with vehicle information
    Listing(
      id: '1',
      driverName: 'John Tan',
      pickupPoint: 'Tampines Hub',
      destination: 'Temasek Polytechnic',
      cost: 5.50,
      seats: 2,
      departureTime: DateTime.now().add(Duration(hours: 1)),
      availableSeats: 2,
      carModel: 'Toyota Camry',
      licensePlate: 'SBA1234X',
    ),
    Listing(
      id: '2', 
      driverName: 'Sarah Lim',
      pickupPoint: 'Bedok Mall',
      destination: 'Singapore Polytechnic',
      cost: 6.00,
      seats: 2,
      departureTime: DateTime.now().add(Duration(hours: 2)),
      availableSeats: 1,
      carModel: 'Honda Civic',
      licensePlate: 'SGX5678Y',
    ),
    Listing(
      id: '3',
      driverName: 'Michael Wong',
      pickupPoint: 'Jurong East',
      destination: 'NTU',
      cost: 7.20,
      seats: 2,
      departureTime: DateTime.now().add(Duration(hours: 3)),
      availableSeats: 3,
      carModel: 'Mazda 3',
      licensePlate: 'SCD9012Z',
    ),
  ];

  List<Listing> getAllListings() {
    return _listings.where((listing) => listing.isActive).toList();
  }

  List<Listing> getDriverListings(String driverName) {
    return _listings.where((listing) => 
      listing.driverName == driverName && listing.isActive).toList();
  }

  void addListing(Listing listing) {
    _listings.add(listing);
  }

  void updateListing(String id, Listing updatedListing) {
    final index = _listings.indexWhere((listing) => listing.id == id);
    if (index != -1) {
      _listings[index] = updatedListing;
    }
  }

  void deleteListing(String id) {
    final index = _listings.indexWhere((listing) => listing.id == id);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(isActive: false);
    }
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
} 