import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:max_income/mock_income_source.dart';
import 'package:max_income/widgets/income_source_list.dart';
import 'package:max_income/widgets/income_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate total income from mock data
    double totalIncome =
        mockIncomeSources.fold<double>(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MAX income'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Cash Flow',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            IncomeSummaryCard(totalIncome: totalIncome),
            const SizedBox(height: 32),
            const Text(
              'Income Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16 / 9, // Adjust as needed
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      barGroups: mockIncomeSources
                          .map((incomeSource) => BarChartGroupData(
                                x: incomeSource.id.toInt(),
                                barRods: [
                                  BarChartRodData(
                                    toY: incomeSource.amount,
                                    color: _getColorForType(incomeSource.type),
                                    width: 20,
                                  ),
                                ],
                              ))
                          .toList(),
                      titlesData: FlTitlesData(
                        // Customize titles and labels as needed
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final index = value.toInt();
                              if (index >= 0 &&
                                  index < mockIncomeSources.length) {
                                return Text(mockIncomeSources[index].name);
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
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Income Streams',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: IncomeSourceList(incomeSources: mockIncomeSources),
            ),
          ],
        ),
      ),
    );
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
