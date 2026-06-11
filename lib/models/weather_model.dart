class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final double windDeg;
  final int pressure;
  final int visibility;
  final String condition;
  final String description;
  final String icon;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime dateTime;
  final double lat;
  final double lon;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.pressure,
    required this.visibility,
    required this.condition,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      humidity: (json['main']?['humidity'] ?? 0).toInt(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      windDeg: (json['wind']?['deg'] ?? 0).toDouble(),
      pressure: (json['main']?['pressure'] ?? 0).toInt(),
      visibility: (json['visibility'] ?? 0).toInt(),
      condition: json['weather']?[0]?['main'] ?? 'Clear',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          ((json['sys']?['sunrise'] ?? 0) * 1000).toInt()),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          ((json['sys']?['sunset'] ?? 0) * 1000).toInt()),
      dateTime: DateTime.fromMillisecondsSinceEpoch(
          ((json['dt'] ?? 0) * 1000).toInt()),
      lat: (json['coord']?['lat'] ?? 0).toDouble(),
      lon: (json['coord']?['lon'] ?? 0).toDouble(),
    );
  }
}
