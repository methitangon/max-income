import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('MMM d, y');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _fullFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String formatDateTime(DateTime? dateTime, bool isAllDay) {
    if (dateTime == null) return 'No time set';
    if (isAllDay) return _dateFormat.format(dateTime);
    return '${_dateFormat.format(dateTime)} ${_timeFormat.format(dateTime)}';
  }

  static String formatFull(DateTime dateTime) {
    return _fullFormat.format(dateTime);
  }
}
