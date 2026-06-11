import 'package:flutter/material.dart';

class WeatherUtils {
  // ── Weather condition → icon string (emoji) ──────────────
  static String getWeatherEmoji(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('thunderstorm')) return '⛈️';
    if (c.contains('drizzle')) return '🌦️';
    if (c.contains('rain')) return '🌧️';
    if (c.contains('snow')) return '❄️';
    if (c.contains('mist') || c.contains('fog') || c.contains('haze')) return '🌫️';
    if (c.contains('clear')) return '☀️';
    if (c.contains('cloud')) return '☁️';
    return '🌈';
  }

  // ── Weather condition → gradient colours ─────────────────
  static List<Color> getWeatherGradient(String condition, bool isDark) {
    final c = condition.toLowerCase();
    if (isDark) {
      if (c.contains('thunderstorm')) return [const Color(0xFF1A1A2E), const Color(0xFF2D1B69)];
      if (c.contains('rain') || c.contains('drizzle')) return [const Color(0xFF0D1B2A), const Color(0xFF1B3A5C)];
      if (c.contains('snow')) return [const Color(0xFF1A2332), const Color(0xFF2C3E50)];
      if (c.contains('clear')) return [const Color(0xFF0A1628), const Color(0xFF1A3050)];
      if (c.contains('cloud')) return [const Color(0xFF1C2331), const Color(0xFF2C3E50)];
      return [const Color(0xFF0A0A1A), const Color(0xFF1A1A3A)];
    } else {
      if (c.contains('thunderstorm')) return [const Color(0xFF4A4E69), const Color(0xFF9A8C98)];
      if (c.contains('rain') || c.contains('drizzle')) return [const Color(0xFF2B6CB0), const Color(0xFF63B3ED)];
      if (c.contains('snow')) return [const Color(0xFFBEE3F8), const Color(0xFFEBF8FF)];
      if (c.contains('clear')) return [const Color(0xFF2563EB), const Color(0xFF60A5FA)];
      if (c.contains('cloud')) return [const Color(0xFF4A5568), const Color(0xFF718096)];
      return [const Color(0xFF3B82F6), const Color(0xFF93C5FD)];
    }
  }

  // ── AQI label & colour ───────────────────────────────────
  static String getAqiLabel(int aqi) {
    switch (aqi) {
      case 1: return 'Good';
      case 2: return 'Fair';
      case 3: return 'Moderate';
      case 4: return 'Poor';
      case 5: return 'Very Poor';
      default: return 'N/A';
    }
  }

  static Color getAqiColor(int aqi) {
    switch (aqi) {
      case 1: return Colors.green;
      case 2: return Colors.lightGreen;
      case 3: return Colors.yellow[700]!;
      case 4: return Colors.orange;
      case 5: return Colors.red;
      default: return Colors.grey;
    }
  }

  // ── Wind direction ────────────────────────────────────────
  static String getWindDirection(double deg) {
    if (deg >= 337.5 || deg < 22.5) return 'N';
    if (deg < 67.5) return 'NE';
    if (deg < 112.5) return 'E';
    if (deg < 157.5) return 'SE';
    if (deg < 202.5) return 'S';
    if (deg < 247.5) return 'SW';
    if (deg < 292.5) return 'W';
    return 'NW';
  }

  // ── UV Index label ────────────────────────────────────────
  static String getUvLabel(double uvi) {
    if (uvi < 3) return 'Low';
    if (uvi < 6) return 'Moderate';
    if (uvi < 8) return 'High';
    if (uvi < 11) return 'Very High';
    return 'Extreme';
  }

  static Color getUvColor(double uvi) {
    if (uvi < 3) return Colors.green;
    if (uvi < 6) return Colors.yellow[700]!;
    if (uvi < 8) return Colors.orange;
    if (uvi < 11) return Colors.deepOrange;
    return Colors.purple;
  }
}
