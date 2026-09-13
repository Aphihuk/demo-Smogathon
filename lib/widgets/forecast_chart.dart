import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/pm25_data.dart';
import 'package:intl/intl.dart';
import 'glass_card.dart';

class ForecastChart extends StatelessWidget {
  final List<ForecastHour> forecast;

  const ForecastChart({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox.shrink();

    // Prepare data points
    List<FlSpot> spots = [];
    double maxY = 0;

    for (int i = 0; i < forecast.length; i++) {
      if (forecast[i].pm25 > maxY) maxY = forecast[i].pm25;
      spots.add(FlSpot(i.toDouble(), forecast[i].pm25));
    }
    
    // Add some padding to Y axis
    maxY = (maxY * 1.2).ceilToDouble();
    if (maxY < 50) maxY = 50; // Minimum scale

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                '24-HOUR FORECAST',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: forecast.length <= 12 ? 2 : 4,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= forecast.length) return const SizedBox();
                        
                        String label = forecast[index].hour;
                        
                        // Try parsing as ISO date
                        try {
                          final date = DateTime.parse(label).toLocal();
                          label = DateFormat('HH:mm').format(date);
                        } catch (_) {
                          // Try parsing as integer hour (0-23)
                          final intHour = int.tryParse(label);
                          if (intHour != null) {
                            label = '${intHour.toString().padLeft(2, '0')}:00';
                          }
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800.withOpacity(0.9),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        int index = spot.x.toInt();
                        if (index < 0 || index >= forecast.length) return null;
                        
                        String label = forecast[index].hour;
                        try {
                          final date = DateTime.parse(label).toLocal();
                          label = DateFormat('HH:mm').format(date);
                        } catch (_) {
                          final intHour = int.tryParse(label);
                          if (intHour != null) {
                            label = '${intHour.toString().padLeft(2, '0')}:00';
                          }
                        }

                        return LineTooltipItem(
                          '$label\n',
                          const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: spot.y.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                minX: 0,
                maxX: (forecast.length - 1).toDouble(),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
