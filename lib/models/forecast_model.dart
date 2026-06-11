class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double pop; // probability of precipitation

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
          ((json['dt'] ?? 0) * 1000).toInt()),
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      condition: json['weather']?[0]?['main'] ?? 'Clear',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      humidity: (json['main']?['humidity'] ?? 0).toInt(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }
}

class ForecastModel {
  final List<ForecastItem> items;

  ForecastModel({required this.items});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>? ?? [];
    return ForecastModel(
      items: list.map((e) => ForecastItem.fromJson(e)).toList(),
    );
  }

  // Returns one entry per day (next 7 days) — picks noon reading
  List<ForecastItem> get dailyForecast {
    final Map<String, ForecastItem> dayMap = {};
    for (final item in items) {
      final key = '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      if (!dayMap.containsKey(key)) {
        dayMap[key] = item;
      } else {
        // prefer the reading closest to noon
        final existing = dayMap[key]!;
        final noonDiff = (item.dateTime.hour - 12).abs();
        final existingNoonDiff = (existing.dateTime.hour - 12).abs();
        if (noonDiff < existingNoonDiff) {
          dayMap[key] = item;
        }
      }
    }
    return dayMap.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  // First 8 items = hourly (3h intervals for 24h)
  List<ForecastItem> get hourlyForecast => items.take(8).toList();
}

class AqiModel {
  final int aqi;
  final double co;
  final double no2;
  final double o3;
  final double pm2_5;
  final double pm10;

  AqiModel({
    required this.aqi,
    required this.co,
    required this.no2,
    required this.o3,
    required this.pm2_5,
    required this.pm10,
  });

  factory AqiModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>? ?? [];
    if (list.isEmpty) {
      return AqiModel(aqi: 0, co: 0, no2: 0, o3: 0, pm2_5: 0, pm10: 0);
    }
    final first = list[0];
    final comp = first['components'] ?? {};
    return AqiModel(
      aqi: (first['main']?['aqi'] ?? 0).toInt(),
      co: (comp['co'] ?? 0).toDouble(),
      no2: (comp['no2'] ?? 0).toDouble(),
      o3: (comp['o3'] ?? 0).toDouble(),
      pm2_5: (comp['pm2_5'] ?? 0).toDouble(),
      pm10: (comp['pm10'] ?? 0).toDouble(),
    );
  }
}
