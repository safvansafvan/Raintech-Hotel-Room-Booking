import '../models/booking.dart';
import '../models/room.dart';
import 'room_data.dart';

Room _roomWithCode(String code) {
  return sampleRooms.singleWhere((room) => room.code == code);
}

final List<Booking> existingBookings = List.unmodifiable([
  Booking(
    room: _roomWithCode('R101'),
    checkInDate: DateTime(2027, 1, 15),
    checkOutDate: DateTime(2027, 1, 18),
    guestCount: 2,
  ),
  Booking(
    room: _roomWithCode('R201'),
    checkInDate: DateTime(2027, 1, 20),
    checkOutDate: DateTime(2027, 1, 23),
    guestCount: 3,
  ),
]);
