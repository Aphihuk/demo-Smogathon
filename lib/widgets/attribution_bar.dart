import 'package:flutter/material.dart';
import '../models/pm25_data.dart';
import 'glass_card.dart';

class AttributionBar extends StatelessWidget {
  final Attribution attribution;

  const AttributionBar({Key? key, required this.attribution}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.pie_chart_outline, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                'POLLUTION SOURCES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // The stacked bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  if (attribution.fire > 0)
                    _buildBarSegment(attribution.fire, Colors.red),
                  if (attribution.traffic > 0)
                    _buildBarSegment(attribution.traffic, Colors.grey.shade400),
                  if (attribution.crossBorder > 0)
                    _buildBarSegment(attribution.crossBorder, Colors.blue),
                  if (attribution.background > 0)
                    _buildBarSegment(attribution.background, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildLegendItem('🔥 Fire', attribution.fire, Colors.red),
              _buildLegendItem('🚗 Traffic', attribution.traffic, Colors.grey.shade400),
              _buildLegendItem('🌏 Cross-border', attribution.crossBorder, Colors.blue),
              _buildLegendItem('🏔️ Background', attribution.background, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarSegment(double percentage, Color color) {
    return Expanded(
      flex: (percentage * 100).round(),
      child: Container(color: color),
    );
  }

  Widget _buildLegendItem(String label, double percentage, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ${(percentage * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
