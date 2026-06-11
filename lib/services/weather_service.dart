import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../utils/constants.dart';

class WeatherService {
  final String _apiKey = AppConstants.apiKey;

  // ── Current weather by city name ─────────────────────────
  Future<WeatherModel> fetchWeatherByCity(String city, String unit) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/weather?q=$city&appid=$_apiKey&units=$unit');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }

  // ── Current weather by coordinates ───────────────────────
  Future<WeatherModel> fetchWeatherByCoords(
      double lat, double lon, String unit) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=$unit');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // ── 5-day / 3-hour forecast ───────────────────────────────
  Future<ForecastModel> fetchForecastByCity(String city, String unit) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/forecast?q=$city&appid=$_apiKey&units=$unit&cnt=40');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ForecastModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  Future<ForecastModel> fetchForecastByCoords(
      double lat, double lon, String unit) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=$unit&cnt=40');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ForecastModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  // ── Air Quality Index ─────────────────────────────────────
  Future<AqiModel> fetchAqi(double lat, double lon) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/air_pollution?lat=$lat&lon=$lon&appid=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return AqiModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load AQI');
    }
  }

  // ── City suggestions (geocoding) ─────────────────────────
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    if (query.length < 2) return [];
    final url = Uri.parse(
        '${AppConstants.geoUrl}/direct?q=$query&limit=5&appid=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }
}
