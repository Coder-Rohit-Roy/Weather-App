import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../utils/weather_utils.dart';
import 'glass_card.dart';

class WeeklyForecast extends StatelessWidget {
  final List<ForecastItem> items;

  const WeeklyForecast({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-Day Forecast',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.08),
                height: 24,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final dayStr = DateFormat('EEEE').format(item.dateTime);
                final dateStr = DateFormat('d MMM').format(item.dateTime);
                final isToday = index == 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Day name
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isToday ? 'Today' : dayStr,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            dateStr,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon + pop probability
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text(
                            WeatherUtils.getWeatherEmoji(item.condition),
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 8),
                          if (item.pop > 0.1)
                            Text(
                              '${(item.pop * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent[100],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Temp Range
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${item.tempMax.toStringAsFixed(0)}°',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${item.tempMin.toStringAsFixed(0)}°',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
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
