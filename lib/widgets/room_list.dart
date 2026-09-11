import 'package:flutter/material.dart';

import '../models/room.dart';
import 'room_card.dart';
import 'validation_message.dart';

class RoomList extends StatelessWidget {
  const RoomList({
    required this.rooms,
    required this.guestCount,
    super.key,
    this.selectedRoom,
    this.unavailableRoomCodes = const {},
    this.availabilityChecked = false,
    this.message,
    this.onRoomSelected,
  });

  final List<Room> rooms;
  final int guestCount;
  final Room? selectedRoom;
  final Set<String> unavailableRoomCodes;
  final bool availabilityChecked;
  final String? message;
  final ValueChanged<Room>? onRoomSelected;

  @override
  Widget build(BuildContext context) {
    final availableCount = rooms
        .where((room) => !unavailableRoomCodes.contains(room.code))
        .length;
    final countLabel = availabilityChecked
        ? '$availableCount available'
        : '${rooms.length} ${rooms.length == 1 ? 'room' : 'rooms'}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Choose a room',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    countLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Showing rooms for $guestCount '
              '${guestCount == 1 ? 'guest' : 'guests'}.',
            ),
            if (message != null) ...[
              const SizedBox(height: 14),
              ValidationMessage(message: message!, tone: MessageTone.error),
            ],
            const SizedBox(height: 18),
            if (rooms.isEmpty)
              const _EmptyRoomList()
            else
              for (var index = 0; index < rooms.length; index++) ...[
                RoomCard(
                  key: ValueKey('room-${rooms[index].code}'),
                  room: rooms[index],
                  isSelected: rooms[index] == selectedRoom,
                  isAvailable: !unavailableRoomCodes.contains(
                    rooms[index].code,
                  ),
                  onTap:
                      onRoomSelected == null ||
                          unavailableRoomCodes.contains(rooms[index].code)
                      ? null
                      : () => onRoomSelected!(rooms[index]),
                ),
                if (index != rooms.length - 1) const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}

class _EmptyRoomList extends StatelessWidget {
  const _EmptyRoomList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Icon(Icons.meeting_room_outlined, size: 32),
          SizedBox(height: 8),
          Text(
            'No rooms can accommodate this guest count.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
