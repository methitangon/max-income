import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';

class IncomeSourceList extends StatelessWidget {
  final List<IncomeSource> incomeSources;

  const IncomeSourceList({super.key, required this.incomeSources});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: incomeSources.length,
      itemBuilder: (context, index) {
        final incomeSource = incomeSources[index];
        return Card(
          child: ListTile(
            title: Text(incomeSource.name),
            subtitle: Text(incomeSource.type),
            // Add onTap to navigate to details screen
          ),
        );
      },
    );
  }
}
