import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const AuthHeader({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (iconColor ?? const Color(0xFFE8829A)).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon!,
              size: 48,
              color: iconColor ?? const Color(0xFFE8829A),
            ),
          ),
          const SizedBox(height: 20),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2D2D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}