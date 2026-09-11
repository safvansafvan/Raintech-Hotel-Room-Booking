import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/data/room_data.dart';

void main() {
  test('contains the five rooms from the coding exercise', () {
    expect(sampleRooms, hasLength(5));
    expect(sampleRooms.map((room) => room.code), [
      'R101',
      'R102',
      'R201',
      'R202',
      'R301',
    ]);
  });

  test('contains the supplied price and capacity for each room type', () {
    expect(
      sampleRooms.map(
        (room) => (room.code, room.type, room.pricePerNight, room.maxGuests),
      ),
      [
        ('R101', 'Deluxe Room', 3500, 2),
        ('R102', 'Deluxe Room', 3500, 2),
        ('R201', 'Executive Suite', 5800, 3),
        ('R202', 'Executive Suite', 5800, 3),
        ('R301', 'Family Room', 4200, 4),
      ],
    );
  });

  test('does not expose a mutable room list', () {
    expect(() => sampleRooms.clear(), throwsUnsupportedError);
  });
}
