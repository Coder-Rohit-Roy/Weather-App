import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/providers/weather_provider.dart';

void main() {
  testWidgets('SkyFlow Weather App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ],
        child: const SkyFlowWeatherApp(),
      ),
    );

    // Verify that the AppBar is rendered.
    expect(find.byType(AppBar), findsOneWidget);
  });
}
