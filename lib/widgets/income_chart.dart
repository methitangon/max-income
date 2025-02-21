import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';
import 'package:collection/collection.dart';

class IncomeChart extends StatelessWidget {
  final List<IncomeSource> incomeSources;

  const IncomeChart({super.key, required this.incomeSources});

  @override
  Widget build(BuildContext context) {
    // Group income sources by type and sum their amounts
    final groupedIncomeSources =
        groupBy<IncomeSource, String>(incomeSources, (source) => source.type);
    final summedIncomeSources = groupedIncomeSources.entries.map((entry) {
      final type = entry.key;
      final totalAmount =
          entry.value.fold<double>(0, (sum, source) => sum + source.amount);
      return MapEntry(type, totalAmount);
    });

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 200,
        child: BarChart(
          BarChartData(
            barGroups: summedIncomeSources
                .map((entry) => BarChartGroupData(
                      x: _getTypeIndex(entry.key),
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: _getColorForType(entry.key),
                          width: 20,
                          rodStackItems: [
                            BarChartRodStackItem(
                              entry.value,
                              entry.value,
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ))
                .toList(),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < summedIncomeSources.length) {
                      final type = summedIncomeSources.elementAt(index).key;
                      return Text(type);
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
            ),
            gridData: FlGridData(
              show: true,
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to get index for type
  int _getTypeIndex(String type) {
    switch (type) {
      case 'rental':
        return 0;
      case 'vehicle':
        return 1;
      case 'coffee':
        return 2;
      default:
        return 0;
    }
  }

  // Helper function to get color based on income source type
  Color _getColorForType(String type) {
    switch (type) {
      case 'rental':
        return Colors.blue;
      case 'vehicle':
        return Colors.green;
      case 'coffee':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
