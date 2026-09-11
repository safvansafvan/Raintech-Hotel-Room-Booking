import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/utils/booking_formatters.dart';

void main() {
  group('BookingFormatters', () {
    test('formats whole rupee amounts using Indian digit grouping', () {
      expect(BookingFormatters.currency(3500), '₹3,500');
      expect(BookingFormatters.currency(175000), '₹1,75,000');
    });

    test('formats dates without time values', () {
      expect(
        BookingFormatters.date(DateTime(2026, 9, 15, 14, 30)),
        '15 Sep 2026',
      );
    });

    test('formats a readable stay range', () {
      expect(
        BookingFormatters.dateRange(
          DateTime(2026, 9, 15),
          DateTime(2026, 9, 17),
        ),
        '15 Sep 2026 → 17 Sep 2026',
      );
    });
  });
}
