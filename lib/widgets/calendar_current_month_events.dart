// widgets/calendar_events.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/safe_calendar_event.dart';
import '../services/calendar_service.dart';
import 'event_card.dart';

class CalendarCurrentMonthEvents extends StatefulWidget {
  final CalendarService? calendarService;

  const CalendarCurrentMonthEvents({
    super.key,
    this.calendarService,
  });

  @override
  State<CalendarCurrentMonthEvents> createState() =>
      _CalendarCurrentMonthEventsState();
}

class _CalendarCurrentMonthEventsState
    extends State<CalendarCurrentMonthEvents> {
  late final CalendarService _calendarService;
  List<SafeCalendarEvent> _events = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _calendarService = widget.calendarService ?? CalendarService();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final hasPermissions = await _calendarService.requestPermissions();
      if (!hasPermissions) {
        setState(() {
          _error = 'Calendar permissions not granted';
          _isLoading = false;
        });
        return;
      }

      final events = await _calendarService.getCurrentMonthEvents();

      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events for ${DateFormat.MMMM().format(DateTime.now())}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchEvents,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContent(),
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
            Text('No events found'),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _events.length,
      itemBuilder: (context, index) => EventCard(
        event: _events[index],
        onEventUpdated: _fetchEvents,
      ),
    );
  }
}
