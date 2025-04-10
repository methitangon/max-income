import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:max_income/screens/calendar_screen.dart';
import 'package:max_income/services/calendar_service.dart';
import 'package:max_income/models/safe_calendar_event.dart';
import 'package:max_income/widgets/calendar_current_month_events.dart';
import 'package:max_income/widgets/calendar_previous_months_events.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

@GenerateMocks([CalendarService])
void main() {
  late List<SafeCalendarEvent> mockEvents;

  setUpAll(() {
    tz.initializeTimeZones();
  });

  setUp(() {
    mockEvents = [
      SafeCalendarEvent(
        id: '1',
        title: '🏠 Event 1',
        startTime: tz.TZDateTime.from(DateTime(2024, 1, 15), tz.local),
        endTime: tz.TZDateTime.from(DateTime(2024, 1, 16), tz.local),
      ),
      SafeCalendarEvent(
        id: '2',
        title: '🏠 Event 2',
        startTime: tz.TZDateTime.from(DateTime(2024, 2, 1), tz.local),
        endTime: tz.TZDateTime.from(DateTime(2024, 2, 2), tz.local),
      ),
    ];
  });

  testWidgets('should display app bar with correct title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CalendarScreen(),
      ),
    );

    expect(find.text('Calendar Events'), findsOneWidget);
  });

  testWidgets('should display both calendar widgets',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CalendarScreen(),
      ),
    );

    expect(find.byType(CalendarCurrentMonthEvents), findsOneWidget);
    expect(find.byType(CalendarPreviousMonthsEvents), findsOneWidget);
  });

  testWidgets('should handle loading state correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CalendarScreen(),
      ),
    );

    // Verify loading indicators are shown
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    expect(find.text('Loading events...'), findsNWidgets(2));
  });
}
