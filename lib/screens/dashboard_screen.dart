// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:max_income/mock_income_source.dart';
import 'package:max_income/models/income_source.dart';
import 'package:max_income/widgets/income_chart.dart';
import 'package:max_income/widgets/monthly_cash_flow.dart';
import 'package:max_income/widgets/income_source_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<IncomeSource> _incomeSources = mockIncomeSources;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAX income'),
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
                aspectRatio: 16 / 9, // Adjust as needed
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hardcoded new income source for now
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
