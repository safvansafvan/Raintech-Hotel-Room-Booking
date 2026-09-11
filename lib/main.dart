import 'package:flutter/material.dart';
import 'package:hotel_room_booking/screens/booking_page.dart';
import 'package:hotel_room_booking/theme/app_theme.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raintech Hotel Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const BookingPage(),
    );
  }
}
