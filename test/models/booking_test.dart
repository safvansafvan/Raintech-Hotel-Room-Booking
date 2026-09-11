import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/models/booking.dart';
import 'package:hotel_room_booking/models/room.dart';

void main() {
  final room = Room(
    code: 'R101',
    type: 'Deluxe Room',
    pricePerNight: 3500,
    maxGuests: 2,
  );

  group('Booking', () {
    test('normalizes check-in and check-out to calendar dates', () {
      final booking = Booking(
        room: room,
        checkInDate: DateTime(2026, 9, 15, 14, 30),
        checkOutDate: DateTime(2026, 9, 17, 10),
        guestCount: 2,
      );

      expect(booking.checkInDate, DateTime(2026, 9, 15));
      expect(booking.checkOutDate, DateTime(2026, 9, 17));
    });

    test('rejects check-out on the check-in date', () {
      expect(
        () => Booking(
          room: room,
          checkInDate: DateTime(2026, 9, 15),
          checkOutDate: DateTime(2026, 9, 15),
        ),
        throwsArgumentError,
      );
    });

    test('rejects check-out before check-in', () {
      expect(
        () => Booking(
          room: room,
          checkInDate: DateTime(2026, 9, 15),
          checkOutDate: DateTime(2026, 9, 14),
        ),
        throwsArgumentError,
      );
    });

    test('rejects a guest count above the room capacity', () {
      expect(
        () => Booking(
          room: room,
          checkInDate: DateTime(2026, 9, 15),
          checkOutDate: DateTime(2026, 9, 17),
          guestCount: 3,
        ),
        throwsArgumentError,
      );
    });
  });
}
