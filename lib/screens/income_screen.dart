import 'package:flutter/material.dart';
import 'package:max_income/mock_income_source.dart';
import 'package:max_income/models/income_source.dart';
import 'package:max_income/widgets/income_chart.dart';
import 'package:max_income/widgets/monthly_cash_flow.dart';
import 'package:max_income/widgets/income_source_list.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final List<IncomeSource> _incomeSources = mockIncomeSources;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonthlyCashFlow(incomeSources: _incomeSources),
              const SizedBox(height: 32),
              const Text(
                'Income Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IncomeChart(incomeSources: _incomeSources),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              IncomeSourceList(
                incomeSources: _incomeSources,
                onNewIncomeSource: _addNewIncomeSource,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newIncome = IncomeSource(
            id: _incomeSources.length + 1,
            name: 'New Income ${_incomeSources.length + 1}',
            type: 'other',
            amount: 1000,
            costs: [],
            status: IncomeSourceStatus.InActive,
          );
          _addNewIncomeSource(newIncome);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewIncomeSource(IncomeSource newIncome) {
    setState(() {
      _incomeSources.add(newIncome);
    });
  }
}
