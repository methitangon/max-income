import 'package:device_calendar/device_calendar.dart';

class SafeCalendarEvent {
  final String? id;
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final String? description;
  final String? location;
  final String? calendarId;

  SafeCalendarEvent({
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.isAllDay = false,
    this.description,
    this.location,
    this.calendarId,
  });

  @override
  String toString() {
    return 'SafeCalendarEvent{id: $id, title: $title, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, description: $description, location: $location, calendarId: $calendarId}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 'No ID',
      'calendarId': calendarId ?? 'Unknown Calendar',
      'title': title?.trim() ?? 'No Title',
      'start': startTime,
      'end': endTime,
      'allDay': isAllDay,
      'description': description?.trim() ?? '',
      'location': location?.trim() ?? '',
    };
  }

  static SafeCalendarEvent fromEvent(Event event) {
    return SafeCalendarEvent(
      id: event.eventId,
      calendarId: event.calendarId,
      title: event.title?.trim() ?? '',
      startTime: event.start,
      endTime: event.end,
      isAllDay: event.allDay ?? false,
      description: event.description,
      location: event.location,
    );
  }
}
