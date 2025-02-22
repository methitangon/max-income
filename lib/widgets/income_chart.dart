import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class IncomeChart extends StatelessWidget {
  final List<IncomeSource> incomeSources;

  const IncomeChart({super.key, required this.incomeSources});

  @override
  Widget build(BuildContext context) {
    // Group income sources by type and sum their amounts
    final groupedIncomeSources =
        groupBy<IncomeSource, String>(incomeSources, (source) => source.type);
    final convertedData = groupedIncomeSources.entries.map((entry) {
      final type = entry.key;
      final incomes = entry.value.map((source) => source.amount).toList();
      final costs = entry.value
          .expand((source) => source.costs)
          .map((cost) => cost.amount)
          .toList();
      return MapEntry(
        _getTypeIndex(type),
        _IncomeData(incomes: incomes, costs: costs),
      );
    }).toList();

    // Calculate the maximum values for auto-scaling
    double maxIncome = 0;
    double maxCost = 0;
    for (var entry in convertedData) {
      final data = entry.value;
      final totalIncome = data.incomes.fold(0.0, (sum, amount) => sum + amount);
      final totalCost = data.costs.fold(0.0, (sum, amount) => sum + amount);
      maxIncome = maxIncome < totalIncome ? totalIncome : maxIncome;
      maxCost = maxCost < totalCost ? totalCost : maxCost;
    }

    // Add 20% padding to the max values for better visualization
    final maxY = (maxIncome * 1.2).roundToDouble();
    final minY = -(maxCost * 1.2).roundToDouble();

    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: maxY,
            minY: minY,
            groupsSpace: 48,
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        _getTypeName(value.toInt()),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        _formatCurrency(value),
                        style: TextStyle(
                          color: value < 0 ? Colors.red : Colors.green,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) {
                // Show lines at 0 and at regular intervals
                if (value == 0) return true;
                final interval = (maxY - minY).abs() / 10;
                return (value % interval).abs() < 0.01;
              },
              getDrawingHorizontalLine: (value) {
                if (value == 0) {
                  return FlLine(
                    color: Colors.grey,
                    strokeWidth: 2,
                  );
                }
                return FlLine(
                  color: Colors.grey.withAlpha(30),
                  strokeWidth: 0.8,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: convertedData
                .map((e) => generateGroup(e.key, e.value))
                .toList(),
          ),
        ),
      ),
    );
  }

  BarChartGroupData generateGroup(int x, _IncomeData data) {
    final totalIncome = data.incomes.fold(0.0, (sum, amount) => sum + amount);
    final totalCosts = data.costs.fold(0.0, (sum, amount) => sum + amount);

    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        // Income bar
        BarChartRodData(
          toY: totalIncome,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(0, totalIncome, Colors.green),
          ],
        ),
        // Costs bar
        BarChartRodData(
          toY: -totalCosts,
          width: 22,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(0, -totalCosts, Colors.red),
          ],
        ),
      ],
    );
  }

  // Helper function to get type name from index
  String _getTypeName(int index) {
    switch (index) {
      case 0:
        return 'rental';
      case 1:
        return 'vehicle';
      case 2:
        return 'coffee';
      default:
        return '';
    }
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

  // Helper function to format currency values
  String _formatCurrency(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _IncomeData {
  final List<double> incomes;
  final List<double> costs;

  _IncomeData({required this.incomes, required this.costs});
}
