import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/data/existing_bookings.dart';
import 'package:hotel_room_booking/data/room_data.dart';
import 'package:hotel_room_booking/services/room_availability_service.dart';

void main() {
  final deluxeRoom = sampleRooms.singleWhere((room) => room.code == 'R101');
  final otherRoom = sampleRooms.singleWhere((room) => room.code == 'R102');

  group('isRoomAvailable', () {
    test('rejects a stay that overlaps an existing room booking', () {
      final isAvailable = RoomAvailabilityService.isRoomAvailable(
        room: deluxeRoom,
        checkIn: DateTime(2027, 1, 16),
        checkOut: DateTime(2027, 1, 17),
        existingBookings: existingBookings,
      );

      expect(isAvailable, isFalse);
    });

    test('allows back-to-back stays', () {
      expect(
        RoomAvailabilityService.isRoomAvailable(
          room: deluxeRoom,
          checkIn: DateTime(2027, 1, 12),
          checkOut: DateTime(2027, 1, 15),
          existingBookings: existingBookings,
        ),
        isTrue,
      );
      expect(
        RoomAvailabilityService.isRoomAvailable(
          room: deluxeRoom,
          checkIn: DateTime(2027, 1, 18),
          checkOut: DateTime(2027, 1, 20),
          existingBookings: existingBookings,
        ),
        isTrue,
      );
    });

    test('does not block another room for the same dates', () {
      expect(
        RoomAvailabilityService.isRoomAvailable(
          room: otherRoom,
          checkIn: DateTime(2027, 1, 16),
          checkOut: DateTime(2027, 1, 17),
          existingBookings: existingBookings,
        ),
        isTrue,
      );
    });

    test('rejects an invalid requested stay', () {
      expect(
        () => RoomAvailabilityService.isRoomAvailable(
          room: deluxeRoom,
          checkIn: DateTime(2027, 1, 16),
          checkOut: DateTime(2027, 1, 16),
          existingBookings: existingBookings,
        ),
        throwsArgumentError,
      );
    });
  });

  test('returns every unavailable room code for the requested stay', () {
    final unavailableCodes = RoomAvailabilityService.unavailableRoomCodes(
      checkIn: DateTime(2027, 1, 16),
      checkOut: DateTime(2027, 1, 22),
      existingBookings: existingBookings,
    );

    expect(unavailableCodes, {'R101', 'R201'});
  });
}
