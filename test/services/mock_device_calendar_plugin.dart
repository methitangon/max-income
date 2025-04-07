import 'dart:collection';
import 'package:device_calendar/device_calendar.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/timezone.dart' as tz;

class MockDeviceCalendarPlugin extends Mock implements DeviceCalendarPlugin {
  final List<Event> _testEvents = [
    Event(
      '1',
      eventId: '1',
      title: '🏠 House 1',
      start: tz.TZDateTime.from(DateTime(2024, 3, 1), tz.local),
      end: tz.TZDateTime.from(DateTime(2024, 3, 1, 1), tz.local),
      allDay: false,
    ),
    Event(
      '1',
      eventId: '2',
      title: '🏠 House 2',
      start: tz.TZDateTime.from(DateTime(2024, 3, 2), tz.local),
      end: tz.TZDateTime.from(DateTime(2024, 3, 2, 1), tz.local),
      allDay: false,
    ),
    Event(
      '1',
      eventId: '3',
      title: '🇰🇷 House 3',
      start: tz.TZDateTime.from(DateTime(2024, 3, 3), tz.local),
      end: tz.TZDateTime.from(DateTime(2024, 3, 3, 1), tz.local),
      allDay: false,
    ),
    Event(
      '1',
      eventId: '4',
      title: 'สงกรานต์',
      start: tz.TZDateTime.from(DateTime(2024, 4, 13), tz.local),
      end: tz.TZDateTime.from(DateTime(2024, 4, 13, 1), tz.local),
      allDay: false,
    ),
  ];

  @override
  Future<Result<bool>> requestPermissions() async {
    final result = Result<bool>();
    result.data = true;
    return result;
  }

  @override
  Future<Result<UnmodifiableListView<Calendar>>> retrieveCalendars() async {
    final result = Result<UnmodifiableListView<Calendar>>();
    final calendar = Calendar(
      id: '1',
      name: 'Test Calendar',
      accountName: 'Test Account',
      accountType: 'Test Type',
      isDefault: false,
      isReadOnly: false,
    );
    result.data = UnmodifiableListView([calendar]);
    return result;
  }

  @override
  Future<Result<UnmodifiableListView<Event>>> retrieveEvents(
    String? calendarId,
    RetrieveEventsParams? params,
  ) async {
    final result = Result<UnmodifiableListView<Event>>();

    // Filter events based on the date range in params
    final startDate = params?.startDate;
    final endDate = params?.endDate;

    if (startDate == null || endDate == null) {
      result.data = UnmodifiableListView([]);
      return result;
    }

    final filteredEvents = _testEvents.where((event) {
      if (event.start == null) return false;
      return event.start!.isAfter(startDate) && event.start!.isBefore(endDate);
    }).toList();

    result.data = UnmodifiableListView(filteredEvents);
    return result;
  }
}
