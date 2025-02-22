import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max_income/mock_income_source.dart';

import 'package:max_income/screens/dashboard_screen.dart';
import 'package:max_income/widgets/income_chart.dart';
import 'package:max_income/widgets/income_stream.dart';
import 'package:max_income/widgets/monthly_cash_flow.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('renders all main components', (WidgetTester tester) async {
      // Build the DashboardScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: DashboardScreen(),
      ));

      // Verify the AppBar
      expect(find.text('MAX income'), findsOneWidget);

      // Verify main components are present
      expect(find.byType(MonthlyCashFlow), findsOneWidget);
      expect(find.text('Income Chart'), findsOneWidget);
      expect(find.byType(IncomeChart), findsOneWidget);
      expect(find.byType(IncomeStreams), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('adds new income source when FAB is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DashboardScreen(),
      ));

      // Get initial number of income sources from mock data
      final initialIncomeSourcesCount = mockIncomeSources.length;

      // Tap the FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Find the IncomeChart widget and verify its data
      final chart = tester.widget<IncomeChart>(find.byType(IncomeChart));
      expect(chart.incomeSources.length, initialIncomeSourcesCount + 1);
    });

    testWidgets('new income source has correct default values',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DashboardScreen(),
      ));

      // Get initial number of income sources from mock data
      final initialIncomeSourcesCount = mockIncomeSources.length;

      // Tap the FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Find the IncomeChart widget and get the new income source
      final chart = tester.widget<IncomeChart>(find.byType(IncomeChart));
      final newSource = chart.incomeSources.last;

      // Verify the new income source properties
      expect(newSource.name, 'New Income ${initialIncomeSourcesCount + 1}');
      expect(newSource.amount, 1000);
      expect(newSource.type, 'other');
      expect(newSource.costs, isEmpty);
    });

    testWidgets('scrolls to show all content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DashboardScreen(),
      ));

      // Verify initial scroll position
      expect(find.text('Income Chart'), findsOneWidget);

      // Scroll down
      await tester.dragFrom(
        tester.getCenter(find.byType(SingleChildScrollView)),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Verify we can scroll to see more content
      expect(find.byType(IncomeStreams), findsOneWidget);
    });

    testWidgets('chart updates when new income source is added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DashboardScreen(),
      ));

      // Get initial chart state
      final initialChart = tester.widget<IncomeChart>(find.byType(IncomeChart));
      final initialSourcesCount = initialChart.incomeSources.length;

      // Add new income source
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify chart was updated
      final updatedChart = tester.widget<IncomeChart>(find.byType(IncomeChart));
      expect(updatedChart.incomeSources.length, initialSourcesCount + 1);
    });

    testWidgets('monthly cash flow updates when new income source is added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DashboardScreen(),
      ));

      // Get initial monthly cash flow data
      final initialCashFlow =
          tester.widget<MonthlyCashFlow>(find.byType(MonthlyCashFlow));
      final initialSourcesCount = initialCashFlow.incomeSources.length;

      // Add new income source
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify monthly cash flow was updated with new data
      final updatedCashFlow =
          tester.widget<MonthlyCashFlow>(find.byType(MonthlyCashFlow));
      expect(updatedCashFlow.incomeSources.length, initialSourcesCount + 1);
    });
  });
}
