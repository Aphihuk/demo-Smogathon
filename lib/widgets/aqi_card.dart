import 'package:flutter/material.dart';
import '../utils/aqi_helpers.dart';
import 'glass_card.dart';

class AqiCard extends StatelessWidget {
  final int aqi;
  final double pm25;
  final String category;
  final double confidence;

  const AqiCard({
    Key? key,
    required this.aqi,
    required this.pm25,
    required this.category,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            child: _buildStatItem('PM2.5', '${pm25.toStringAsFixed(1)} µg/m³', Icons.blur_on),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            child: _buildStatItem('Confidence', '${(confidence * 100).toStringAsFixed(0)}%', Icons.check_circle_outline),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
