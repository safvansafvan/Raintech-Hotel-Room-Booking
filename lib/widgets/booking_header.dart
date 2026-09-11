import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;
        final logoSize = isCompact ? 48.0 : 56.0;

        return Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(isCompact ? 20 : 28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.navy, Color(0xFF0C6072)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.navy.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -58,
                top: -76,
                child: _DecorativeCircle(size: 180),
              ),
              Positioned(
                right: 94,
                bottom: -92,
                child: _DecorativeCircle(size: 132),
              ),
              Row(
                children: [
                  Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.hotel_rounded,
                      color: Colors.white,
                      size: isCompact ? 26 : 30,
                    ),
                  ),
                  SizedBox(width: isCompact ? 14 : 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RAINTECH HOTEL',
                          style: textTheme.labelLarge?.copyWith(
                            color: const Color(0xFFA8E1DA),
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find your perfect room',
                          style: textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontSize: isCompact ? 24 : 28,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Choose your stay dates and compare available rooms.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 22,
          color: Colors.white.withValues(alpha: 0.045),
        ),
      ),
    );
  }
}
