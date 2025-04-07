// widgets/calendar_events.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_income/blocs/calendar_events/calendar_events_bloc.dart';
import 'package:max_income/blocs/calendar_events/calendar_events_event.dart';
import 'package:max_income/blocs/calendar_events/calendar_events_state.dart';
import 'package:max_income/models/safe_calendar_event.dart';
import 'package:max_income/services/calendar_service.dart';
import 'package:max_income/widgets/calendar_event_item.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarEventsBloc(
        calendarService: CalendarService(),
      )..add(LoadCalendarEvents()),
      child: BlocBuilder<CalendarEventsBloc, CalendarEventsState>(
        builder: (context, state) {
          if (state is CalendarEventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CalendarEventsError) {
            return Center(child: Text(state.message));
          }

          if (state is CalendarEventsLoaded) {
            return _buildEventList(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEventList(CalendarEventsLoaded state) {
    if (state.events.isEmpty) {
      return const Center(
        child: Text('No house events found in the current year'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CalendarEventsBloc>().add(RefreshCalendarEvents());
      },
      child: ListView.builder(
        itemCount: state.events.length,
        itemBuilder: (context, index) {
          final event = state.events[index];
          return CalendarEventItem(
            event: event,
            isPaid: state.paidEventIds.contains(event.id),
            onMarkAsPaid: () {
              context.read<CalendarEventsBloc>().add(
                    MarkEventAsPaid(event.id),
                  );
            },
          );
        },
      ),
    );
  }
}
