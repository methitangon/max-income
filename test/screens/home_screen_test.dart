import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max_income/screens/home_screen.dart';
import 'package:max_income/screens/calendar_screen.dart';
import 'package:max_income/screens/income_screen.dart';
import 'package:max_income/screens/profile_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should show CalendarScreen by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.byType(IncomeScreen), findsNothing);
      expect(find.byType(ProfileScreen), findsNothing);
    });

    testWidgets('should show correct bottom navigation items',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should switch to IncomeScreen when Income tab is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      await tester.tap(find.byIcon(Icons.attach_money));
      await tester.pumpAndSettle();

      expect(find.byType(IncomeScreen), findsOneWidget);
      expect(find.byType(CalendarScreen), findsNothing);
      expect(find.byType(ProfileScreen), findsNothing);
    });

    testWidgets('should switch to ProfileScreen when Profile tab is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(CalendarScreen), findsNothing);
      expect(find.byType(IncomeScreen), findsNothing);
    });

    testWidgets('should maintain bottom navigation bar after tab switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Tap Income tab
      await tester.tap(find.byIcon(Icons.attach_money));
      await tester.pumpAndSettle();

      // Verify bottom navigation bar is still present
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Tap Profile tab
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify bottom navigation bar is still present
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
