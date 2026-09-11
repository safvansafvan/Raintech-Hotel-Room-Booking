import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/data/existing_bookings.dart';

void main() {
  test('contains the hardcoded bookings used by availability checks', () {
    expect(existingBookings, hasLength(2));
    expect(
      existingBookings.map(
        (booking) =>
            (booking.room.code, booking.checkInDate, booking.checkOutDate),
      ),
      [
        ('R101', DateTime(2027, 1, 15), DateTime(2027, 1, 18)),
        ('R201', DateTime(2027, 1, 20), DateTime(2027, 1, 23)),
      ],
    );
  });
}
