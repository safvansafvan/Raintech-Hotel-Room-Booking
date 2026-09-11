import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/booking_formatters.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    required this.room,
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  final Room room;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = isSelected
        ? colorScheme.secondary
        : colorScheme.primary;
    final borderColor = isSelected
        ? colorScheme.secondary
        : const Color(0xFFDDE4E9);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${room.code}, ${room.type}',
      child: Material(
        color: isSelected
            ? colorScheme.secondary.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 340;

                return Row(
                  children: [
                    if (!isCompact) ...[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isSelected ? Icons.check_rounded : Icons.bed_outlined,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                room.code,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  room.type,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.group_outlined,
                                size: 17,
                                color: Color(0xFF6D7A85),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  isCompact
                                      ? '${room.maxGuests} guests'
                                      : 'Up to ${room.maxGuests} guests',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          BookingFormatters.currency(room.pricePerNight),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: colorScheme.primary),
                        ),
                        Text(
                          'per night',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
