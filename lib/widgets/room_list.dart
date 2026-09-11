import 'package:flutter/material.dart';

import '../models/room.dart';
import 'room_card.dart';

class RoomList extends StatelessWidget {
  const RoomList({
    required this.rooms,
    super.key,
    this.selectedRoom,
    this.onRoomSelected,
  });

  final List<Room> rooms;
  final Room? selectedRoom;
  final ValueChanged<Room>? onRoomSelected;

  @override
  Widget build(BuildContext context) {
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
                    '${rooms.length} rooms',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Select one room for your stay.'),
            const SizedBox(height: 18),
            for (var index = 0; index < rooms.length; index++) ...[
              RoomCard(
                room: rooms[index],
                isSelected: rooms[index] == selectedRoom,
                onTap: onRoomSelected == null
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
