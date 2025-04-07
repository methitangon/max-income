import 'package:equatable/equatable.dart';

abstract class CalendarEventsEvent extends Equatable {
  const CalendarEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendarEvents extends CalendarEventsEvent {}

class RefreshCalendarEvents extends CalendarEventsEvent {}

class MarkEventAsPaid extends CalendarEventsEvent {
  final String eventId;

  const MarkEventAsPaid(this.eventId);

  @override
  List<Object?> get props => [eventId];
}
