import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isDark = weatherProvider.isDarkMode;
    final favourites = weatherProvider.favourites;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Favorite Cities',
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: favourites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 70,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite cities bookmarked yet!',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any city to bookmark it.',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final city = favourites[index];
                return Dismissible(
                  key: Key(city),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    weatherProvider.toggleFavourite(city);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$city removed from favorites')),
                    );
                  },
                  child: Card(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.redAccent,
                        ),
                      ),
                      title: Text(
                        city,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                      onTap: () {
                        weatherProvider.fetchWeatherByCity(city);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
