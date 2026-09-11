import 'room.dart';

/// A valid stay request for a selected [room].
///
/// Check-in and check-out are normalized to local calendar dates so later
/// calculations are not affected by time-of-day values.
class Booking {
  Booking({
    required this.room,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    this.guestCount = 1,
  }) : checkInDate = _dateOnly(checkInDate),
       checkOutDate = _dateOnly(checkOutDate) {
    if (!this.checkOutDate.isAfter(this.checkInDate)) {
      throw ArgumentError.value(
        checkOutDate,
        'checkOutDate',
        'must be after check-in',
      );
    }
    if (guestCount <= 0) {
      throw ArgumentError.value(
        guestCount,
        'guestCount',
        'must be greater than zero',
      );
    }
    if (guestCount > room.maxGuests) {
      throw ArgumentError.value(
        guestCount,
        'guestCount',
        'must not exceed the room capacity of ${room.maxGuests}',
      );
    }
  }

  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Booking &&
            room == other.room &&
            checkInDate == other.checkInDate &&
            checkOutDate == other.checkOutDate &&
            guestCount == other.guestCount;
  }

  @override
  int get hashCode {
    return Object.hash(room, checkInDate, checkOutDate, guestCount);
  }

  @override
  String toString() {
    return 'Booking(room: ${room.code}, checkInDate: $checkInDate, '
        'checkOutDate: $checkOutDate, guestCount: $guestCount)';
  }
}
