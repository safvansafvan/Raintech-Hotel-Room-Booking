import 'package:intl/intl.dart';

/// Presentation-only formatters for booking values.
///
/// Domain models keep money as integers and dates as [DateTime] values. This
/// class is the single place where those values are converted into text for
/// the UI.
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
