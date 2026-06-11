import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'glass_card.dart';

class SunCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunCard({super.key, required this.sunrise, required this.sunset});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final format = DateFormat('h:mm a');
    final sunriseStr = format.format(sunrise);
    final sunsetStr = format.format(sunset);

    // Calculate progress fraction of the day
    double progress = 0.0;
    final totalDayMinutes = sunset.difference(sunrise).inMinutes;
    if (totalDayMinutes > 0) {
      final currentMinutes = now.difference(sunrise).inMinutes;
      progress = (currentMinutes / totalDayMinutes).clamp(0.0, 1.0);
    }

    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sun Tracking Arc',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: SunArcPainter(progress: progress),
                  ),
                ),
                // Glowing sun symbol positioned along the arc
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sunrise',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              sunriseStr,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Sunset',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              sunsetStr,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SunArcPainter extends CustomPainter {
  final double progress;

  SunArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Center arc box
    final rect = Rect.fromLTRB(16, 20, size.width - 16, size.height * 2 - 20);

    // Draw background dashed/solid arc
    paint.color = Colors.white.withOpacity(0.12);
    canvas.drawArc(rect, math.pi, math.pi, false, paint);

    // Draw active progress path
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.amber[400]!,
          Colors.orange[500]!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawArc(rect, math.pi, math.pi * progress, false, pathPaint);

    // Draw Sun circle position
    final double angle = math.pi + (math.pi * progress);
    final double radiusX = (size.width - 32) / 2;
    final double radiusY = (size.height * 2 - 40) / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height;

    final sunX = centerX + radiusX * math.cos(angle);
    final sunY = centerY + radiusY * math.sin(angle) - 10; // offset slightly for visually centering

    // Draw glowing sun halo
    final sunHaloPaint = Paint()
      ..color = Colors.amber.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(sunX, sunY), 16.0, sunHaloPaint);

    // Draw sun core
    final sunCorePaint = Paint()..color = Colors.amber[600]!;
    canvas.drawCircle(Offset(sunX, sunY), 7.0, sunCorePaint);
  }

  @override
  bool shouldRepaint(covariant SunArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
