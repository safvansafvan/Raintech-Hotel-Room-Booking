import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_booking/app.dart';

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
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HotelBookingApp());

    expect(find.byKey(const Key('mobile-booking-content')), findsOneWidget);
    expect(find.byKey(const Key('desktop-booking-content')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
