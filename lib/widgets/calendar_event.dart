// widgets/calendar_events.dart

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

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
      debugPrint('Calendar permissions granted: ${permissionsGranted.data}');

      if (!(permissionsGranted.data ?? false)) {
        setState(() {
          _error = 'Calendar permissions not granted';
          _isLoading = false;
        });
        return;
      }

      // Get calendars
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
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
        debugPrint('\nCalendar:');
        debugPrint('- ID: ${calendar.id}');
        debugPrint('- Name: ${calendar.name}');
        debugPrint('- Account Name: ${calendar.accountName}');
        debugPrint('- Is Default: ${calendar.isDefault}');
      }

      // Get the default calendar or first available
      final calendar = calendarsResult.data!.firstWhere(
        (cal) => cal.isDefault == true,
        orElse: () => calendarsResult.data!.first,
      );

      debugPrint('\nSelected calendar: ${calendar.name} (${calendar.id})');

      // Get events
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));
      final endDate = now.add(const Duration(days: 30));

      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
      );

      debugPrint('\nEvents result:');
      debugPrint('Success: ${eventsResult.isSuccess}');
      debugPrint('Error: ${eventsResult.errors?.join(", ")}');
      debugPrint('Events count: ${eventsResult.data?.length ?? 0}');

      if (eventsResult.data != null) {
        final safeEvents = <Map<String, dynamic>>[];

        try {
          final events = eventsResult.data!;
          debugPrint('\nEvents found: ${events.length}');

          for (final event in events) {
            try {
              debugPrint('\nProcessing event:');
              debugPrint('- ID: ${event.eventId}');
              debugPrint('- Title: ${event.title}');
              debugPrint('- Start: ${event.start}');

              // Create a safe map of event data
              final safeEvent = {
                'id': event.eventId ?? 'No ID',
                'title': event.title ?? 'No Title',
                'start': event.start?.toString() ?? 'No Start Date',
                'end': event.end?.toString() ?? 'No End Date',
                'allDay': event.allDay ?? false,
                'description': event.description ?? 'No Description',
                'location': event.location ?? 'No Location',
                'attendees': event.attendees?.length.toString() ?? '0',
                'reminders': event.reminders?.length.toString() ?? '0',
              };

              debugPrint('Converted to safe event: $safeEvent');
              safeEvents.add(safeEvent);
            } catch (e, stack) {
              debugPrint('Error processing individual event: $e');
              debugPrint('Stack trace: $stack');
              continue;
            }
          }
        } catch (e, stack) {
          debugPrint('Error processing events: $e');
          debugPrint('Stack trace: $stack');
          debugPrint('Events data type: ${eventsResult.data.runtimeType}');
        }

        setState(() {
          _events = safeEvents;
          _isLoading = false;
        });
      } else {
        setState(() {
          _events = [];
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      debugPrint('Error fetching events: $e');
      debugPrint('Stack trace: $stack');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
              const Text('Raw Calendar Events',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_events.isEmpty) {
      return const Center(
        child: Text('No events found'),
      );
    }

    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Event ID: ${event['id']}'),
                const SizedBox(height: 4),
                Text('Title: ${event['title']}'),
                const SizedBox(height: 4),
                Text('Start: ${event['start']}'),
                const SizedBox(height: 4),
                Text('End: ${event['end']}'),
                const SizedBox(height: 4),
                Text('All Day: ${event['allDay']}'),
                const SizedBox(height: 4),
                Text('Description: ${event['description']}'),
                const SizedBox(height: 4),
                Text('Location: ${event['location']}'),
                const SizedBox(height: 4),
                Text('Attendees: ${event['attendees']}'),
                const SizedBox(height: 4),
                Text('Reminders: ${event['reminders']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
