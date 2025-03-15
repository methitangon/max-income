import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import '../models/safe_calendar_event.dart';
import '../utils/date_formatter.dart';

class EventCard extends StatefulWidget {
  final SafeCalendarEvent event;
  final VoidCallback onEventUpdated;

  const EventCard({
    super.key,
    required this.event,
    required this.onEventUpdated,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _hasTriggered = false;
  double _swipeRatio = 0.0;
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> _handleEventPaid() async {
    try {
      final String originalTitle = widget.event.title ?? 'Event';
      // Only add checkmark if it's not already there
      final String newTitle =
          originalTitle.startsWith('✅') ? originalTitle : '✅ $originalTitle';

      // Log the modification attempt
      debugPrint('=== Calendar Event Modification ===');
      debugPrint('Event ID: ${widget.event.id}');
      debugPrint('Calendar ID: ${widget.event.calendarId}');
      debugPrint('Original Title: $originalTitle');
      debugPrint('New Title: $newTitle');

      if (widget.event.id == null) {
        debugPrint('Event ID is null');
        return;
      }

      // Retrieve the existing event
      final retrieveEventResult = await _deviceCalendarPlugin.retrieveEvents(
        widget.event.calendarId,
        RetrieveEventsParams(
          eventIds: [widget.event.id!],
        ),
      );

      if (retrieveEventResult?.data?.isNotEmpty ?? false) {
        final Event eventToUpdate = retrieveEventResult!.data!.first;
        eventToUpdate.title = newTitle;

        // Update the event
        final updateResult = await _deviceCalendarPlugin.createOrUpdateEvent(
          eventToUpdate,
        );

        if (updateResult?.isSuccess ?? false) {
          debugPrint('Successfully updated event title');
          // Show success toast
          _showPaidToast();
          // Refresh the events list
          widget.onEventUpdated();
        } else {
          debugPrint(
              'Failed to update event: ${updateResult?.errors?.join(', ')}');
        }
      } else {
        debugPrint(
            'Failed to retrieve event: ${retrieveEventResult?.errors?.join(', ')}');
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
    }
  }

  void _showPaidToast() {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF4DB6AC),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  "${widget.event.title ?? 'Event'} จ่ายแล้ว",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final ratio = details.localPosition.dx / constraints.maxWidth;
            if (ratio >= 1.0 && !_hasTriggered) {
              setState(() {
                _hasTriggered = true;
              });
              _handleEventPaid();
              debugPrint('Event swiped: ${widget.event.title}');
            }
            setState(() {
              _swipeRatio = ratio.clamp(0.0, 1.0);
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              _swipeRatio = 0.0;
              _hasTriggered = false;
            });
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF7986CB).withOpacity(0.9), // Light Indigo
                    const Color(0xFF4DB6AC).withOpacity(0.9), // Light Teal
                    Theme.of(context).cardColor,
                  ],
                  stops: [0.0, _swipeRatio, _swipeRatio],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: _getEventStatusColor(),
                      width: 4,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Swipe hint with animation
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0,
                              end: _swipeRatio > 0 ? 0 : 1,
                            ),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Title and ALL DAY badge
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.event.title ?? 'No Title',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                                if (widget.event.isAllDay)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'ALL DAY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.access_time_rounded,
                        '${DateFormatter.formatDateTime(widget.event.startTime, widget.event.isAllDay)} - ${DateFormatter.formatDateTime(widget.event.endTime, widget.event.isAllDay)}',
                      ),
                      if (widget.event.location?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.location_on_rounded,
                          widget.event.location!,
                        ),
                      ],
                      if (widget.event.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _buildDescriptionTile(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.notes_rounded,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                widget.event.description!,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Text(
                    widget.event.description!,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getEventStatusColor() {
    final now = DateTime.now();
    final start = widget.event.startTime;
    final end = widget.event.endTime;

    if (start == null || end == null) return Colors.grey;

    if (now.isBefore(start)) {
      return Colors.blue; // Upcoming
    } else if (now.isAfter(end)) {
      return Colors.grey; // Past
    } else {
      return Colors.green; // Ongoing
    }
  }
}
