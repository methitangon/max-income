import 'package:device_calendar/device_calendar.dart';
import '../models/safe_calendar_event.dart';

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin;

  CalendarService({DeviceCalendarPlugin? deviceCalendarPlugin})
      : _deviceCalendarPlugin = deviceCalendarPlugin ?? DeviceCalendarPlugin();

  Future<bool> requestPermissions() async {
    final permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
    return permissionsGranted.data ?? false;
  }

  Future<List<Calendar>> getCalendars() async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

    if (!calendarsResult.isSuccess || calendarsResult.data == null) {
      throw Exception('Failed to retrieve calendars');
    }

    return calendarsResult.data!;
  }

  Future<List<SafeCalendarEvent>> getCurrentYearEvents() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, 1, 1);
    final endDate = DateTime(now.year, 12, 31, 23, 59, 59);

    final calendars = await getCalendars();
    final allEvents = <SafeCalendarEvent>[];

    for (final calendar in calendars) {
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(
          startDate: startDate,
          endDate: endDate,
        ),
      );

      if (eventsResult.data != null) {
        for (final event in eventsResult.data!) {
          try {
            if (event.title?.startsWith('🏠') == true) {
              final safeEvent = SafeCalendarEvent.fromEvent(event);
              allEvents.add(safeEvent);
            }
          } catch (e) {
            continue;
          }
        }
      }
    }

    allEvents.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    return allEvents;
  }

  Future<List<SafeCalendarEvent>> getCurrentMonthEvents() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final calendars = await getCalendars();
    final allEvents = <SafeCalendarEvent>[];

    for (final calendar in calendars) {
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(
          startDate: startDate,
          endDate: endDate,
        ),
      );

      if (eventsResult.data != null) {
        for (final event in eventsResult.data!) {
          try {
            if (event.title?.startsWith('🏠') == true) {
              final safeEvent = SafeCalendarEvent.fromEvent(event);
              allEvents.add(safeEvent);
            }
          } catch (e) {
            continue;
          }
        }
      }
    }

    allEvents.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    return allEvents;
  }

  Future<List<SafeCalendarEvent>> getPreviousMonthsEvents() async {
    final now = DateTime.now();

    // If current month is January, return empty list
    if (now.month == 1) {
      return [];
    }

    final startDate = DateTime(now.year, 1, 1);
    final endDate = DateTime(now.year, now.month, 0, 23, 59, 59);

    final calendars = await getCalendars();
    final allEvents = <SafeCalendarEvent>[];

    for (final calendar in calendars) {
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(
          startDate: startDate,
          endDate: endDate,
        ),
      );

      if (eventsResult.data != null) {
        for (final event in eventsResult.data!) {
          try {
            if (event.title?.startsWith('🏠') == true) {
              final safeEvent = SafeCalendarEvent.fromEvent(event);
              allEvents.add(safeEvent);
            }
          } catch (e) {
            continue;
          }
        }
      }
    }

    allEvents.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    return allEvents;
  }
}
