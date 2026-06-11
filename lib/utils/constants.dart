// ============================================================
//  constants.dart
//  Replace YOUR_API_KEY with your OpenWeatherMap API key.
//  Get one free at: https://openweathermap.org/api
// ============================================================

class AppConstants {
  // ── API ──────────────────────────────────────────────────
  static const String apiKey = 'd9fb7f7b849c5359096ceea81bbcab13';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoUrl = 'https://api.openweathermap.org/geo/1.0';
  static const String iconBaseUrl = 'https://openweathermap.org/img/wn';

  // ── SharedPreferences keys ───────────────────────────────
  static const String prefTheme = 'is_dark_mode';
  static const String prefUnit = 'unit'; // 'metric' or 'imperial'
  static const String prefFavourites = 'favourite_cities';
  static const String prefLastCity = 'last_city';

  // ── Default settings ────────────────────────────────────
  static const String defaultCity = 'Durgapur';
  static const String defaultUnit = 'metric';
}
