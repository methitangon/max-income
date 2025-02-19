import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';

class IncomeChart extends StatelessWidget {
  final List<IncomeSource> incomeSources;

  const IncomeChart({super.key, required this.incomeSources});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 200, // Adjust the height as needed
        child: BarChart(
          BarChartData(
              // Customize the chart data and appearance here
              //...
              ),
        ),
      ),
    );
  }
}
