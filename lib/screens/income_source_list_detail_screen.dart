// income_source_details_screen.dart
import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';

class IncomeSourceDetailsScreen extends StatelessWidget {
  final List<IncomeSource> incomeSources;

  const IncomeSourceDetailsScreen({super.key, required this.incomeSources});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${incomeSources.first.type} Details'), // Use the type from the first income source as the title
      ),
      body: ListView.builder(
        itemCount: incomeSources.length,
        itemBuilder: (context, index) {
          final incomeSource = incomeSources[index];
          return Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(incomeSource.name),
                  subtitle: Text(
                      'Income: \$${incomeSource.amount.toStringAsFixed(2)}'),
                ),
                if (incomeSource.costs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: incomeSource.costs
                          .map((cost) =>
                              Text('- ${cost.name}: \$${cost.amount}'))
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
