import 'package:flutter/material.dart';

import 'validation_message.dart';

class DateSelectionCard extends StatelessWidget {
  const DateSelectionCard({
    super.key,
    this.checkInDate,
    this.checkOutDate,
    this.onCheckInTap,
    this.onCheckOutTap,
    required this.guestCount,
    this.onDecreaseGuests,
    this.onIncreaseGuests,
    this.message,
    this.messageTone = MessageTone.info,
  });

  final String? checkInDate;
  final String? checkOutDate;
  final VoidCallback? onCheckInTap;
  final VoidCallback? onCheckOutTap;
  final int guestCount;
  final VoidCallback? onDecreaseGuests;
  final VoidCallback? onIncreaseGuests;
  final String? message;
  final MessageTone messageTone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeading(
              number: '1',
              title: 'Select stay dates',
              subtitle: 'Tell us when you would like to stay.',
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final checkInField = _DateField(
                  key: const Key('check-in-date-field'),
                  label: 'Check-in',
                  value: checkInDate,
                  onTap: onCheckInTap,
                );
                final checkOutField = _DateField(
                  key: const Key('check-out-date-field'),
                  label: 'Check-out',
                  value: checkOutDate,
                  onTap: onCheckOutTap,
                );
                final guestField = _GuestField(
                  guestCount: guestCount,
                  onDecrease: onDecreaseGuests,
                  onIncrease: onIncreaseGuests,
                );

                if (constraints.maxWidth < 520) {
                  return Column(
                    children: [
                      checkInField,
                      const SizedBox(height: 14),
                      checkOutField,
                      const SizedBox(height: 14),
                      guestField,
                    ],
                  );
                }

                if (constraints.maxWidth < 850) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: checkInField),
                          const SizedBox(width: 16),
                          Expanded(child: checkOutField),
                        ],
                      ),
                      const SizedBox(height: 14),
                      guestField,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: checkInField),
                    const SizedBox(width: 16),
                    Expanded(child: checkOutField),
                    const SizedBox(width: 16),
                    Expanded(child: guestField),
                  ],
                );
              },
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              ValidationMessage(message: message!, tone: messageTone),
            ],
          ],
        ),
      ),
    );
  }
}

class _GuestField extends StatelessWidget {
  const _GuestField({
    required this.guestCount,
    this.onDecrease,
    this.onIncrease,
  });

  final int guestCount;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final guestLabel = '$guestCount ${guestCount == 1 ? 'guest' : 'guests'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        border: Border.all(color: const Color(0xFFDCE3E8)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(Icons.group_outlined, color: colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guests', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 3),
                Text(
                  guestLabel,
                  key: const Key('guest-count-label'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          IconButton(
            key: const Key('decrease-guests'),
            onPressed: onDecrease,
            tooltip: 'Remove guest',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded),
          ),
          IconButton(
            key: const Key('increase-guests'),
            onPressed: onIncrease,
            tooltip: 'Add guest',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, super.key, this.value, this.onTap});

  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: Material(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDCE3E8)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value ?? 'Select date',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: value == null
                                  ? const Color(0xFF798692)
                                  : const Color(0xFF14212B),
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF798692),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primary,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
