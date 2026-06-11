import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/forecast_model.dart';
import '../utils/weather_utils.dart';
import 'glass_card.dart';

class AqiCard extends StatelessWidget {
  final AqiModel aqi;

  const AqiCard({super.key, required this.aqi});

  @override
  Widget build(BuildContext context) {
    if (aqi.aqi == 0) return const SizedBox.shrink();
    
    final label = WeatherUtils.getAqiLabel(aqi.aqi);
    final aqiColor = WeatherUtils.getAqiColor(aqi.aqi);

    // Calculate dynamic slider position based on 1 to 5 index range
    final double sliderFraction = ((aqi.aqi - 1) / 4.0).clamp(0.0, 1.0);

    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Air Quality Index',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Health & Pollution Levels',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: aqiColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: aqiColor.withOpacity(0.4),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: aqiColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  'AQI $aqi.aqi - $label',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: aqiColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Glow Progress Bar Slider
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.lightGreen,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ],
                  ),
                ),
              ),
              // Needle Indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn,
                alignment: FractionalOffset(sliderFraction, 0.5),
                child: Container(
                  height: 14,
                  width: 14,
                  transform: Matrix4.translationValues(0, -4, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: aqiColor.withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(
                      color: aqiColor,
                      width: 3.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pollutants detailed stats grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPollutantItem('PM2.5', '${aqi.pm2_5.toStringAsFixed(1)}', 'Fine'),
              _buildPollutantItem('PM10', '${aqi.pm10.toStringAsFixed(1)}', 'Coarse'),
              _buildPollutantItem('CO', '${aqi.co.toStringAsFixed(0)}', 'Carbon'),
              _buildPollutantItem('O3', '${aqi.o3.toStringAsFixed(1)}', 'Ozone'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantItem(String name, String value, String subLabel) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'µg/m³',
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          subLabel,
          style: GoogleFonts.outfit(
            fontSize: 10,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
