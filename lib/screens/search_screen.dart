import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;

  final List<String> _popularCities = [
    'London',
    'Kolkata',
    'Mumbai',
    'New York',
    'Tokyo',
    'Paris',
    'Durgapur',
    'Delhi',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    try {
      final results = await _weatherService.searchCities(value);
      setState(() {
        _suggestions = results;
      });
    } catch (_) {
      // Slient fail
    }
  }

  void _submitSearch(String city) {
    if (city.trim().isEmpty) return;
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    provider.fetchWeatherByCity(city.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isDark = weatherProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Search City',
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search input
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: GoogleFonts.outfit(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter city name...',
                    hintStyle: GoogleFonts.outfit(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: _submitSearch,
                ),
              ),
              const SizedBox(height: 20),

              // Suggestions & Popular section
              Expanded(
                child: _searchController.text.isEmpty
                    ? _buildPopularSection(isDark)
                    : _buildSuggestionsSection(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Cities',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _popularCities.map((city) {
            return InkWell(
              onTap: () => _submitSearch(city),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: Text(
                  city,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark ? Colors.white.withOpacity(0.8) : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestionsSection(bool isDark) {
    if (_suggestions.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final sug = _suggestions[index];
        final name = sug['name'] ?? '';
        final state = sug['state'] != null ? '${sug['state']}, ' : '';
        final country = sug['country'] ?? '';

        return ListTile(
          leading: Icon(
            Icons.location_city_rounded,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          title: Text(
            name,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            '$state$country',
            style: GoogleFonts.outfit(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          onTap: () => _submitSearch(name),
        );
      },
    );
  }
}
