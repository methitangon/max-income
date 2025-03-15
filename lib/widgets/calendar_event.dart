// widgets/calendar_events.dart

import 'package:flutter/material.dart';
import '../models/safe_calendar_event.dart';
import '../services/calendar_service.dart';
import 'event_card.dart';

// Custom event model to handle null values

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  final CalendarService _calendarService = CalendarService();
  List<SafeCalendarEvent> _events = [];
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
      final hasPermissions = await _calendarService.requestPermissions();
      if (!hasPermissions) {
        setState(() {
          _error = 'Calendar permissions not granted';
          _isLoading = false;
        });
        return;
      }

      // Get today's and tomorrow's events
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day);
      final endDate = DateTime(now.year, now.month, now.day + 1, 23, 59, 59);

      final events = await _calendarService.getEventsForDateRange(
        startDate,
        endDate,
      );

      setState(() {
        _events = events;
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
            Text('No events found'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) => EventCard(event: _events[index]),
    );
  }
}
