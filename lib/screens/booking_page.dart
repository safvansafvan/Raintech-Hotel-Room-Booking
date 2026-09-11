import 'package:flutter/material.dart';

import '../data/room_data.dart';
import '../models/room.dart';
import '../services/booking_calculator.dart';
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

  DateTime get _today => BookingCalculator.calendarDate(widget.now());

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
    });
  }

  void _selectRoom(Room room) {
    setState(() {
      _selectedRoom = room;
    });
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
    );

    final roomList = RoomList(
      rooms: sampleRooms,
      selectedRoom: _selectedRoom,
      onRoomSelected: _selectRoom,
    );
    final summary = BookingSummaryCard(
      room: _selectedRoom == null
          ? 'Not selected'
          : '${_selectedRoom!.code} — ${_selectedRoom!.type}',
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
  }) {
    if (hasStartedDateSelection && dateError != null) {
      return (dateError.message, MessageTone.error);
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
