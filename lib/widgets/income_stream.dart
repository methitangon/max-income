import 'package:flutter/material.dart';
import 'package:max_income/models/income_source.dart';
import 'package:max_income/widgets/income_source_list.dart';

class IncomeStreams extends StatelessWidget {
  final List<IncomeSource> incomeSources;

  const IncomeStreams({super.key, required this.incomeSources});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Income Streams',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        IncomeSourceList(
          incomeSources: incomeSources,
          // ignore: avoid_types_as_parameter_names
          onNewIncomeSource: (IncomeSource) {},
        ),
      ],
    );
  }
}
