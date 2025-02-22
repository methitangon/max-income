import 'package:flutter/material.dart';

class CostSummaryCard extends StatelessWidget {
  final double totalCost;

  const CostSummaryCard({super.key, required this.totalCost});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepOrange.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Cost',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              // Display 0 if totalIncome is 0
              totalCost == 0 ? '\$0.00' : '\$${totalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
