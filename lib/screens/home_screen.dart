import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/weather_info_tile.dart';
import '../widgets/hourly_slider.dart';
import '../widgets/weekly_forecast.dart';
import '../widgets/aqi_card.dart';
import '../widgets/sun_card.dart';
import '../widgets/weather_animation.dart';
import 'search_screen.dart';
import 'favourites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isDark = weatherProvider.isDarkMode;
    
    // Fallback condition if weather isn't loaded yet
    final condition = weatherProvider.currentWeather?.condition ?? 'Clear';
    final gradientColors = WeatherUtils.getWeatherGradient(condition, isDark);

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed_rounded),
            tooltip: 'Use Current Location',
            onPressed: () {
              weatherProvider.fetchWeatherByLocation();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Detecting GPS location...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search City',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.1),
            onRefresh: () async {
              if (weatherProvider.currentWeather != null) {
                await weatherProvider.fetchWeatherByCity(weatherProvider.currentWeather!.cityName);
              }
            },
            child: weatherProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 800), // Responsive design constraint for Web
                            child: Column(
                              children: [
                                // Error notification box
                                if (weatherProvider.error.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.warning_amber_rounded, color: Colors.white),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              weatherProvider.error,
                                              style: GoogleFonts.outfit(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                if (weatherProvider.currentWeather != null) ...[
                                  _buildHeaderSection(context, weatherProvider),
                                  const SizedBox(height: 12),
                                  _buildMainTempSection(weatherProvider),
                                  const SizedBox(height: 24),
                                  _buildDetailedGrid(weatherProvider),
                                  const SizedBox(height: 16),
                                  if (weatherProvider.forecast != null)
                                    HourlySlider(items: weatherProvider.forecast!.hourlyForecast),
                                  const SizedBox(height: 16),
                                  if (weatherProvider.aqi != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: AqiCard(aqi: weatherProvider.aqi!),
                                    ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: SunCard(
                                      sunrise: weatherProvider.currentWeather!.sunrise,
                                      sunset: weatherProvider.currentWeather!.sunset,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (weatherProvider.forecast != null)
                                    WeeklyForecast(items: weatherProvider.forecast!.dailyForecast),
                                ],
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ── Header (City Name, Country, Date, Favourites Icon) ───────────────────
  Widget _buildHeaderSection(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final dateStr = DateFormat('EEEE, d MMMM').format(weather.dateTime);
    final isFav = provider.isFavourite(weather.cityName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    '${weather.cityName}, ${weather.country}',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.redAccent : Colors.white,
              size: 28,
            ),
            onPressed: () {
              provider.toggleFavourite(weather.cityName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav
                        ? '${weather.cityName} removed from Favourites'
                        : '${weather.cityName} added to Favourites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Temperature Display & Description ─────────────────────────────────────
  Widget _buildMainTempSection(WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final unitSymbol = provider.unit == 'metric' ? 'C' : 'F';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WeatherAnimation(
              condition: weather.condition,
              size: 90,
            ),
            const SizedBox(width: 24),
            Text(
              '${weather.temperature.toStringAsFixed(0)}°$unitSymbol',
              style: GoogleFonts.inter(
                fontSize: 96,
                fontWeight: FontWeight.w300,
                color: const Color(0xFFF8FAFC), // Pure crisp off-white
                letterSpacing: -3.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          weather.description.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: const Color(0xFFF8FAFC).withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'H: ${weather.tempMax.toStringAsFixed(0)}°   L: ${weather.tempMin.toStringAsFixed(0)}°',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF94A3B8), // Muted silver-gray
          ),
        ),
      ],
    );
  }

  // ── Grid of detailed weather metrics ──────────────────────────────────────
  Widget _buildDetailedGrid(WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final speedUnit = provider.unit == 'metric' ? 'm/s' : 'mph';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            WeatherInfoTile(
              icon: Icons.thermostat_rounded,
              label: 'Feels Like',
              value: '${weather.feelsLike.toStringAsFixed(1)}°',
              iconColor: const Color(0xFFFF006E), // Hot pink/coral glow
            ),
            WeatherInfoTile(
              icon: Icons.water_drop_rounded,
              label: 'Humidity',
              value: '${weather.humidity}%',
              iconColor: const Color(0xFF00F5D4), // Neon cyan glow
            ),
            WeatherInfoTile(
              icon: Icons.air_rounded,
              label: 'Wind Speed',
              value: '${weather.windSpeed.toStringAsFixed(1)} $speedUnit',
              iconColor: const Color(0xFFA855F7), // Futuristic purple glow
            ),
            WeatherInfoTile(
              icon: Icons.compress_rounded,
              label: 'Pressure',
              value: '${weather.pressure} hPa',
              iconColor: const Color(0xFF38BDF8), // Luminous sky blue glow
            ),
          ],
        ),
      ),
    );
  }
}

// ── App Navigation Drawer Component ─────────────────────────────────────────
class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: weatherProvider.isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF1F5F9),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Icon(Icons.cloudy_snowing, color: Colors.blue, size: 36),
                  const SizedBox(width: 14),
                  Text(
                    'SkyFlow Weather',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: weatherProvider.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.home_rounded,
                color: weatherProvider.isDarkMode ? Colors.white70 : Colors.black54,
              ),
              title: Text(
                'Weather Dashboard',
                style: GoogleFonts.outfit(
                  color: weatherProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.favorite_rounded,
                color: weatherProvider.isDarkMode ? Colors.white70 : Colors.black54,
              ),
              title: Text(
                'Favorite Cities',
                style: GoogleFonts.outfit(
                  color: weatherProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings_rounded,
                color: weatherProvider.isDarkMode ? Colors.white70 : Colors.black54,
              ),
              title: Text(
                'Settings & Preferences',
                style: GoogleFonts.outfit(
                  color: weatherProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
