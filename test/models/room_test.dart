import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/models/room.dart';

void main() {
  group('Room', () {
    test('stores valid room details', () {
      final room = Room(
        code: 'R101',
        type: 'Deluxe Room',
        pricePerNight: 3500,
        maxGuests: 2,
      );

      expect(room.code, 'R101');
      expect(room.type, 'Deluxe Room');
      expect(room.pricePerNight, 3500);
      expect(room.maxGuests, 2);
    });

    test('rejects a non-positive nightly price', () {
      expect(
        () => Room(
          code: 'R101',
          type: 'Deluxe Room',
          pricePerNight: 0,
          maxGuests: 2,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a non-positive room capacity', () {
      expect(
        () => Room(
          code: 'R101',
          type: 'Deluxe Room',
          pricePerNight: 3500,
          maxGuests: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
