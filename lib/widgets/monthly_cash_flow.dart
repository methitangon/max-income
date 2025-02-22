import 'package:flutter/material.dart';
import 'package:max_income/mock_income_source.dart';
import 'package:max_income/widgets/cost_summary_card.dart';
import 'package:max_income/widgets/income_summary_card.dart';

class MonthlyCashFlow extends StatelessWidget {
  const MonthlyCashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate net income
    double netIncome = mockIncomeSources.fold<double>(0, (sum, incomeSource) {
      return sum + incomeSource.amount;
    });

    // Calculate total costs (moved this line up)
    double totalCosts = mockIncomeSources.fold<double>(0, (sum, incomeSource) {
      return sum +
          incomeSource.costs
              .fold<double>(0, (costSum, cost) => costSum + cost.amount);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Cash Flow',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              // Add Expanded with flex: 1
              flex: 1,
              child: IncomeSummaryCard(totalIncome: netIncome),
            ),
            const SizedBox(width: 16), // Add spacing between cards
            Expanded(
              // Add Expanded with flex: 1
              flex: 1,
              child: CostSummaryCard(totalCost: totalCosts),
            ),
          ],
        )
        // Display net income
      ],
    );
  }
}
