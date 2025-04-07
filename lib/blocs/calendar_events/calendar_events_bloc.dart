import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_income/services/calendar_service.dart';
import 'calendar_events_event.dart';
import 'calendar_events_state.dart';

class CalendarEventsBloc
    extends Bloc<CalendarEventsEvent, CalendarEventsState> {
  final CalendarService _calendarService;
  final Set<String> _paidEventIds = {};

  CalendarEventsBloc({required CalendarService calendarService})
      : _calendarService = calendarService,
        super(CalendarEventsInitial()) {
    on<LoadCalendarEvents>(_onLoadCalendarEvents);
    on<RefreshCalendarEvents>(_onRefreshCalendarEvents);
    on<MarkEventAsPaid>(_onMarkEventAsPaid);
  }

  Future<void> _onLoadCalendarEvents(
    LoadCalendarEvents event,
    Emitter<CalendarEventsState> emit,
  ) async {
    await _fetchEvents(emit);
  }

  Future<void> _onRefreshCalendarEvents(
    RefreshCalendarEvents event,
    Emitter<CalendarEventsState> emit,
  ) async {
    await _fetchEvents(emit);
  }

  Future<void> _fetchEvents(Emitter<CalendarEventsState> emit) async {
    emit(CalendarEventsLoading());
    try {
      final events = await _calendarService.getCurrentYearEvents();
      emit(CalendarEventsLoaded(
        events: events,
        paidEventIds: _paidEventIds,
      ));
    } catch (e) {
      emit(CalendarEventsError(e.toString()));
    }
  }

  void _onMarkEventAsPaid(
    MarkEventAsPaid event,
    Emitter<CalendarEventsState> emit,
  ) {
    _paidEventIds.add(event.eventId);
    if (state is CalendarEventsLoaded) {
      final currentState = state as CalendarEventsLoaded;
      emit(CalendarEventsLoaded(
        events: currentState.events,
        paidEventIds: _paidEventIds,
      ));
    }
  }
}
