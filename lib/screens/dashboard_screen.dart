import 'package:flutter/material.dart';
import 'package:max_income/mock_income_source.dart';
import 'package:max_income/widgets/income_chart.dart';
import 'package:max_income/widgets/income_stream.dart';
import 'package:max_income/widgets/monthly_cash_flow.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mockIncomeSources.fold<double>(0, (sum, item) => sum + item.amount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAX income'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MonthlyCashFlow(),
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
                    child: IncomeChart(incomeSources: mockIncomeSources),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              IncomeStreams(incomeSources: mockIncomeSources),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
