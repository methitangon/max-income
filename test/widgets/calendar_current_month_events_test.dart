import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max_income/widgets/calendar_current_month_events.dart';
import 'package:max_income/models/safe_calendar_event.dart';
import 'package:max_income/services/calendar_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'calendar_previous_months_events_test.mocks.dart';

@GenerateMocks([CalendarService])
void main() {
  late MockCalendarService mockCalendarService;

  setUp(() {
    mockCalendarService = MockCalendarService();
  });

  group('CalendarCurrentMonthEvents', () {
    testWidgets('should show loading indicator initially',
        (WidgetTester tester) async {
      when(mockCalendarService.requestPermissions())
          .thenAnswer((_) async => true);
      when(mockCalendarService.getCurrentMonthEvents())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home:
              CalendarCurrentMonthEvents(calendarService: mockCalendarService),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading events...'), findsOneWidget);
    });

    testWidgets('should show error message when permissions are not granted',
        (WidgetTester tester) async {
      when(mockCalendarService.requestPermissions())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(
        MaterialApp(
          home:
              CalendarCurrentMonthEvents(calendarService: mockCalendarService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Calendar permissions not granted'), findsOneWidget);
    });

    testWidgets('should show error message when fetching events fails',
        (WidgetTester tester) async {
      when(mockCalendarService.requestPermissions())
          .thenAnswer((_) async => true);
      when(mockCalendarService.getCurrentMonthEvents())
          .thenThrow('Failed to fetch events');

      await tester.pumpWidget(
        MaterialApp(
          home:
              CalendarCurrentMonthEvents(calendarService: mockCalendarService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Failed to fetch events'), findsOneWidget);
    });

    testWidgets('should show no events message when no events are found',
        (WidgetTester tester) async {
      when(mockCalendarService.requestPermissions())
          .thenAnswer((_) async => true);
      when(mockCalendarService.getCurrentMonthEvents())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home:
              CalendarCurrentMonthEvents(calendarService: mockCalendarService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.event_busy), findsOneWidget);
      expect(find.text('No events found'), findsOneWidget);
    });

    testWidgets('should show events when they are fetched successfully',
        (WidgetTester tester) async {
      final events = [
        SafeCalendarEvent(
          id: '1',
          title: 'Test Event 1',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
        ),
        SafeCalendarEvent(
          id: '2',
          title: 'Test Event 2',
          startTime: DateTime.now().add(const Duration(days: 1)),
          endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
        ),
      ];

      when(mockCalendarService.requestPermissions())
          .thenAnswer((_) async => true);
      when(mockCalendarService.getCurrentMonthEvents())
          .thenAnswer((_) async => events);

      await tester.pumpWidget(
        MaterialApp(
          home:
              CalendarCurrentMonthEvents(calendarService: mockCalendarService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Test Event 1'), findsOneWidget);
      expect(find.text('Test Event 2'), findsOneWidget);
    });

    testWidgets('should refresh events when refresh button is tapped',
        (WidgetTester tester) async {
      final events = [
        SafeCalendarEvent(
          id: '1',
          title: 'Test Event',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
        ),
      ];

      when(mockCalendarService.requestPermissions())
          .thenAnswer((_) async => true);
      when(mockCalendarService.getCurrentMonthEvents())
          .thenAnswer((_) async => events);

      await tester.pumpWidget(
        MaterialApp(
          home:
              CalendarCurrentMonthEvents(calendarService: mockCalendarService),
        ),
      );

      await tester.pumpAndSettle();

      verify(mockCalendarService.getCurrentMonthEvents()).called(1);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(mockCalendarService.getCurrentMonthEvents()).called(1);
    });
  });
}
