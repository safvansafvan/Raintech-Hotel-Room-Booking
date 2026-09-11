import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/services/booking_calculator.dart';

void main() {
  final today = DateTime(2026, 9, 11, 18, 30);

  group('validateDates', () {
    test('accepts a valid stay beginning today', () {
      final error = BookingCalculator.validateDates(
        checkIn: DateTime(2026, 9, 11),
        checkOut: DateTime(2026, 9, 12),
        today: today,
      );

      expect(error, isNull);
    });

    test('rejects a past check-in date', () {
      final error = BookingCalculator.validateDates(
        checkIn: DateTime(2026, 9, 10),
        checkOut: DateTime(2026, 9, 12),
        today: today,
      );

      expect(error, BookingDateError.checkInInPast);
    });

    test('rejects same-day check-in and check-out', () {
      final error = BookingCalculator.validateDates(
        checkIn: DateTime(2026, 9, 12),
        checkOut: DateTime(2026, 9, 12),
        today: today,
      );

      expect(error, BookingDateError.checkOutNotAfterCheckIn);
    });

    test('rejects check-out before check-in', () {
      final error = BookingCalculator.validateDates(
        checkIn: DateTime(2026, 9, 13),
        checkOut: DateTime(2026, 9, 12),
        today: today,
      );

      expect(error, BookingDateError.checkOutNotAfterCheckIn);
    });

    test('reports missing dates in input order', () {
      expect(
        BookingCalculator.validateDates(
          checkIn: null,
          checkOut: null,
          today: today,
        ),
        BookingDateError.checkInRequired,
      );
      expect(
        BookingCalculator.validateDates(
          checkIn: today,
          checkOut: null,
          today: today,
        ),
        BookingDateError.checkOutRequired,
      );
    });
  });

  group('calculateNights', () {
    test('counts calendar nights across a month boundary', () {
      final nights = BookingCalculator.calculateNights(
        checkIn: DateTime(2026, 9, 30, 22),
        checkOut: DateTime(2026, 10, 2, 8),
      );

      expect(nights, 2);
    });

    test('counts nights across a leap day and year boundary', () {
      expect(
        BookingCalculator.calculateNights(
          checkIn: DateTime(2028, 2, 28),
          checkOut: DateTime(2028, 3, 1),
        ),
        2,
      );
      expect(
        BookingCalculator.calculateNights(
          checkIn: DateTime(2026, 12, 31),
          checkOut: DateTime(2027, 1, 2),
        ),
        2,
      );
    });

    test('rejects a non-positive stay', () {
      expect(
        () => BookingCalculator.calculateNights(
          checkIn: DateTime(2026, 9, 12),
          checkOut: DateTime(2026, 9, 12),
        ),
        throwsArgumentError,
      );
      expect(
        () => BookingCalculator.calculateNights(
          checkIn: DateTime(2026, 9, 13),
          checkOut: DateTime(2026, 9, 12),
        ),
        throwsArgumentError,
      );
    });
  });

  group('calculateTotalPrice', () {
    for (final (nights, rate, expectedTotal) in [
      (1, 3500, 3500),
      (3, 5800, 17400),
      (7, 4200, 29400),
    ]) {
      test('calculates $nights nights at ₹$rate', () {
        expect(
          BookingCalculator.calculateTotalPrice(
            nights: nights,
            pricePerNight: rate,
          ),
          expectedTotal,
        );
      });
    }

    test('rejects non-positive nights and rates', () {
      expect(
        () => BookingCalculator.calculateTotalPrice(
          nights: 0,
          pricePerNight: 3500,
        ),
        throwsArgumentError,
      );
      expect(
        () =>
            BookingCalculator.calculateTotalPrice(nights: 2, pricePerNight: 0),
        throwsArgumentError,
      );
    });
  });
}
