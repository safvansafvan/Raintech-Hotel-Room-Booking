import 'package:flutter/material.dart';

enum MessageTone { info, success, error }

class ValidationMessage extends StatelessWidget {
  const ValidationMessage({
    required this.message,
    required this.tone,
    super.key,
  });

  final String message;
  final MessageTone tone;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, foregroundColor, icon) = switch (tone) {
      MessageTone.info => (
        const Color(0xFFEAF1F7),
        const Color(0xFF123B5D),
        Icons.info_outline_rounded,
      ),
      MessageTone.success => (
        const Color(0xFFE7F5EF),
        const Color(0xFF176B52),
        Icons.check_circle_outline_rounded,
      ),
      MessageTone.error => (
        Theme.of(context).colorScheme.errorContainer,
        Theme.of(context).colorScheme.onErrorContainer,
        Icons.error_outline_rounded,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: foregroundColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
