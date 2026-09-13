import 'package:flutter/material.dart';
import '../utils/aqi_helpers.dart';
import 'glass_card.dart';

class HealthTip extends StatelessWidget {
  final int aqi;
  final String category;

  const HealthTip({
    Key? key,
    required this.aqi,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final advice = getHealthAdvice(category);

    return GlassCard(
      child: Row(
        children: [
          const Icon(
            Icons.health_and_safety,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HEALTH ADVICE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advice,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
