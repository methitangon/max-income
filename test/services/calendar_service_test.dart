import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:max_income/services/calendar_service.dart';
import 'dart:collection';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

@GenerateMocks([DeviceCalendarPlugin])
import 'calendar_service_test.mocks.dart';

void main() {
  late CalendarService calendarService;
  late MockDeviceCalendarPlugin mockDeviceCalendarPlugin;

  setUpAll(() {
    tz.initializeTimeZones();
  });

  setUp(() {
    mockDeviceCalendarPlugin = MockDeviceCalendarPlugin();
    calendarService =
        CalendarService(deviceCalendarPlugin: mockDeviceCalendarPlugin);
  });

  group('requestPermissions', () {
    test('should return true when permissions are granted', () async {
      when(mockDeviceCalendarPlugin.requestPermissions())
          .thenAnswer((_) async => Result<bool>()..data = true);

      final result = await calendarService.requestPermissions();
      expect(result, true);
      verify(mockDeviceCalendarPlugin.requestPermissions()).called(1);
    });

    test('should return false when permissions are denied', () async {
      when(mockDeviceCalendarPlugin.requestPermissions())
          .thenAnswer((_) async => Result<bool>()..data = false);

      final result = await calendarService.requestPermissions();
      expect(result, false);
      verify(mockDeviceCalendarPlugin.requestPermissions()).called(1);
    });
  });

  group('getCalendars', () {
    test('should return list of calendars when successful', () async {
      final mockCalendars = UnmodifiableListView([
        Calendar(id: '1', name: 'Calendar 1'),
        Calendar(id: '2', name: 'Calendar 2'),
      ]);
      when(mockDeviceCalendarPlugin.retrieveCalendars()).thenAnswer((_) async =>
          Result<UnmodifiableListView<Calendar>>()..data = mockCalendars);

      final result = await calendarService.getCalendars();
      expect(result, mockCalendars);
      verify(mockDeviceCalendarPlugin.retrieveCalendars()).called(1);
    });

    test('should throw exception when retrieval fails', () async {
      when(mockDeviceCalendarPlugin.retrieveCalendars()).thenAnswer(
          (_) async => Result<UnmodifiableListView<Calendar>>()..data = null);

      expect(() => calendarService.getCalendars(), throwsException);
      verify(mockDeviceCalendarPlugin.retrieveCalendars()).called(1);
    });
  });

  group('getCurrentYearEvents', () {
    test('should return sorted list of safe calendar events', () async {
      final mockCalendars =
          UnmodifiableListView([Calendar(id: '1', name: 'Calendar 1')]);
      final mockEvents = UnmodifiableListView([
        Event(
          '1',
          eventId: '1',
          title: '🏠 Event 1',
          start: TZDateTime.from(DateTime(2024, 1, 1), local),
          end: TZDateTime.from(DateTime(2024, 1, 2), local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '2',
          title: '🏠 Event 2',
          start: TZDateTime.from(DateTime(2024, 2, 1), local),
          end: TZDateTime.from(DateTime(2024, 2, 2), local),
          allDay: false,
        ),
      ]);

      when(mockDeviceCalendarPlugin.retrieveCalendars()).thenAnswer((_) async =>
          Result<UnmodifiableListView<Calendar>>()..data = mockCalendars);
      when(mockDeviceCalendarPlugin.retrieveEvents(
        any,
        any,
      )).thenAnswer((_) async =>
          Result<UnmodifiableListView<Event>>()..data = mockEvents);

      final result = await calendarService.getCurrentYearEvents();
      expect(result.length, 2);
      expect(result[0].title, '🏠 Event 1');
      expect(result[1].title, '🏠 Event 2');

      verify(mockDeviceCalendarPlugin.retrieveCalendars()).called(1);
      verify(mockDeviceCalendarPlugin.retrieveEvents(
        any,
        any,
      )).called(1);
    });

    test('should filter out non-house emoji events', () async {
      final mockCalendars =
          UnmodifiableListView([Calendar(id: '1', name: 'Calendar 1')]);
      final mockEvents = UnmodifiableListView([
        Event(
          '1',
          eventId: '1',
          title: '🏠 House Event',
          start: TZDateTime.from(DateTime(2024, 1, 1), local),
          end: TZDateTime.from(DateTime(2024, 1, 2), local),
          allDay: false,
        ),
        Event(
          '1',
          eventId: '2',
          title: 'Regular Event',
          start: TZDateTime.from(DateTime(2024, 2, 1), local),
          end: TZDateTime.from(DateTime(2024, 2, 2), local),
          allDay: false,
        ),
      ]);

      when(mockDeviceCalendarPlugin.retrieveCalendars()).thenAnswer((_) async =>
          Result<UnmodifiableListView<Calendar>>()..data = mockCalendars);
      when(mockDeviceCalendarPlugin.retrieveEvents(
        any,
        any,
      )).thenAnswer((_) async =>
          Result<UnmodifiableListView<Event>>()..data = mockEvents);

      final result = await calendarService.getCurrentYearEvents();
      expect(result.length, 1);
      expect(result[0].title, '🏠 House Event');
    });

    test('should handle empty calendar list', () async {
      when(mockDeviceCalendarPlugin.retrieveCalendars()).thenAnswer((_) async =>
          Result<UnmodifiableListView<Calendar>>()
            ..data = UnmodifiableListView([]));

      final result = await calendarService.getCurrentYearEvents();
      expect(result, isEmpty);
    });
  });
}
