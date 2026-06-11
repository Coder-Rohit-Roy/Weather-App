import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isDark = weatherProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme switch card
          _buildSettingsCard(
            isDark,
            child: SwitchListTile(
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? Colors.yellow : Colors.orange,
              ),
              title: Text(
                'Dark Mode',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                'Toggle dark and light application interfaces',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              value: isDark,
              onChanged: (bool value) {
                weatherProvider.toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 12),

          // Unit switch card
          _buildSettingsCard(
            isDark,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.thermostat_rounded,
                        color: isDark ? Colors.tealAccent : Colors.teal,
                        size: 26,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Temperature Units',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Select Metric (°C) or Imperial (°F)',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: weatherProvider.unit,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    underline: const SizedBox.shrink(),
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'metric',
                        child: Text('Metric (°C)'),
                      ),
                      DropdownMenuItem(
                        value: 'imperial',
                        child: Text('Imperial (°F)'),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        weatherProvider.setUnit(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // API Information card
          _buildSettingsCard(
            isDark,
            child: ListTile(
              leading: Icon(
                Icons.api_rounded,
                color: isDark ? Colors.blueAccent[100] : Colors.blue,
              ),
              title: Text(
                'API Integration Status',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                AppConstants.apiKey == 'YOUR_API_KEY'
                    ? 'SkyFlow Demo Mode (Mock Weather Engaged)'
                    : 'OpenWeatherMap API Engaged',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppConstants.apiKey == 'YOUR_API_KEY' ? Colors.orangeAccent : Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, {required Widget child}) {
    return Card(
      color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
      ),
      elevation: 0,
      child: child,
    );
  }
}
