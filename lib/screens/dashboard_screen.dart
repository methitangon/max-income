import 'package:flutter/material.dart';

import 'package:max_income/mock_income_source.dart';
import 'package:max_income/widgets/income_source_list.dart';
import 'package:max_income/widgets/income_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate total income from mock data
    double totalIncome = mockIncomeSources.fold<double>(
        0,
        (sum, item) =>
            sum + item.amount); // Assuming IncomeSource has an amount property

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
            IncomeSummaryCard(totalIncome: totalIncome), // Use the new widget
            const SizedBox(height: 32),
            const Text(
              'Income Streams',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: IncomeSourceList(
                  incomeSources: mockIncomeSources), // Use the new widget
            ),
          ],
        ),
      ),
    );
  }
}
