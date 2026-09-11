import 'package:flutter/material.dart';

import '../data/existing_bookings.dart';
import '../data/room_data.dart';
import '../models/room.dart';
import '../services/booking_calculator.dart';
import '../services/room_availability_service.dart';
import '../theme/app_theme.dart';
import '../utils/booking_formatters.dart';
import '../widgets/booking_header.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/date_selection_card.dart';
import '../widgets/room_list.dart';
import '../widgets/validation_message.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, this.now = DateTime.now});

  final DateTime Function() now;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static const double _desktopBreakpoint = 900;

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Room? _selectedRoom;
  int _guestCount = 1;
  String? _roomMessage;

  DateTime get _today => BookingCalculator.calendarDate(widget.now());

  int get _maximumGuestCount => sampleRooms.fold(
    1,
    (maximum, room) => room.maxGuests > maximum ? room.maxGuests : maximum,
  );

  Future<void> _selectCheckInDate() async {
    final today = _today;
    final initialDate = _checkInDate == null || _checkInDate!.isBefore(today)
        ? today
        : _checkInDate!;
    final pickedDate = await showDatePicker(
      context: context,
      helpText: 'Select check-in date',
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 4, 12, 31),
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _checkInDate = BookingCalculator.calendarDate(pickedDate);
      _roomMessage = null;
      _clearUnavailableSelectedRoom();
    });
  }

  Future<void> _selectCheckOutDate() async {
    final today = _today;
    final suggestedDate =
        _checkInDate?.add(const Duration(days: 1)) ??
        today.add(const Duration(days: 1));
    final initialDate = _checkOutDate == null || _checkOutDate!.isBefore(today)
        ? suggestedDate
        : _checkOutDate!;
    final pickedDate = await showDatePicker(
      context: context,
      helpText: 'Select check-out date',
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 5, 12, 31),
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _checkOutDate = BookingCalculator.calendarDate(pickedDate);
      _roomMessage = null;
      _clearUnavailableSelectedRoom();
    });
  }

  void _selectRoom(Room room) {
    if (room.maxGuests < _guestCount) {
      setState(() {
        _roomMessage =
            '${room.code} cannot accommodate $_guestCount guests. '
            'Please select another room.';
      });
      return;
    }
    if (!_isRoomAvailableForSelectedDates(room)) {
      setState(() {
        _roomMessage =
            '${room.code} is already booked for these dates. '
            'Please select another room.';
      });
      return;
    }

    setState(() {
      _selectedRoom = room;
      _roomMessage = null;
    });
  }

  void _changeGuestCount(int difference) {
    final nextGuestCount = _guestCount + difference;
    if (nextGuestCount < 1 || nextGuestCount > _maximumGuestCount) {
      return;
    }

    setState(() {
      _guestCount = nextGuestCount;
      _roomMessage = null;

      if (_selectedRoom case final selectedRoom?
          when selectedRoom.maxGuests < nextGuestCount) {
        _selectedRoom = null;
        _roomMessage =
            '${selectedRoom.code} cannot accommodate $nextGuestCount guests. '
            'Please select another room.';
      }
    });
  }

  void _clearUnavailableSelectedRoom() {
    final selectedRoom = _selectedRoom;
    if (selectedRoom == null) {
      return;
    }

    if (!_isRoomAvailableForSelectedDates(selectedRoom)) {
      _selectedRoom = null;
      _roomMessage =
          '${selectedRoom.code} is already booked for these dates. '
          'Please select another room.';
    }
  }

  bool _isRoomAvailableForSelectedDates(Room room) {
    final dateError = BookingCalculator.validateDates(
      checkIn: _checkInDate,
      checkOut: _checkOutDate,
      today: _today,
    );
    if (dateError != null) {
      return true;
    }

    return RoomAvailabilityService.isRoomAvailable(
      room: room,
      checkIn: _checkInDate!,
      checkOut: _checkOutDate!,
      existingBookings: existingBookings,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateError = BookingCalculator.validateDates(
      checkIn: _checkInDate,
      checkOut: _checkOutDate,
      today: _today,
    );
    final hasStartedDateSelection =
        _checkInDate != null || _checkOutDate != null;
    final datesAreValid = dateError == null;
    final filteredRooms = sampleRooms
        .where((room) => room.maxGuests >= _guestCount)
        .toList(growable: false);
    final unavailableRoomCodes = datesAreValid
        ? RoomAvailabilityService.unavailableRoomCodes(
            checkIn: _checkInDate!,
            checkOut: _checkOutDate!,
            existingBookings: existingBookings,
          )
        : const <String>{};
    final nights = datesAreValid
        ? BookingCalculator.calculateNights(
            checkIn: _checkInDate!,
            checkOut: _checkOutDate!,
          )
        : null;
    final total = nights != null && _selectedRoom != null
        ? BookingCalculator.calculateTotalPrice(
            nights: nights,
            pricePerNight: _selectedRoom!.pricePerNight,
          )
        : null;

    final dateMessage = !hasStartedDateSelection
        ? null
        : dateError?.message ??
              '$nights ${nights == 1 ? 'night' : 'nights'} selected.';
    final dateMessageTone = dateError == null
        ? MessageTone.success
        : MessageTone.error;

    final (summaryMessage, summaryTone) = _summaryStatus(
      dateError: dateError,
      hasStartedDateSelection: hasStartedDateSelection,
      nights: nights,
      total: total,
      roomMessage: _roomMessage,
    );

    final roomList = RoomList(
      rooms: filteredRooms,
      guestCount: _guestCount,
      selectedRoom: _selectedRoom,
      unavailableRoomCodes: unavailableRoomCodes,
      availabilityChecked: datesAreValid,
      message: _roomMessage,
      onRoomSelected: _selectRoom,
    );
    final summary = BookingSummaryCard(
      room: _selectedRoom == null
          ? 'Not selected'
          : '${_selectedRoom!.code} — ${_selectedRoom!.type}',
      guests: '$_guestCount ${_guestCount == 1 ? 'guest' : 'guests'}',
      stay: _stayLabel,
      nights: nights?.toString() ?? '—',
      pricePerNight: _selectedRoom == null
          ? '—'
          : BookingFormatters.currency(_selectedRoom!.pricePerNight),
      total: total == null ? '—' : BookingFormatters.currency(total),
      message: summaryMessage,
      messageTone: summaryTone,
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDF3F6), AppTheme.background],
            stops: [0, 0.42],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
              final pagePadding = isDesktop
                  ? 32.0
                  : constraints.maxWidth >= 600
                  ? 24.0
                  : 16.0;

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
                        DateSelectionCard(
                          checkInDate: _checkInDate == null
                              ? null
                              : BookingFormatters.date(_checkInDate!),
                          checkOutDate: _checkOutDate == null
                              ? null
                              : BookingFormatters.date(_checkOutDate!),
                          onCheckInTap: _selectCheckInDate,
                          onCheckOutTap: _selectCheckOutDate,
                          guestCount: _guestCount,
                          onDecreaseGuests: _guestCount > 1
                              ? () => _changeGuestCount(-1)
                              : null,
                          onIncreaseGuests: _guestCount < _maximumGuestCount
                              ? () => _changeGuestCount(1)
                              : null,
                          message: dateMessage,
                          messageTone: dateMessageTone,
                        ),
                        const SizedBox(height: 24),
                        if (isDesktop)
                          Row(
                            key: const Key('desktop-booking-content'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: roomList),
                              const SizedBox(width: 24),
                              SizedBox(width: 350, child: summary),
                            ],
                          )
                        else
                          Column(
                            key: const Key('mobile-booking-content'),
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              roomList,
                              const SizedBox(height: 24),
                              summary,
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
      ),
    );
  }

  String get _stayLabel {
    if (_checkInDate == null && _checkOutDate == null) {
      return 'Select dates';
    }
    if (_checkInDate == null) {
      return 'Select check-in → ${BookingFormatters.date(_checkOutDate!)}';
    }
    if (_checkOutDate == null) {
      return '${BookingFormatters.date(_checkInDate!)} → Select check-out';
    }

    return BookingFormatters.dateRange(_checkInDate!, _checkOutDate!);
  }

  (String, MessageTone) _summaryStatus({
    required BookingDateError? dateError,
    required bool hasStartedDateSelection,
    required int? nights,
    required int? total,
    required String? roomMessage,
  }) {
    if (hasStartedDateSelection && dateError != null) {
      return (dateError.message, MessageTone.error);
    }
    if (roomMessage != null) {
      return (roomMessage, MessageTone.error);
    }
    if (!hasStartedDateSelection && _selectedRoom == null) {
      return (
        'Select your stay dates and a room to calculate the total.',
        MessageTone.info,
      );
    }
    if (nights == null) {
      return (
        'Select valid stay dates to calculate the total.',
        MessageTone.info,
      );
    }
    if (total == null) {
      return ('Select a room to calculate the total.', MessageTone.info);
    }

    return (
      'Total calculated for $nights ${nights == 1 ? 'night' : 'nights'}.',
      MessageTone.success,
    );
  }
}
