import 'package:flutter_test/flutter_test.dart';
import 'package:max_income/services/calendar_service.dart';
import 'package:max_income/models/safe_calendar_event.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  late CalendarService calendarService;
  final currentYear = 2024;
  final currentDate = DateTime(currentYear, 3, 2);

  setUp(() {
    calendarService = CalendarService();
  });

  group('CalendarService Tests', () {
    test('requestPermissions returns boolean', () async {
      final result = await calendarService.requestPermissions();
      expect(result, isA<bool>());
    });

    test('getCalendars returns list of calendars', () async {
      final calendars = await calendarService.getCalendars();
      expect(calendars, isA<List>());
    });

    test('getCurrentYearEvents returns list of SafeCalendarEvent', () async {
      final events = await calendarService.getCurrentYearEvents();
      expect(events, isA<List<SafeCalendarEvent>>());
    });

    test('getCurrentYearEvents only returns events with house emoji', () async {
      final events = await calendarService.getCurrentYearEvents();
      for (final event in events) {
        expect(event.title?.startsWith('🏠'), isTrue);
      }
    });

    test('getCurrentYearEvents returns events sorted by start time', () async {
      final events = await calendarService.getCurrentYearEvents();
      for (var i = 0; i < events.length - 1; i++) {
        final currentEvent = events[i];
        final nextEvent = events[i + 1];
        if (currentEvent.startTime != null && nextEvent.startTime != null) {
          expect(
            currentEvent.startTime!.isBefore(nextEvent.startTime!) ||
                currentEvent.startTime!.isAtSameMomentAs(nextEvent.startTime!),
            isTrue,
          );
        }
      }
    });

    test('getCurrentYearEvents handles empty calendar gracefully', () async {
      final events = await calendarService.getCurrentYearEvents();
      expect(events, isA<List<SafeCalendarEvent>>());
    });

    test('getCurrentYearEvents returns events within current year', () async {
      final events = await calendarService.getCurrentYearEvents();
      for (final event in events) {
        if (event.startTime != null) {
          expect(event.startTime!.year, equals(currentYear));
        }
      }
    });
  });

  group('CalendarService - House Event Filtering', () {
    test('filters events to only include those with house emoji', () async {
      final service = CalendarService();
      final events = await service.getCurrentYearEvents();
      for (final event in events) {
        expect(event.title?.startsWith('🏠'), isTrue);
      }
    });

    test('sorts events by start time', () async {
      final service = CalendarService();
      final events = await service.getCurrentYearEvents();
      for (var i = 0; i < events.length - 1; i++) {
        final current = events[i];
        final next = events[i + 1];
        if (current.startTime != null && next.startTime != null) {
          expect(
            current.startTime!.isBefore(next.startTime!) ||
                current.startTime!.isAtSameMomentAs(next.startTime!),
            isTrue,
          );
        }
      }
    });

    test('handles empty calendar gracefully', () async {
      final service = CalendarService();
      final events = await service.getCurrentYearEvents();
      expect(events, isA<List<SafeCalendarEvent>>());
    });
  });

  group('CalendarService - Event Filtering Tests', () {
    test('shows house events within current year', () async {
      final events = [
        Event(
          '1',
          eventId: '1',
          title: '🏠 House 1',
          start: tz.TZDateTime.from(currentDate, tz.local),
          end: tz.TZDateTime.from(
              currentDate.add(const Duration(hours: 1)), tz.local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '2',
          title: '🏠 House 2',
          start: tz.TZDateTime.from(currentDate, tz.local),
          end: tz.TZDateTime.from(
              currentDate.add(const Duration(hours: 1)), tz.local),
          allDay: false,
        ),
      ];

      final result = await calendarService.getCurrentYearEvents();
      expect(result.length, 2);
      expect(result[0].title, '🏠 House 1');
      expect(result[1].title, '🏠 House 2');
    });

    test('shows no events when calendar is empty', () async {
      final result = await calendarService.getCurrentYearEvents();
      expect(result, isEmpty);
    });

    test('shows only events within current year', () async {
      final events = [
        Event(
          '1',
          eventId: '1',
          title: '🏠 House 1',
          start: tz.TZDateTime.from(DateTime(currentYear, 3, 1), tz.local),
          end: tz.TZDateTime.from(DateTime(currentYear, 3, 1, 1), tz.local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '2',
          title: '🏠 House 2',
          start: tz.TZDateTime.from(DateTime(currentYear, 12, 31), tz.local),
          end: tz.TZDateTime.from(DateTime(currentYear, 12, 31, 1), tz.local),
          allDay: false,
        ),
      ];

      final result = await calendarService.getCurrentYearEvents();
      expect(result.length, 2);
      expect(result[0].title, '🏠 House 1');
      expect(result[1].title, '🏠 House 2');
    });

    test('filters out events with non-house emoji', () async {
      final events = [
        Event(
          '1',
          eventId: '1',
          title: '🏠 House 1',
          start: tz.TZDateTime.from(currentDate, tz.local),
          end: tz.TZDateTime.from(
              currentDate.add(const Duration(hours: 1)), tz.local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '2',
          title: '🇰🇷 House 2',
          start: tz.TZDateTime.from(currentDate, tz.local),
          end: tz.TZDateTime.from(
              currentDate.add(const Duration(hours: 1)), tz.local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '3',
          title: 'สงกรานต์',
          start: tz.TZDateTime.from(DateTime(currentYear, 4, 13), tz.local),
          end: tz.TZDateTime.from(DateTime(currentYear, 4, 13, 1), tz.local),
          allDay: false,
        ),
      ];

      final result = await calendarService.getCurrentYearEvents();
      expect(result.length, 1);
      expect(result[0].title, '🏠 House 1');
    });

    test('sorts events by start time', () async {
      final events = [
        Event(
          '1',
          eventId: '1',
          title: '🏠 House 2',
          start: tz.TZDateTime.from(DateTime(currentYear, 3, 2), tz.local),
          end: tz.TZDateTime.from(DateTime(currentYear, 3, 2, 1), tz.local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '2',
          title: '🏠 House 1',
          start: tz.TZDateTime.from(DateTime(currentYear, 3, 1), tz.local),
          end: tz.TZDateTime.from(DateTime(currentYear, 3, 1, 1), tz.local),
          allDay: false,
        ),
      ];

      final result = await calendarService.getCurrentYearEvents();
      expect(result.length, 2);
      expect(result[0].title, '🏠 House 1');
      expect(result[1].title, '🏠 House 2');
    });
  });
}
