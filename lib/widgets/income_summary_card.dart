import 'package:flutter/material.dart';

class IncomeSummaryCard extends StatelessWidget {
  final double totalIncome;

  const IncomeSummaryCard({super.key, required this.totalIncome});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Monthly Income',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              // Display 0 if totalIncome is 0
              totalIncome == 0
                  ? '\$0.00'
                  : '\$${totalIncome.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
