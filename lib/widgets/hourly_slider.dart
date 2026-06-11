import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../utils/weather_utils.dart';
import 'glass_card.dart';

class HourlySlider extends StatelessWidget {
  final List<ForecastItem> items;

  const HourlySlider({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Hourly Forecast',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final timeStr = DateFormat('h a').format(item.dateTime);
              final isCurrent = index == 0;

              return Container(
                width: 90,
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == items.length - 1 ? 16 : 0,
                  top: 8,
                  bottom: 8,
                ),
                child: GlassCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  borderRadius: 16,
                  color: isCurrent ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isCurrent ? 'Now' : timeStr,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                          color: isCurrent ? Colors.white : Colors.white70,
                        ),
                      ),
                      Text(
                        WeatherUtils.getWeatherEmoji(item.condition),
                        style: const TextStyle(fontSize: 26),
                      ),
                      Text(
                        '${item.temperature.toStringAsFixed(0)}°',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
