import '../models/room.dart';

final List<Room> sampleRooms = List.unmodifiable([
  Room(code: 'R101', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(code: 'R102', type: 'Deluxe Room', pricePerNight: 3500, maxGuests: 2),
  Room(
    code: 'R201',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(
    code: 'R202',
    type: 'Executive Suite',
    pricePerNight: 5800,
    maxGuests: 3,
  ),
  Room(code: 'R301', type: 'Family Room', pricePerNight: 4200, maxGuests: 4),
]);
