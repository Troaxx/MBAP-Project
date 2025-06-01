import '../models/listing.dart';

// singleton service to manage passenger booking state
// tracks current active booking and provides state management
// allows passengers to book and cancel rides
class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  // current active booking (null if no booking)
  Listing? _currentBooking;
  
  // getter for current booking
  Listing? get currentBooking => _currentBooking;
  
  // check if passenger has an active booking
  bool get hasActiveBooking => _currentBooking != null;
  
  // book a ride
  void bookRide(Listing listing) {
    _currentBooking = listing;
  }
  
  // cancel current booking
  void cancelBooking() {
    _currentBooking = null;
  }
  
  // complete current ride
  void completeRide() {
    _currentBooking = null;
  }
} 