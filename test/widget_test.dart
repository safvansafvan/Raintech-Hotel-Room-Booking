import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/app.dart';
import 'package:hotel_room_booking/screens/booking_page.dart';

void main() {
  testWidgets('shows the booking layout and supplied rooms', (tester) async {
    await tester.pumpWidget(const HotelBookingApp());

    expect(find.text('Find your perfect room'), findsOneWidget);
    expect(find.text('Select stay dates'), findsOneWidget);
    expect(find.text('Choose a room'), findsOneWidget);
    expect(find.text('3. Booking summary'), findsOneWidget);
    expect(find.text('R101'), findsOneWidget);
    expect(find.text('R301'), findsOneWidget);
    expect(find.text('₹3,500'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses the desktop two-column layout on wide screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HotelBookingApp());

    expect(find.byKey(const Key('desktop-booking-content')), findsOneWidget);
    expect(find.byKey(const Key('mobile-booking-content')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses the stacked mobile layout on narrow screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HotelBookingApp());

    expect(find.byKey(const Key('mobile-booking-content')), findsOneWidget);
    expect(find.byKey(const Key('desktop-booking-content')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selects dates and a room, then shows nights and total', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: BookingPage(now: () => DateTime(2026, 9, 11))),
    );

    await tester.tap(find.byKey(const Key('check-in-date-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('15 Sep 2026'), findsOneWidget);
    expect(find.text('Please select a check-out date.'), findsNWidgets(2));

    await tester.tap(find.byKey(const Key('check-out-date-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('18'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('R201'));
    await tester.pumpAndSettle();

    expect(find.text('15 Sep 2026 → 18 Sep 2026'), findsOneWidget);
    expect(find.text('3 nights selected.'), findsOneWidget);
    expect(find.text('R201 — Executive Suite'), findsOneWidget);
    expect(find.text('₹17,400'), findsOneWidget);
    expect(find.text('Total calculated for 3 nights.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
