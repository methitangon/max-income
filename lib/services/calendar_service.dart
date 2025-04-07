import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import '../models/safe_calendar_event.dart';

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<bool> requestPermissions() async {
    var permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
    debugPrint('\n=== Calendar Permissions ===');
    debugPrint('Permissions granted: ${permissionsGranted.data}');
    return permissionsGranted.data ?? false;
  }

  Future<List<Calendar>> getCalendars() async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    debugPrint('\n=== Available Calendars ===');
    debugPrint('Found ${calendarsResult.data?.length ?? 0} calendars');

    if (!calendarsResult.isSuccess || calendarsResult.data == null) {
      throw Exception('Failed to retrieve calendars');
    }

    // Log all calendars
    for (var calendar in calendarsResult.data!) {
      debugPrint('\nCalendar Details:');
      debugPrint('ID: ${calendar.id}');
      debugPrint('Name: ${calendar.name}');
      debugPrint('Account Name: ${calendar.accountName}');
      debugPrint('Account Type: ${calendar.accountType}');
      debugPrint('Is Default: ${calendar.isDefault}');
      debugPrint('Is Read Only: ${calendar.isReadOnly}');
    }

    return calendarsResult.data!;
  }

  Future<List<SafeCalendarEvent>> getCurrentYearEvents() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, 1, 1); // January 1st of current year
    final endDate =
        DateTime(now.year, 12, 31, 23, 59, 59); // December 31st of current year

    debugPrint('\n=== Date Range ===');
    debugPrint('Start Date: $startDate');
    debugPrint('End Date: $endDate');

    final calendars = await getCalendars();
    final allEvents = <SafeCalendarEvent>[];

    for (final calendar in calendars) {
      debugPrint(
          '\nFetching events from calendar: ${calendar.name} (${calendar.id})');

      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(
          startDate: startDate,
          endDate: endDate,
        ),
      );

      debugPrint('Events Result:');
      debugPrint('Success: ${eventsResult.isSuccess}');
      debugPrint('Has Data: ${eventsResult.data != null}');
      debugPrint('Events Count: ${eventsResult.data?.length ?? 0}');

      if (eventsResult.errors?.isNotEmpty == true) {
        debugPrint('Errors: ${eventsResult.errors!.join(", ")}');
      }

      if (eventsResult.data != null) {
        for (final event in eventsResult.data!) {
          try {
            debugPrint('\n=== Raw Event Data ===');
            debugPrint('Event ID: ${event.eventId}');
            debugPrint('Raw Title: "${event.title}"');
            debugPrint(
                'Raw Start: ${event.start} (${event.start?.timeZoneOffset})');
            debugPrint('Raw End: ${event.end} (${event.end?.timeZoneOffset})');
            debugPrint('All Day: ${event.allDay}');
            debugPrint('Description: "${event.description}"');
            debugPrint('Location: "${event.location}"');
            debugPrint('Calendar ID: ${event.calendarId}');

            // Only add events that have the house emoji at the start of the title
            if (event.title?.startsWith('🏠') == true) {
              final safeEvent = SafeCalendarEvent.fromEvent(event);
              allEvents.add(safeEvent);
              debugPrint('Added event with house emoji: ${safeEvent.title}');
            } else {
              debugPrint('Skipped event without house emoji: ${event.title}');
            }
          } catch (e) {
            debugPrint('Error processing event: $e');
            continue;
          }
        }
      }
    }

    // Sort events by start time
    allEvents.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    debugPrint('\n=== Final Events Count ===');
    debugPrint('Total house events found: ${allEvents.length}');

    return allEvents;
  }
}
