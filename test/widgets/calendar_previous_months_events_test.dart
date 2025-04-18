import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:max_income/widgets/calendar_previous_months_events.dart';
import 'package:max_income/services/calendar_service.dart';
import 'package:max_income/models/safe_calendar_event.dart';
import 'package:max_income/widgets/event_card.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'calendar_previous_months_events_test.mocks.dart';

@GenerateMocks([CalendarService])
void main() {
  late MockCalendarService mockCalendarService;
  late List<SafeCalendarEvent> mockEvents;

  setUpAll(() {
    tz.initializeTimeZones();
  });

  setUp(() {
    mockCalendarService = MockCalendarService();
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

  testWidgets('should not render anything when current month is January',
      (WidgetTester tester) async {
    // Set current date to January
    when(mockCalendarService.requestPermissions())
        .thenAnswer((_) async => true);
    when(mockCalendarService.getPreviousMonthsEvents())
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      MaterialApp(
        home:
            CalendarPreviousMonthsEvents(calendarService: mockCalendarService),
      ),
    );

    // Verify that nothing is rendered
    expect(find.byType(CalendarPreviousMonthsEvents), findsOneWidget);
    expect(find.byType(EventCard), findsNothing);
  });

  testWidgets('should show loading indicator while fetching events',
      (WidgetTester tester) async {
    // Set current date to April
    when(mockCalendarService.requestPermissions())
        .thenAnswer((_) async => true);
    when(mockCalendarService.getPreviousMonthsEvents())
        .thenAnswer((_) async => mockEvents);

    await tester.pumpWidget(
      MaterialApp(
        home:
            CalendarPreviousMonthsEvents(calendarService: mockCalendarService),
      ),
    );

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading events...'), findsOneWidget);
  });

  testWidgets('should show error message when permissions are denied',
      (WidgetTester tester) async {
    // Set current date to April
    when(mockCalendarService.requestPermissions())
        .thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        home:
            CalendarPreviousMonthsEvents(calendarService: mockCalendarService),
      ),
    );

    await tester.pumpAndSettle();

    // Verify error message is shown
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Calendar permissions not granted'), findsOneWidget);
  });

  testWidgets('should show "No events found" when there are no events',
      (WidgetTester tester) async {
    // Set current date to April
    when(mockCalendarService.requestPermissions())
        .thenAnswer((_) async => true);
    when(mockCalendarService.getPreviousMonthsEvents())
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      MaterialApp(
        home:
            CalendarPreviousMonthsEvents(calendarService: mockCalendarService),
      ),
    );

    await tester.pumpAndSettle();

    // Verify "No events found" message is shown
    expect(find.byIcon(Icons.event_busy), findsOneWidget);
    expect(find.text('No events found'), findsOneWidget);
  });

  testWidgets('should show events from January to previous month',
      (WidgetTester tester) async {
    // Set current date to April
    when(mockCalendarService.requestPermissions())
        .thenAnswer((_) async => true);
    when(mockCalendarService.getPreviousMonthsEvents())
        .thenAnswer((_) async => mockEvents);

    await tester.pumpWidget(
      MaterialApp(
        home:
            CalendarPreviousMonthsEvents(calendarService: mockCalendarService),
      ),
    );

    await tester.pumpAndSettle();

    // Verify events are shown
    expect(find.byType(EventCard), findsNWidgets(2));
    expect(find.text('🏠 Event 1'), findsOneWidget);
    expect(find.text('🏠 Event 2'), findsOneWidget);
  });

  testWidgets('should refresh events when refresh button is pressed',
      (WidgetTester tester) async {
    // Set current date to April
    when(mockCalendarService.requestPermissions())
        .thenAnswer((_) async => true);
    when(mockCalendarService.getPreviousMonthsEvents())
        .thenAnswer((_) async => mockEvents);

    await tester.pumpWidget(
      MaterialApp(
        home:
            CalendarPreviousMonthsEvents(calendarService: mockCalendarService),
      ),
    );

    await tester.pumpAndSettle();

    // Press refresh button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    // Verify that getPreviousMonthsEvents was called again
    verify(mockCalendarService.getPreviousMonthsEvents()).called(2);
  });
}
