import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';
import 'package:collection/collection.dart';
import 'package:max_income/screens/income_source_list_detail_screen.dart';

class IncomeSourceList extends StatelessWidget {
  final List<IncomeSource> incomeSources;
  final Function(IncomeSource) onNewIncomeSource;

  const IncomeSourceList({
    super.key,
    required this.incomeSources,
    required this.onNewIncomeSource,
  });

  @override
  Widget build(BuildContext context) {
    final groupedSources =
        groupBy<IncomeSource, String>(incomeSources, (source) => source.type);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedSources.length,
      itemBuilder: (context, index) {
        final type = groupedSources.keys.elementAt(index);
        final sourcesForType = groupedSources[type]!;
        final totalIncome = sourcesForType.fold<double>(
            0, (sum, source) => sum + source.amount);
        final totalCosts = sourcesForType.fold<double>(
            0,
            (sum, source) =>
                sum +
                source.costs
                    .fold<double>(0, (costSum, cost) => costSum + cost.amount));

        return Card(
          child: ListTile(
            leading: Icon(_getIconForType(type)),
            title: Text(type),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Income: \$${totalIncome.toStringAsFixed(2)}'),
                Text('Total Costs: \$${totalCosts.toStringAsFixed(2)}'),
              ],
            ),
            onTap: () {
              // Navigate to details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IncomeSourceDetailsScreen(
                    incomeSources: sourcesForType,
                  ),
                ),
              );
            },
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
