import 'package:flutter/material.dart';
import 'package:max_income/widgets/calendar_event.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CalendarEvents(),
      ),
    );
  }
}
