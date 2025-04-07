import 'package:equatable/equatable.dart';
import 'package:max_income/models/safe_calendar_event.dart';

abstract class CalendarEventsState extends Equatable {
  const CalendarEventsState();

  @override
  List<Object?> get props => [];
}

class CalendarEventsInitial extends CalendarEventsState {}

class CalendarEventsLoading extends CalendarEventsState {}

class CalendarEventsLoaded extends CalendarEventsState {
  final List<SafeCalendarEvent> events;
  final Set<String> paidEventIds;

  const CalendarEventsLoaded({
    required this.events,
    this.paidEventIds = const {},
  });

  @override
  List<Object?> get props => [events, paidEventIds];
}

class CalendarEventsError extends CalendarEventsState {
  final String message;

  const CalendarEventsError(this.message);

  @override
  List<Object?> get props => [message];
}
