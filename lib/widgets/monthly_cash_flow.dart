import 'package:flutter/material.dart';
import 'package:max_income/widgets/income_summary_card.dart';

class MonthlyCashFlow extends StatelessWidget {
  final double totalIncome;

  const MonthlyCashFlow({super.key, required this.totalIncome});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Cash Flow',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        IncomeSummaryCard(totalIncome: totalIncome),
      ],
    );
  }
}
