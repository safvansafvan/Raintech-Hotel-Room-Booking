import 'package:flutter/material.dart';

import '../data/room_data.dart';
import '../widgets/booking_header.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/date_selection_card.dart';
import '../widgets/room_list.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  static const double _desktopBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
            final pagePadding = isDesktop ? 32.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BookingHeader(),
                      const SizedBox(height: 24),
                      const DateSelectionCard(),
                      const SizedBox(height: 24),
                      if (isDesktop)
                        Row(
                          key: const Key('desktop-booking-content'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: RoomList(rooms: sampleRooms)),
                            const SizedBox(width: 24),
                            const SizedBox(
                              width: 350,
                              child: BookingSummaryCard(),
                            ),
                          ],
                        )
                      else
                        Column(
                          key: const Key('mobile-booking-content'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RoomList(rooms: sampleRooms),
                            const SizedBox(height: 24),
                            const BookingSummaryCard(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
