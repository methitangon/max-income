import 'package:flutter/material.dart';
import 'package:max_income/widgets/calendar_current_month_events.dart';
import 'package:max_income/widgets/calendar_previous_months_events.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Events'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CalendarCurrentMonthEvents(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CalendarPreviousMonthsEvents(),
            ),
          ],
        ),
      ),
    );
  }
}
