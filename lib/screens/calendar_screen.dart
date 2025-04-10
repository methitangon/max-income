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
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalendarCurrentMonthEvents(),
                SizedBox(height: 16),
                CalendarPreviousMonthsEvents(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
