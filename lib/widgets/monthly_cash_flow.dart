import 'package:flutter/material.dart';
import 'package:max_income/mock_income_source.dart';
import 'package:max_income/widgets/income_summary_card.dart';

class MonthlyCashFlow extends StatelessWidget {
  const MonthlyCashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate net income
    double netIncome = mockIncomeSources.fold<double>(0, (sum, incomeSource) {
      final totalCosts = incomeSource.costs
          .fold<double>(0, (costSum, cost) => costSum + cost.amount);
      return sum + incomeSource.amount - totalCosts;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Cash Flow',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        IncomeSummaryCard(totalIncome: netIncome), // Display net income
      ],
    );
  }
}
