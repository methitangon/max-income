// widgets/calendar_events.dart

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Custom event model to handle null values
class SafeCalendarEvent {
  final String? id;
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;

  SafeCalendarEvent({
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.isAllDay = false,
  });

  @override
  String toString() {
    return 'SafeCalendarEvent{id: $id, title: $title, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay}';
  }

  static SafeCalendarEvent fromEvent(Event event) {
    String? safeTitle;
    try {
      safeTitle = event.title?.trim();
    } catch (e) {
      debugPrint('ç: $e');
    }

    return SafeCalendarEvent(
      id: event.eventId,
      title: safeTitle ?? '',
      startTime: event.start,
      endTime: event.end,
      isAllDay: event.allDay ?? false,
    );
  }
}

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  final DateFormat _dateFormat = DateFormat('MMM d, y');
  final DateFormat _timeFormat = DateFormat('h:mm a');
  final DateFormat _fullFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Request permissions
      var permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      debugPrint('\n=== Calendar Permissions ===');
      debugPrint('Permissions granted: ${permissionsGranted.data}');

      if (!(permissionsGranted.data ?? false)) {
        setState(() {
          _error = 'Calendar permissions not granted';
          _isLoading = false;
        });
        return;
      }

      // Get calendars
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      debugPrint('\n=== Available Calendars ===');
      debugPrint('Found ${calendarsResult.data?.length ?? 0} calendars');

      if (!calendarsResult.isSuccess ||
          calendarsResult.data == null ||
          calendarsResult.data!.isEmpty) {
        setState(() {
          _error = 'No calendars found';
          _isLoading = false;
        });
        return;
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

      // Get all calendars instead of just the default one
      final calendars = calendarsResult.data!;
      debugPrint('\n=== Fetching Events from All Calendars ===');

      final now = DateTime.now();
      // Extend the range to include tomorrow
      final startDate = DateTime(now.year, now.month, now.day);
      final endDate = DateTime(now.year, now.month, now.day + 1, 23, 59, 59);

      debugPrint('Search Period:');
      debugPrint(
          'Start: ${_fullFormat.format(startDate)} (${startDate.timeZoneOffset})');
      debugPrint(
          'End: ${_fullFormat.format(endDate)} (${endDate.timeZoneOffset})');

      final allEvents = <Map<String, dynamic>>[];

      // Fetch events from all calendars
      for (final calendar in calendars) {
        debugPrint(
            '\nFetching events from calendar: ${calendar.name} (${calendar.id})');

        final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendar.id,
          RetrieveEventsParams(startDate: startDate, endDate: endDate),
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
              debugPrint(
                  'Raw End: ${event.end} (${event.end?.timeZoneOffset})');
              debugPrint('All Day: ${event.allDay}');
              debugPrint('Description: "${event.description}"');
              debugPrint('Location: "${event.location}"');
              debugPrint('Calendar ID: ${event.calendarId}');

              // Convert times to local
              final startLocal = event.start?.toLocal();
              final endLocal = event.end?.toLocal();

              debugPrint('\nProcessed Times:');
              debugPrint(
                  'Start (Local): ${startLocal != null ? _fullFormat.format(startLocal) : "null"} (${startLocal?.timeZoneOffset})');
              debugPrint(
                  'End (Local): ${endLocal != null ? _fullFormat.format(endLocal) : "null"} (${endLocal?.timeZoneOffset})');

              final safeEvent = {
                'id': event.eventId ?? 'No ID',
                'calendarId': event.calendarId ?? 'Unknown Calendar',
                'title': event.title?.trim() ?? 'No Title',
                'start': startLocal,
                'end': endLocal,
                'allDay': event.allDay ?? false,
                'description': event.description?.trim() ?? '',
                'location': event.location?.trim() ?? '',
              };

              debugPrint('\nProcessed Event:');
              debugPrint(safeEvent.toString());

              allEvents.add(safeEvent);
            } catch (e) {
              debugPrint('Error processing event: $e');
              continue;
            }
          }
        }
      }

      // Sort all events by start time
      allEvents.sort((a, b) {
        final aStart = a['start'] as DateTime?;
        final bStart = b['start'] as DateTime?;
        if (aStart == null || bStart == null) return 0;
        return aStart.compareTo(bStart);
      });

      debugPrint('\n=== Final Events Count ===');
      debugPrint('Total events found: ${allEvents.length}');

      setState(() {
        _events = allEvents;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('\n=== Error ===');
      debugPrint('Error fetching events: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime? dateTime, bool isAllDay) {
    if (dateTime == null) return 'No time set';
    if (isAllDay) return _dateFormat.format(dateTime);
    return '${_dateFormat.format(dateTime)} ${_timeFormat.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calendar Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchEvents,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading events...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      );
    }

    if (_events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No events found for this month'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        final bool isAllDay = event['allDay'] as bool;
        final DateTime? startTime = event['start'] as DateTime?;
        final DateTime? endTime = event['end'] as DateTime?;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    event['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isAllDay)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ALL DAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_formatDateTime(startTime, isAllDay)} - ${_formatDateTime(endTime, isAllDay)}',
                      ),
                    ),
                  ],
                ),
                if (event['location'].isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event['location'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (event['description'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notes, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ExpansionTile(
                          title: Text(
                            event['description'],
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: Text(
                                event['description'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
