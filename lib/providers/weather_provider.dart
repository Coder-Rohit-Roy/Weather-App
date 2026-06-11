import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  // ── States ───────────────────────────────────────────────
  WeatherModel? _currentWeather;
  ForecastModel? _forecast;
  AqiModel? _aqi;
  
  bool _isLoading = false;
  String _error = '';
  
  bool _isDarkMode = true;
  String _unit = AppConstants.defaultUnit;
  List<String> _favourites = [];
  String _currentCity = AppConstants.defaultCity;

  // ── Getters ──────────────────────────────────────────────
  WeatherModel? get currentWeather => _currentWeather;
  ForecastModel? get forecast => _forecast;
  AqiModel? get aqi => _aqi;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isDarkMode => _isDarkMode;
  String get unit => _unit;
  List<String> get favourites => _favourites;
  String get currentCity => _currentCity;

  // ── Constructor ──────────────────────────────────────────
  WeatherProvider() {
    _loadSettings();
  }

  // ── Preferences Management ──────────────────────────────
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(AppConstants.prefTheme) ?? true;
    _unit = prefs.getString(AppConstants.prefUnit) ?? AppConstants.defaultUnit;
    _favourites = prefs.getStringList(AppConstants.prefFavourites) ?? [];
    _currentCity = prefs.getString(AppConstants.prefLastCity) ?? AppConstants.defaultCity;
    notifyListeners();
    
    // Fetch initial weather
    fetchWeatherByCity(_currentCity);
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefTheme, _isDarkMode);
  }

  Future<void> setUnit(String newUnit) async {
    if (_unit == newUnit) return;
    _unit = newUnit;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefUnit, _unit);
    
    // Refresh weather with new units
    if (_currentWeather != null) {
      fetchWeatherByCity(_currentWeather!.cityName);
    }
  }

  Future<void> toggleFavourite(String city) async {
    if (_favourites.contains(city)) {
      _favourites.remove(city);
    } else {
      _favourites.add(city);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.prefFavourites, _favourites);
  }

  bool isFavourite(String city) {
    return _favourites.any((element) => element.toLowerCase() == city.toLowerCase());
  }

  // ── API Operations ───────────────────────────────────────
  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (AppConstants.apiKey == 'YOUR_API_KEY') {
        // Fallback to rich Mock Data for instant amazing UX!
        await Future.delayed(const Duration(milliseconds: 800));
        _loadMockData(city);
      } else {
        final weather = await _weatherService.fetchWeatherByCity(city, _unit);
        _currentWeather = weather;
        _currentCity = weather.cityName;
        
        // Save as last city
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.prefLastCity, _currentCity);

        // Fetch forecast & AQI in parallel
        final forecastData = await _weatherService.fetchForecastByCity(city, _unit);
        _forecast = forecastData;

        final aqiData = await _weatherService.fetchAqi(weather.lat, weather.lon);
        _aqi = aqiData;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception:', '').trim();
      // If error occurs, fall back to mock data anyway if key is default or offline, but show a user friendly notice
      if (_currentWeather == null) {
        _loadMockData(city);
        _error = "Showing offline demo for '$city' (Make sure you set your API key in constants.dart)";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      if (AppConstants.apiKey == 'YOUR_API_KEY') {
        await Future.delayed(const Duration(milliseconds: 800));
        _loadMockData('My Location');
      } else {
        final weather = await _weatherService.fetchWeatherByCoords(
            position.latitude, position.longitude, _unit);
        _currentWeather = weather;
        _currentCity = weather.cityName;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.prefLastCity, _currentCity);

        final forecastData = await _weatherService.fetchForecastByCoords(
            position.latitude, position.longitude, _unit);
        _forecast = forecastData;

        final aqiData = await _weatherService.fetchAqi(position.latitude, position.longitude);
        _aqi = aqiData;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception:', '').trim();
      if (_currentWeather == null) {
        _loadMockData('My Location');
        _error = "GPS Location: ${e.toString().replaceAll('Exception:', '')}. Showing demo weather.";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Mock Data Generator ──────────────────────────────────
  void _loadMockData(String city) {
    final now = DateTime.now();
    final tempUnit = _unit == 'metric' ? 31.0 : 87.8;
    final feelsLikeUnit = _unit == 'metric' ? 33.5 : 92.3;
    final windSpeedUnit = _unit == 'metric' ? 4.2 : 9.4;

    _currentWeather = WeatherModel(
      cityName: city == 'My Location' ? 'Durgapur' : city,
      country: 'IN',
      temperature: tempUnit,
      feelsLike: feelsLikeUnit,
      tempMin: tempUnit - 3.0,
      tempMax: tempUnit + 2.5,
      humidity: 65,
      windSpeed: windSpeedUnit,
      windDeg: 120.0,
      pressure: 1012,
      visibility: 8000,
      condition: 'Clouds',
      description: 'scattered clouds',
      icon: '03d',
      sunrise: now.subtract(const Duration(hours: 6)),
      sunset: now.add(const Duration(hours: 5)),
      dateTime: now,
      lat: 23.5204,
      lon: 87.3119,
    );

    // Build Mock Forecast (8 hourly items, 7 daily items)
    final List<ForecastItem> forecastItems = [];
    
    // Hourly
    for (int i = 0; i < 24; i += 3) {
      forecastItems.add(
        ForecastItem(
          dateTime: now.add(Duration(hours: i)),
          temperature: tempUnit - (i * 0.4),
          tempMin: tempUnit - 3.0,
          tempMax: tempUnit + 2.0,
          condition: i % 6 == 0 ? 'Rain' : 'Clouds',
          description: i % 6 == 0 ? 'light rain' : 'broken clouds',
          icon: i % 6 == 0 ? '10d' : '02d',
          humidity: 70 + i,
          windSpeed: windSpeedUnit + (i * 0.1),
          pop: i % 6 == 0 ? 0.8 : 0.2,
        ),
      );
    }

    // Daily next 7 days
    for (int i = 1; i <= 7; i++) {
      forecastItems.add(
        ForecastItem(
          dateTime: now.add(Duration(days: i)),
          temperature: tempUnit + (i % 2 == 0 ? 1.0 : -1.5),
          tempMin: tempUnit - 4.0,
          tempMax: tempUnit + 3.0,
          condition: i % 3 == 0 ? 'Clear' : (i % 3 == 1 ? 'Clouds' : 'Rain'),
          description: i % 3 == 0 ? 'clear sky' : (i % 3 == 1 ? 'scattered clouds' : 'moderate rain'),
          icon: i % 3 == 0 ? '01d' : (i % 3 == 1 ? '03d' : '10d'),
          humidity: 60 + i,
          windSpeed: windSpeedUnit + (i * 0.2),
          pop: i % 3 == 2 ? 0.75 : 0.1,
        ),
      );
    }

    _forecast = ForecastModel(items: forecastItems);
    
    _aqi = AqiModel(
      aqi: 2, // Fair
      co: 320.4,
      no2: 12.1,
      o3: 45.8,
      pm2_5: 18.5,
      pm10: 28.2,
    );
  }
}
