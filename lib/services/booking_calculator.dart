enum BookingDateError {
  checkInRequired('Please select a check-in date.'),
  checkOutRequired('Please select a check-out date.'),
  checkInInPast('Check-in cannot be in the past.'),
  checkOutNotAfterCheckIn('Check-out must be after check-in.');

  const BookingDateError(this.message);

  final String message;
}

abstract final class BookingCalculator {
  static BookingDateError? validateDates({
    required DateTime? checkIn,
    required DateTime? checkOut,
    DateTime? today,
  }) {
    if (checkIn == null) {
      return BookingDateError.checkInRequired;
    }
    if (checkOut == null) {
      return BookingDateError.checkOutRequired;
    }

    final checkInDay = _comparableDay(checkIn);
    final checkOutDay = _comparableDay(checkOut);
    final currentDay = _comparableDay(today ?? DateTime.now());

    if (checkInDay.isBefore(currentDay)) {
      return BookingDateError.checkInInPast;
    }
    if (!checkOutDay.isAfter(checkInDay)) {
      return BookingDateError.checkOutNotAfterCheckIn;
    }

    return null;
  }

  static int calculateNights({
    required DateTime checkIn,
    required DateTime checkOut,
  }) {
    final checkInDay = _comparableDay(checkIn);
    final checkOutDay = _comparableDay(checkOut);

    if (!checkOutDay.isAfter(checkInDay)) {
      throw ArgumentError.value(checkOut, 'checkOut', 'must be after check-in');
    }

    return checkOutDay.difference(checkInDay).inDays;
  }

  static int calculateTotalPrice({
    required int nights,
    required int pricePerNight,
  }) {
    if (nights <= 0) {
      throw ArgumentError.value(nights, 'nights', 'must be greater than zero');
    }
    if (pricePerNight <= 0) {
      throw ArgumentError.value(
        pricePerNight,
        'pricePerNight',
        'must be greater than zero',
      );
    }

    return nights * pricePerNight;
  }

  static DateTime calendarDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime _comparableDay(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day);
  }
}
