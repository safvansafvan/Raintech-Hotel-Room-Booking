import 'package:flutter/material.dart';

class DateSelectionCard extends StatelessWidget {
  const DateSelectionCard({
    super.key,
    this.checkInDate,
    this.checkOutDate,
    this.onCheckInTap,
    this.onCheckOutTap,
  });

  final String? checkInDate;
  final String? checkOutDate;
  final VoidCallback? onCheckInTap;
  final VoidCallback? onCheckOutTap;

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
                final stackFields = constraints.maxWidth < 600;
                final checkInField = _DateField(
                  label: 'Check-in',
                  value: checkInDate,
                  onTap: onCheckInTap,
                );
                final checkOutField = _DateField(
                  label: 'Check-out',
                  value: checkOutDate,
                  onTap: onCheckOutTap,
                );

                if (stackFields) {
                  return Column(
                    children: [
                      checkInField,
                      const SizedBox(height: 14),
                      checkOutField,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: checkInField),
                    const SizedBox(width: 16),
                    Expanded(child: checkOutField),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, this.value, this.onTap});

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
