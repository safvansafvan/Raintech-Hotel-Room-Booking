import '../models/booking.dart';
import '../models/room.dart';

abstract final class RoomAvailabilityService {
  static bool isRoomAvailable({
    required Room room,
    required DateTime checkIn,
    required DateTime checkOut,
    required Iterable<Booking> existingBookings,
  }) {
    _validateStay(checkIn: checkIn, checkOut: checkOut);

    return existingBookings
        .where((booking) => booking.room.code == room.code)
        .every(
          (booking) => !datesOverlap(
            checkIn: checkIn,
            checkOut: checkOut,
            bookedCheckIn: booking.checkInDate,
            bookedCheckOut: booking.checkOutDate,
          ),
        );
  }

  static Set<String> unavailableRoomCodes({
    required DateTime checkIn,
    required DateTime checkOut,
    required Iterable<Booking> existingBookings,
  }) {
    _validateStay(checkIn: checkIn, checkOut: checkOut);

    return Set.unmodifiable(
      existingBookings
          .where(
            (booking) => datesOverlap(
              checkIn: checkIn,
              checkOut: checkOut,
              bookedCheckIn: booking.checkInDate,
              bookedCheckOut: booking.checkOutDate,
            ),
          )
          .map((booking) => booking.room.code),
    );
  }

  static bool datesOverlap({
    required DateTime checkIn,
    required DateTime checkOut,
    required DateTime bookedCheckIn,
    required DateTime bookedCheckOut,
  }) {
    final requestedStart = _calendarDay(checkIn);
    final requestedEnd = _calendarDay(checkOut);
    final bookedStart = _calendarDay(bookedCheckIn);
    final bookedEnd = _calendarDay(bookedCheckOut);

    return requestedStart.isBefore(bookedEnd) &&
        requestedEnd.isAfter(bookedStart);
  }

  static void _validateStay({
    required DateTime checkIn,
    required DateTime checkOut,
  }) {
    if (!_calendarDay(checkOut).isAfter(_calendarDay(checkIn))) {
      throw ArgumentError.value(checkOut, 'checkOut', 'must be after check-in');
    }
  }

  static DateTime _calendarDay(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day);
  }
}
