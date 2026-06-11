import 'package:flutter/material.dart';

class WeatherAnimation extends StatefulWidget {
  final String condition;
  final double size;

  const WeatherAnimation({super.key, required this.condition, this.size = 80});

  @override
  State<WeatherAnimation> createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends State<WeatherAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIconForCondition() {
    switch (widget.condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'clouds':
        return Icons.wb_cloudy_rounded;
      case 'rain':
        return Icons.water_drop_rounded;
      case 'drizzle':
        return Icons.grain_rounded;
      case 'thunderstorm':
        return Icons.thunderstorm_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  Color _getColorForCondition() {
    switch (widget.condition.toLowerCase()) {
      case 'clear':
        return const Color(0xFFFFB703); // Luminous electric amber
      case 'clouds':
        return const Color(0xFF94A3B8); // Muted silver-grey
      case 'rain':
      case 'drizzle':
        return const Color(0xFF00F5D4); // Neon cyan
      case 'thunderstorm':
        return const Color(0xFFA855F7); // Futuristic purple
      case 'snow':
        return const Color(0xFF38BDF8); // Sky blue
      default:
        return const Color(0xFFFFB703);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getColorForCondition();
    final iconData = _getIconForCondition();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Neon Halo / Glow behind the icon
              Container(
                width: widget.size * 0.8,
                height: widget.size * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(_glowAnimation.value),
                      blurRadius: widget.size * 0.5,
                      spreadRadius: widget.size * 0.05,
                    ),
                  ],
                ),
              ),
              // Main Icon
              Icon(
                iconData,
                size: widget.size,
                color: iconColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
