import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const WeatherInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 26,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8), // Cyber-Natural muted silver-gray
          ),
        ),
      ],
    );
  }
}
