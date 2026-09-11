import 'package:intl/intl.dart';

abstract final class BookingFormatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    name: 'INR',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  static String currency(int amount) => _currencyFormat.format(amount);

  static String date(DateTime value) => _dateFormat.format(value);

  static String dateRange(DateTime checkIn, DateTime checkOut) {
    return '${date(checkIn)} → ${date(checkOut)}';
  }
}
