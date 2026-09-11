import 'package:flutter/material.dart';

import 'screens/booking_page.dart';
import 'theme/app_theme.dart';

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
