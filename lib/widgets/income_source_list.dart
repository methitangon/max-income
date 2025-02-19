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
            leading: Icon(_getIconForType(incomeSource.type)),
            title: Text(incomeSource.name),
            subtitle: Text(incomeSource.type),
            // Add onTap to navigate to details screen
          ),
        );
      },
    );
  }

  // Helper function to get icon based on income source type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'rental':
        return Icons.house;
      case 'vehicle':
        return Icons.local_shipping;
      case 'coffee':
        return Icons.coffee;
      default:
        return Icons.attach_money;
    }
  }
}
